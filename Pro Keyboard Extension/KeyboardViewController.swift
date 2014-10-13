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
  
  var dvorakActive = true
  var shiftStateActive = false
  var altStateActive = false
  
  // missing keys: `~?|_:;
  
//  @IBOutlet var nextKeyboardButton: UIButton!
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    // Add custom view sizing constraints here
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.loadActiveKeyState()
    
    
    
    
//    self.nextKeyboardButton = UIButton.buttonWithType(.System) as UIButton
//    
//    self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
//    self.nextKeyboardButton.sizeToFit()
//    self.nextKeyboardButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//    
//    self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
//    
//    self.view.addSubview(self.nextKeyboardButton)
//    
//    var nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
//    var nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
//    self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])
  }
  
  override func viewDidAppear(animated: Bool) {
    let keyboardHeight: CGFloat = 253
    
    let heightConstraint = NSLayoutConstraint(item: self.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: keyboardHeight)
    
    self.view.addConstraint(heightConstraint)
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
  
  func loadActiveKeyState()
  {
    var keyStates = self.dvorakActive ? self.dvorakKeyStates : self.quertyKeyStates
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
    
    for view in self.view.subviews {
      view.removeFromSuperview()
    }
    
    var rows: [UIView] = []
    for keys in keyStates {
      var rowView = createRowOfButtons(keys)
      
      self.view.addSubview(rowView)
      
      rowView.setTranslatesAutoresizingMaskIntoConstraints(false)
      
      rows.append(rowView)
    }
    addConstraintsToInputView(self.view, rowViews: rows)
  }
  
  func createRowOfButtons(buttonTitles: [NSString]) -> UIView {
    
    var buttons = [UIButton]()
    var keyboardRowView = UIView(frame: CGRectMake(0, 0, 320, 50))
    
    for buttonTitle in buttonTitles{
      
      let button = createButtonWithTitle(buttonTitle)
      buttons.append(button)
      keyboardRowView.addSubview(button)
    }
    
    addIndividualButtonConstraints(buttons, mainView: keyboardRowView)
    
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
  
  func addIndividualButtonConstraints(buttons: [UIButton], mainView: UIView){
    
    for (index, button) in enumerate(buttons) {
      
      var topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1.0, constant: 1)
      
      var bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1.0, constant: -1)
      
      var rightConstraint : NSLayoutConstraint!
      
      if index == buttons.count - 1 {
        
        rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: mainView, attribute: .Right, multiplier: 1.0, constant: -1)
        
      }else{
        
        let nextButton = buttons[index+1]
        rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: nextButton, attribute: .Left, multiplier: 1.0, constant: -1)
      }
      
      
      var leftConstraint : NSLayoutConstraint!
      
      if index == 0 {
        
        leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: mainView, attribute: .Left, multiplier: 1.0, constant: 1)
        
      }else{
        
        let prevtButton = buttons[index-1]
        leftConstraint = NSLayoutConstraint(item: button, attribute: .Left, relatedBy: .Equal, toItem: prevtButton, attribute: .Right, multiplier: 1.0, constant: 1)
        
        let firstButton = buttons[0]
        var widthConstraint = NSLayoutConstraint(item: firstButton, attribute: .Width, relatedBy: .Equal, toItem: button, attribute: .Width, multiplier: 1.0, constant: 0)
        if (button.titleLabel?.text == " ") {
          widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 140)
        }
        
        mainView.addConstraint(widthConstraint)
      }
      
      mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
    }
  }
  
  func addConstraintsToInputView(inputView: UIView, rowViews: [UIView]){
    
    for (index, rowView) in enumerate(rowViews) {
      var rightSideConstraint = NSLayoutConstraint(item: rowView, attribute: .Right, relatedBy: .Equal, toItem: inputView, attribute: .Right, multiplier: 1.0, constant: -1)
      
      var leftConstraint = NSLayoutConstraint(item: rowView, attribute: .Left, relatedBy: .Equal, toItem: inputView, attribute: .Left, multiplier: 1.0, constant: 1)
      
      inputView.addConstraints([leftConstraint, rightSideConstraint])
      
      var topConstraint: NSLayoutConstraint
      
      if index == 0 {
        topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: inputView, attribute: .Top, multiplier: 1.0, constant: 0)
        
      }else{
        
        let prevRow = rowViews[index-1]
        topConstraint = NSLayoutConstraint(item: rowView, attribute: .Top, relatedBy: .Equal, toItem: prevRow, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
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
    var proxy = textDocumentProxy as UITextDocumentProxy
    
    switch title {
    case "←" :
      proxy.deleteBackward()
    case "↵" :
      proxy.insertText("\n")
    case "⊙" :
      self.advanceToNextInputMode()
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
      proxy.insertText(title)
    }
  }
}
