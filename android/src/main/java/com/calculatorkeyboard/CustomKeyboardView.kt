package com.calculatorkeyboard

import android.annotation.SuppressLint
import android.graphics.Color
import android.graphics.drawable.GradientDrawable
import android.view.Gravity
import android.widget.Button
import android.widget.ImageButton
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.graphics.ColorUtils
import com.facebook.react.uimanager.ThemedReactContext
import org.mariuszgromada.math.mxparser.Expression


@SuppressLint("SetTextI18n", "ViewConstructor")
class CustomKeyboardView(context: ThemedReactContext, private val editText: CalculatorEditText) :
  ConstraintLayout(context) {
  private val keys = listOf(
    listOf("AC", "÷", "×", "back"),
    listOf("7", "8", "9", "-"),
    listOf("4", "5", "6", "+"),
    listOf("1", "2", "3", "="),
    listOf("000", "0")
  )
  private val specialKeys = listOf("=", "-", "×", "÷", "AC", "back", "+")
  private val separatorWidth = 8f
  private var keyboardColor: Int = Color.parseColor("#F7ACD5")

  init {
    val activity = context.currentActivity as? AppCompatActivity
    if (activity != null) {
      val displayMetrics = resources.displayMetrics
      val widthButton = (displayMetrics.widthPixels - separatorWidth * 2 - 3 * separatorWidth) / 4f

      renderUI(widthButton)
    }

  }

  private fun renderUI(buttonWidth: Float) {
    val buttonHeight = buttonWidth / 2
    var yOffset = separatorWidth
    for ((_, row) in keys.withIndex()) {
      var xOffset = separatorWidth
      for ((_, key) in row.withIndex()) {
        val width = if (key == "000") buttonWidth * 2 + separatorWidth else buttonWidth
        val height = if (key == "=") buttonWidth + separatorWidth else buttonHeight

        val button = if (key == "back") {
          createImageButton(key, xOffset, yOffset, buttonWidth.toInt(), buttonHeight.toInt())
        } else {
          createButton(key, xOffset, yOffset, width.toInt(), height.toInt())
        }

        addView(button)

        xOffset += width + separatorWidth
      }
      yOffset += buttonHeight + separatorWidth
    }
  }

  private fun createButton(
    key: String,
    xOffset: Float,
    yOffset: Float,
    buttonWidth: Int,
    buttonHeight: Int,
  ): Button {
    val specialKeys = listOf("=", "-", "×", "÷", "AC", "back", "+")
    return Button(context).apply {
      val shapeInit = GradientDrawable().apply {
        shape = GradientDrawable.RECTANGLE
        cornerRadius = 24f
        setColor(Color.WHITE)
        setBackgroundColor(Color.WHITE)
      }
      gravity = Gravity.CENTER
      background = shapeInit
      text = key
      setTypeface(typeface)
      textSize = 24.toFloat()
      setTextColor(Color.BLACK)
      stateListAnimator = null
      layoutParams = LayoutParams(
        buttonWidth,
        buttonHeight
      ).apply {
        constrainedWidth = false
      }

      if (specialKeys.contains(key)) {
        if (key == "=") {
          background = GradientDrawable().apply {
            shape = GradientDrawable.RECTANGLE
            cornerRadius = 24f
            setColor(Color.parseColor("#EB2F96"))
          }
        }
        background = GradientDrawable().apply {
          shape = GradientDrawable.RECTANGLE
          cornerRadius = 24f
          setColor(Color.parseColor("#F7ACD5"))
        }
        setTextColor(Color.WHITE)
      }


      translationX = xOffset.toInt().toFloat()
      translationY = yOffset.toInt().toFloat()
      setOnClickListener { onKeyPress(key) }
    }
  }

  private fun createImageButton(
    key: String,
    xOffset: Float,
    yOffset: Float,
    buttonWidth: Int,
    buttonHeight: Int,
  ): ImageButton {
    return ImageButton(context).apply {
      val shapeInit = GradientDrawable().apply {
        shape = GradientDrawable.RECTANGLE
        cornerRadius = 24f
        setColor(Color.parseColor("#F7ACD5"))
      }
      background = shapeInit
      stateListAnimator = null
      layoutParams = LayoutParams(
        buttonWidth,
        buttonHeight
      ).apply {
        constrainedWidth = false
      }
      translationX = xOffset
      translationY = yOffset
      setImageResource(android.R.drawable.ic_input_delete)
      setOnClickListener { onKeyPress(key) }
    }
  }

  fun updateButtonColors(color: Int) {
    keyboardColor = color
    for (i in 0 until childCount) {
      val child = getChildAt(i)
      if (child is Button) {
        val key = child.text.toString()
        if (specialKeys.contains(key)) {
          if (key == "=") {
            child.background = GradientDrawable().apply {
              shape = GradientDrawable.RECTANGLE
              cornerRadius = 24f
              setColor(keyboardColor)
            }
          } else {
            child.background = GradientDrawable().apply {
              shape = GradientDrawable.RECTANGLE
              cornerRadius = 24f
              setColor(ColorUtils.setAlphaComponent(keyboardColor, 128))
            }
          }
          child.setTextColor(Color.WHITE)
        }
      } else if (child is ImageButton) {
        child.background = GradientDrawable().apply {
          shape = GradientDrawable.RECTANGLE
          cornerRadius = 24f
          setColor(ColorUtils.setAlphaComponent(keyboardColor, 128))
        }
      }
    }
  }

  private fun onKeyPress(key: String) {
    when (key) {
      "AC" -> {
        clearText()
      }

      "back" -> {
        onBackSpace()
      }

      "=" -> {
        calculateResult()
      }

      "×", "+", "-", "÷" -> keyDidPress(" $key ")
      else -> {
        editText.text?.insert(editText.selectionStart, key)
      }
    }
  }

  private fun keyDidPress(key: String) {
    println("Key pressed: $key")
    editText.text?.replace(editText.selectionStart, editText.selectionEnd, key)
  }

  private fun clearText() {
    editText.text?.clear()
  }

  private fun onBackSpace() {
    val start = editText.selectionStart
    val end = editText.selectionEnd
    if (start > 0) {
      val newText = end.let { editText.text?.replaceRange(start - 1, it, "") }
      editText.setText(newText)
      editText.setSelection(start - 1)
    }
  }

  private fun calculateResult() {
    val text = editText?.text.toString().replace("×", "*").replace("÷", "/")
    val pattern = "^\\s*(-?\\d+(\\.\\d+)?\\s*[-+*/]\\s*)*-?\\d+(\\.\\d+)?\\s*$"
    val regex = Regex(pattern)
    if (regex.matches(text)) {
      try {
        val result = eval(text).toString()
        editText.setTextKeepState(result)
      } catch (e: Exception) {
        e.printStackTrace()
      }
    } else {
      println("Invalid expression")
    }
  }

  private fun eval(str: String): Long? {
    val e = Expression(str)
    println("Expression: $e")
    return if (e.checkSyntax()) {
      e.calculate().toLong()
    } else {
      null
    }
  }

}
