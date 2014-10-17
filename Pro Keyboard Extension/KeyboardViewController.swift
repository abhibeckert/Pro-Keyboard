//
//  KeyboardViewController.swift
//  Pro Keyboard Extension
//
//  Created by Abhi Beckert on 12/10/2014.
//
//  This is free and unencumbered software released into the public domain.
//  See unlicense.org
//

import UIKit

class KeyboardViewController: UIInputViewController {
  
  // querty
  let quertyKeyStates = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "'"],
    ["↑", "z", "x", "c", "v", "b", "n", "m", ",", "."],
    ["⊙", "⌥", " ", "←", "↵"]
  ]
  
  let quertyShiftKeyStates = [
    ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
    ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P"],
    ["A", "S", "D", "F", "G", "H", "J", "K", "L", ":"],
    ["↑", "Z", "X", "C", "V", "B", "N", "M", "<", ">"],
    ["⊙", "⌥", " ", "←", "↵"]
  ]
  
  // dvorak
  let dvorakKeyStates = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"],
    ["'", ",", ".", "p", "y", "f", "g", "c", "r", "l"],
    ["a", "o", "e", "u", "i", "d", "h", "t", "n", "s"],
    ["↑", "q", "j", "k", "x", "b", "m", "w", "v", "z"],
    ["⊙", "⌥", " ", "←", "↵"]
  ]
  
  let dvorakShiftKeyStates = [
    ["!", "@", "#", "$", "%", "^", "&", "*", "(", ")"],
    ["\"", "<", ">", "P", "Y", "F", "G", "C", "R", "L"],
    ["A", "O", "E", "U", "I", "D", "H", "T", "N", "S"],
    ["↑", "Q", "J", "K", "X", "B", "M", "W", "V", "Z"],
    ["⊙", "⌥", " ", "←", "↵"]
  ]
  
  let altKeyStates = [
    ["`", "~", "€", "£", "¢", "•", "[", "]", "{", "}"],
    ["≤", "≥", "π", "∞", "÷", "≠", "=", "+", "-", "/"],
    ["ˆ", "_", "“", "”", "‘", "’", "«", "»", "—", "\\"],
    ["↑", "`", "´", "¨", "ˆ", "˙", "˜", ":", ";", "?"],
    ["⚙", "⌥", " ", "←", "↵"]
  ]
  
  let shiftAltKeyStates = [
    ["`", "~", "€", "£", "¢", "•", "[", "]", "{", "}"],
    ["≤", "≥", "π", "∞", "÷", "≠", "=", "+", "-", "/"],
    ["ˆ", "_", "“", "”", "‘", "’", "«", "»", "—", "\\"],
    ["↑", "`", "´", "¨", "ˆ", "˙", "˜", ":", ";", "?"],
    ["⚙", "⌥", " ", "←", "↵"]
  ]
  
  var activeKeyStates: [[String]] = []
  
  var keyLayers: [[KeyLayer]] = []
  
  var keyboardRowViews: [UIView] = []
  
  var dvorakActive = false
  var shiftStateActive = false
  var altStateActive = false
  
  var heightConstraint: NSLayoutConstraint!

  let portraitHeight = 253.0
  let landscapeHeight = 203.0
  var isLandscape = false
  
  var highlightedKeys: [(key:String, touch:UITouch)] = []
  
  var keypressGestureRecognizer: KeyboardPressGestureRecognizer!
  
  override init()
  {
    super.init()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
//  @IBOutlet var nextKeyboardButton: UIButton!
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    
//    let keyboardHeight: CGFloat = 253
//    
//    let heightConstraint = NSLayoutConstraint(item: self.inputView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: keyboardHeight)
//    
//    self.inputView.addConstraint(heightConstraint)
    
    self.updateKeys()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.keypressGestureRecognizer = KeyboardPressGestureRecognizer({(touch: UITouch) -> () in
      let title = self.keyTitleForPosition(touch.locationInView(nil))
      
      self.highlightedKeys.append((key:title, touch:touch))
      
      self.keyPressed(title)
      }, touchEnded: {(touch: UITouch) -> () in
        var newHighlightedKeys: [(key:String, touch:UITouch)] = []
        
        for highlightedKey in self.highlightedKeys {
          if highlightedKey.touch != touch {
            newHighlightedKeys.append(highlightedKey)
          }
        }
        self.highlightedKeys = newHighlightedKeys
        
        self.updateKeys()
    })
    self.keypressGestureRecognizer.keyTitles = self.dvorakKeyStates
    
//    self.createKeys()
    
    let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    keyboardView.addGestureRecognizer(self.keypressGestureRecognizer)
    self.inputView.addSubview(keyboardView)
    
    keyboardView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    self.inputView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": keyboardView]))
    self.inputView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": keyboardView]))
    
    let scale = UIScreen.mainScreen().scale
    
    for keys in self.dvorakKeyStates {
      var layers: [KeyLayer] = []
      for title in keys {
        let layer = KeyLayer()
        
        layer.contentsScale = scale
        
        layers.append(layer)
        keyboardView.layer.addSublayer(layer)
      }
      self.keyLayers.append(layers)
    }
    
    self.heightConstraint = NSLayoutConstraint(item: self.inputView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: CGFloat(self.portraitHeight))
    
    self.loadActiveKeyState()
    
      //[NSLayoutConstraint constraintWithItem:self.inputView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:self.portraitHeight];
    
//    self.nextKeyboardButton = UIButton.buttonWithType(.System) as UIButton
//    
//    self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
//    self.nextKeyboardButton.sizeToFit()
//    self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//    
//    self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
//    
//    self.inputView.addSubview(self.nextKeyboardButton)
//    
//    var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.inputView, attribute: .Left, multiplier: 1.0, constant: 0.0)
//    var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.inputView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
//    self.inputView.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated
  }
  
  override func textWillChange(textInput: UITextInput) {
    // The app is about to change the document's contents. Perform any preparation here.
  }
  
  override func textDidChange(textInput: UITextInput) {
    // The app has just changed the document's contents, the document context has been updated.
    
    var textColor: UIColor
    var proxy = self.textDocumentProxy as UITextDocumentProxy
    if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
      textColor = UIColor.whiteColor()
    } else {
      textColor = UIColor.blackColor()
    }
//    self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
  }
  
  func createKeys()
  {
    for keys in self.dvorakKeyStates {
      var rowView = createRowOfButtons(keys)
      
      self.inputView.addSubview(rowView)
      
      rowView.setTranslatesAutoresizingMaskIntoConstraints(false)
      
      self.keyboardRowViews.append(rowView)
    }
    addConstraintsToInputView(self.inputView, rowViews: self.keyboardRowViews)
  }
  
  func loadActiveKeyState()
  {
    var keyStates = self.dvorakKeyStates
    if (!self.dvorakActive) {
      keyStates = quertyKeyStates
    }
    
    if (self.shiftStateActive && self.altStateActive) {
      keyStates = self.shiftAltKeyStates
    } else if (self.shiftStateActive) {
      keyStates = self.dvorakActive ? self.dvorakShiftKeyStates : self.quertyShiftKeyStates
    } else if (self.altStateActive) {
      keyStates = self.altKeyStates
    }
    
    self.activeKeyStates = keyStates
    
    self.updateKeys()
    self.keypressGestureRecognizer.keyTitles = self.activeKeyStates
  }
  
  func createRowOfButtons(buttonTitles: [NSString]) -> UIView {
    
    var buttons = [UIButton]()
    var keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))
    
    for buttonTitle in buttonTitles{
      
      let button = createButtonWithTitle(buttonTitle)
      buttons.append(button)
      keyboardRowView.addSubview(button)
    }
    
    addIndividualButtonConstraints(buttons, rowView: keyboardRowView)
    
    return keyboardRowView
  }
  
  func createButtonWithTitle(title: String) -> UIButton {
    let button = UIButton.buttonWithType(.System) as UIButton
    button.frame = CGRectMake(0, 0, 20, 20)
    button.setTitle(title, forState: .Normal)
    button.sizeToFit()
    button.titleLabel?.font = UIFont.boldSystemFontOfSize(21)
    button.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    var dark = false
    if title == "↑" && self.shiftStateActive {
      dark = true
    } else if title == "⌥" && self.altStateActive {
      dark = true
    }
    
    if (!dark) {
      button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
    } else {
      button.backgroundColor = UIColor(white: 0.75, alpha: 1.0)
    }
    button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    
    button.addTarget(self, action: "didTapButton:", forControlEvents: .TouchUpInside)
    
    return button
  }
  
  func addIndividualButtonConstraints(buttonsInRow: [UIButton], rowView: UIView){
    
    for (index, button) in enumerate(buttonsInRow) {
      
      var topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: rowView, attribute: .Top, multiplier: 1.0, constant: 1)
      
      var bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: rowView, attribute: .Bottom, multiplier: 1.0, constant: -1)
      
      var rightConstraint : NSLayoutConstraint!
      
      if index == buttonsInRow.count - 1 {
        
        rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: rowView, attribute: .Right, multiplier: 1.0, constant: -1)
        
      }else{
        
        let nextButton = buttonsInRow[index+1]
        rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -1)
      }
      
      
      var leftConstraint : NSLayoutConstraint!
      
      if index == 0 {
        
        leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: rowView, attribute: .Left, multiplier: 1.0, constant: 1)
      rowView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        
      }else{
        
        let prevtButton = buttonsInRow[index-1]
        leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: 1)
        
        let firstButton = buttonsInRow[0]
        var widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
        if (button.titleLabel?.text == " ") {
          widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 140)
        }
        
        rowView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint, widthConstraint])
      }
      
    }
  }
  
  func addConstraintsToInputView(inputView: UIView, rowViews: [UIView])
  {
    for (index, rowView) in enumerate(rowViews) {
      var rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .Right, relatedBy: .Equal, toItem: inputView, attribute: .Right, multiplier: 1.0, constant: 1)
      
      var leftConstraint = NSLayoutConstraint(item: rowView, attribute: .Left, relatedBy: .Equal, toItem: inputView, attribute: .Left, multiplier: 1.0, constant: -1)

      inputView.addConstraints([leftConstraint, rightSideConstraint])
      
      var topConstraint: NSLayoutConstraint
      
      if index == 0 {
        topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: inputView, attribute: .Top, multiplier: 1.0, constant: 0)
        
      }else{
        
        let prevRow = rowViews[index-1]
        topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: prevRow, attribute: .Bottom, multiplier: 1.0, constant: -1)
        
        let firstRow = rowViews[0]
        var heightConstraint = NSLayoutConstraint(item: firstRow, attribute: .Height, relatedBy: .Equal, toItem: rowView, attribute: .Height, multiplier: 1.0, constant: 0)
        
        inputView.addConstraint(heightConstraint)
      }
      inputView.addConstraint(topConstraint)
      
      var bottomConstraint: NSLayoutConstraint
      
      if index == rowViews.count - 1 {
        bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: inputView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
      }else{
        
        let nextRow = rowViews[index+1]
        bottomConstraint = NSLayoutConstraint(item: rowView, attribute: .Bottom, relatedBy: .Equal, toItem: nextRow, attribute: .Top, multiplier: 1.0, constant: 1)
      }
      
      inputView.addConstraint(bottomConstraint)
    }
    
  }
  
  func didTapButton(sender: AnyObject?) {
    let button = sender as UIButton
    let title = button.titleForState(.Normal) as String!
    self.keyPressed(title)
  }
  
  func keyPressed(key: String)
  {
    var proxy = self.textDocumentProxy as UITextDocumentProxy
    
    switch key {
    case "←" :
      proxy.deleteBackward()
      self.updateKeys()
    case "↵" :
      proxy.insertText("\n")
      self.updateKeys()
    case "⊙" :
      self.advanceToNextInputMode()
      self.updateKeys()
    case "↑":
      self.shiftStateActive = !self.shiftStateActive
      self.loadActiveKeyState()
    case "⌥":
      self.altStateActive = !self.altStateActive
      self.loadActiveKeyState()
    case "⚙":
      self.dvorakActive = !self.dvorakActive
      self.loadActiveKeyState()
    default :
      proxy.insertText(key)
      self.updateKeys()
    }
  }
  
  func updateKeys()
  {
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var rowHeight = self.inputView.frame.size.height / 5
    var colWidth = self.inputView.frame.size.width / 10
    
    var rowIndex = 0
    var colIndex = 0
    
    for row in self.keyLayers {
      for keyLayer in row {
        var cellWidth = colWidth
        
        
        let title = self.activeKeyStates[rowIndex][colIndex]
        switch title {
        case "←", "↵", "⌥", "⚙", "⊙":
          cellWidth *= 1.5
        case " ":
          cellWidth *= 4
        default:
          break
        }
        
        var active = false
        if title == "↑" && self.shiftStateActive {
          active = true
        } else if title == "⌥" && self.altStateActive {
          active = true
        } else {
          for highlightedKey in self.highlightedKeys {
            if highlightedKey.key == title {
              active = true
              break
            }
          }
        }
        
        if ((fabs(keyLayer.frame.size.width - cellWidth) > 0.1) || keyLayer.active != active || keyLayer.key != title) {
          keyLayer.frame = CGRect(x: x, y: y, width: cellWidth, height: rowHeight)
          keyLayer.key = title
          keyLayer.active = active
          keyLayer.setNeedsDisplay()
        }
        
        x += cellWidth
        colIndex++
      }
      y += rowHeight
      x = 0
      colIndex = 0
      rowIndex++
    }
    
    CATransaction.commit()
  }
  
  func keyTitleForPosition(location: CGPoint) -> String
  {
    let rowHeight = Float(self.inputView.frame.size.height) / Float(self.activeKeyStates.count)
    let row = floor(Float(location.y) / rowHeight)
    
    
    let columnWidth = Float(self.inputView.frame.size.width) / Float(self.activeKeyStates[0].count)
    var column = Float(location.x) / columnWidth
    
    if (Int(floor(row)) == 4) {
      if column < 1.5 {
        column = 0
      } else if column < 3 {
        column = 1
      } else if (column < 7) {
        column = 2
      } else if (column < 8.5) {
        column = 3
      } else {
        column = 4
      }
    }
    
    return self.activeKeyStates[Int(floor(row))][Int(floor(column))]
  }
}
