import UIKit
import Foundation

import UIKit
import Foundation

class CalculatorKeyboardView: UIView {
  weak var input: InputCalculator?
  
  private let keys: [[String]] = [
    ["AC", "÷", "×", "back"],
    ["7", "8", "9", "-"],
    ["4", "5", "6", "+"],
    ["1", "2", "3", "="],
    ["000", "0"]
  ]
  private let SEPARATOR_WIDTH: CGFloat = 4
  private let specialKeys: Set<String> = ["=", "-", "×", "÷", "AC", "back", "+"]
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func setKeyboardColor(_ color: UIColor) {
    self.setup(color)
  }
  
  private func setup(_ color: UIColor = UIColor(hex: "#d9d9d9")) {
    self.subviews.forEach { $0.removeFromSuperview() }
    
    backgroundColor = UIColor(hex: "#f2f2f6")
    let buttonWidth = (UIScreen.main.bounds.width - SEPARATOR_WIDTH * 2 - 3 * SEPARATOR_WIDTH) / 4
    let buttonHeight: CGFloat = (290 - SEPARATOR_WIDTH * 2 - 4 * SEPARATOR_WIDTH) / 5
    
    // Create a wrapper view
    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(contentView)
    
    // Set contentView constraints
    NSLayoutConstraint.activate([
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SEPARATOR_WIDTH),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SEPARATOR_WIDTH),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: SEPARATOR_WIDTH),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SEPARATOR_WIDTH)
    ])
    
    // Add buttons to the wrapper view
    var yOffset: CGFloat = 0
    for row in keys {
      var xOffset: CGFloat = 0
      for key in row {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 8
        button.setTitle(key, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        button.nativeID = key
        
        var buttonFrame = CGRect(x: xOffset, y: yOffset, width: buttonWidth, height: buttonHeight)
        if key == "=" {
          buttonFrame.size.height = buttonHeight * 2 + SEPARATOR_WIDTH
        }
        if key == "000" {
          buttonFrame.size.width = buttonWidth * 2 + SEPARATOR_WIDTH
        }
        
        button.frame = buttonFrame
        
        if key == "back" {
          button.setTitle("", for: .normal)
          let image = UIImage(systemName: "delete.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
          button.setImage(image, for: .normal)
          button.tintColor = .white
        }
        
        if specialKeys.contains(key) {
          button.setTitleColor(.white, for: .normal)
          button.backgroundColor = color.withAlphaComponent(0.5)
          if key == "=" {
            button.backgroundColor = color
          }
        }
        
        button.addTarget(self, action: #selector(keyPressed(_:)), for: .touchUpInside)
        contentView.addSubview(button)
        
        // Adjust xOffset for the next button in the row
        xOffset += buttonFrame.width + SEPARATOR_WIDTH
      }
      // Adjust yOffset for the next row
      yOffset += buttonHeight + SEPARATOR_WIDTH
    }
  }
  
  
  @objc private func keyPressed(_ sender: UIButton) {
    guard let key = sender.nativeID else { return }
    switch key {
    case "AC":
      input?.clearText()
    case "back":
      input?.onBackSpace()
    case "=":
      input?.calculateResult()
    case "+", "-", "÷", "×":
      input?.keyDidPress(" \(key) ")
    default:
      input?.keyDidPress(key)
    }
  }
}
