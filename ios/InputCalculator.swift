import Foundation
import UIKit

@objc(RCTInputCalculator)
class RCTInputCalculator: RCTBaseTextInputViewManager {
  override func view() -> UIView! {
    return InputCalculator(bridge: bridge)
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
}

class InputCalculator: RCTSinglelineTextInputView {
  var bridge: RCTBridge?
  var keyboardView: CalculatorKeyboardView?
  
  @objc var value: String = ""
  
  @objc var keyboardColor: UIColor = UIColor(hex: "#d9d9d9") {
    didSet {
      self.keyboardView?.setKeyboardColor(keyboardColor)
    }
  }
  
  override init(bridge: RCTBridge) {
    super.init(bridge: bridge)
    self.bridge = bridge
    self.keyboardView = CalculatorKeyboardView()
    self.keyboardView!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 290)
    self.keyboardView!.input = self
    
    backedTextInputView.inputView = self.keyboardView
    backedTextInputView.inputView?.reloadInputViews()
  }
  
  
  func keyDidPress(_ key: String) {
    backedTextInputView.insertText(key)
    value += key
    if let bridge = bridge {
      bridge.eventDispatcher().sendTextEvent(with: .change, reactTag: reactTag, text: value, key: "\(key)", eventCount: 1)
    }
  }
  
  func clearText() {
    value = ""
    (backedTextInputView as? UITextField)?.text = ""
    if let bridge = bridge {
      bridge.eventDispatcher().sendTextEvent(with: .change, reactTag: reactTag, text: value, key: "clear", eventCount: 1)
    }
  }
  
  func onBackSpace() {
    value = value.dropLast().description
    DispatchQueue.main.async {
      if let range = self.backedTextInputView.selectedTextRange,
         let fromRange = self.backedTextInputView.position(from: range.start, offset: -1),
         let newRange = self.backedTextInputView.textRange(from: fromRange, to: range.start)
      {
        self.backedTextInputView.replace(newRange, withText: "")
      }
    }
    
    if let bridge = bridge {
      bridge.eventDispatcher().sendTextEvent(with: .change, reactTag: reactTag, text: value, key: "back", eventCount: 1)
    }
  }
  
  func calculateResult() {
    guard let textField = backedTextInputView as? UITextField,
          let text = textField.text?.replacingOccurrences(of: "×", with: "*").replacingOccurrences(of: "÷", with: "/")
    else {
      return
    }
    
    let pattern = "^\\s*(-?\\d+(\\.\\d+)?\\s*[-+*/]\\s*)*-?\\d+(\\.\\d+)?\\s*$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: text.utf16.count)
    
    if regex?.firstMatch(in: text, options: [], range: range) != nil {
      let expression = NSExpression(format: text)
      if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
        textField.text = result.stringValue
        value = result.stringValue
        if let bridge = bridge {
          bridge.eventDispatcher().sendTextEvent(with: .change, reactTag: reactTag, text: value, key: "=", eventCount: 1)
          textField.reactBlur()
        }
      }
    }
    else {
      print("Invalid expression")
    }
  }
  
}

