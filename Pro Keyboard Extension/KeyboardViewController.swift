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
  
  var quertyKeys = [
    [
      (normal:"1", shift:"!", alt:"!"),
      (normal:"2", shift:"@", alt:"@"),
      (normal:"3", shift:"#", alt:"#"),
      (normal:"4", shift:"$", alt:"$"),
      (normal:"5", shift:"%", alt:"%"),
      (normal:"6", shift:"^", alt:"^"),
      (normal:"7", shift:"&", alt:"&"),
      (normal:"8", shift:"*", alt:"*"),
      (normal:"9", shift:"(", alt:"("),
      (normal:"0", shift:")", alt:")")
    ], [
      (normal:"q", shift:"Q",alt:"`"),
      (normal:"w", shift:"W", alt:"~"),
      (normal:"e", shift:"E", alt:"€"),
      (normal:"r", shift:"R", alt:"£"),
      (normal:"t", shift:"T", alt:"¢"),
      (normal:"y", shift:"Y", alt:"•"),
      (normal:"u", shift:"U", alt:"["),
      (normal:"i", shift:"I", alt:"]"),
      (normal:"o", shift:"O", alt:"{"),
      (normal:"p", shift:"P", alt:"}")
    ], [
      (normal:"a", shift:"A", alt:"ˆ"),
      (normal:"s", shift:"S", alt:"_"),
      (normal:"d", shift:"D", alt:"“"),
      (normal:"f", shift:"F", alt:"”"),
      (normal:"g", shift:"G", alt:"‘"),
      (normal:"h", shift:"H", alt:"’"),
      (normal:"j", shift:"J", alt:"«"),
      (normal:"k", shift:"K", alt:"»"),
      (normal:"l", shift:"L", alt:"–"),
      (normal:"'", shift:"\"", alt:"—")
    ], [
      (normal:"↑", shift:"↑", alt:"↑"),
      (normal:"z", shift:"Z", alt:":"),
      (normal:"x", shift:"X", alt:";"),
      (normal:"c", shift:"C", alt:"?"),
      (normal:"v", shift:"V", alt:"="),
      (normal:"b", shift:"B", alt:"+"),
      (normal:"n", shift:"N", alt:"/"),
      (normal:"m", shift:"M", alt:"\\"),
      (normal:",", shift:"<", alt:"<"),
      (normal:".", shift:">", alt:">")
    ], [
      (normal:"⊙", shift:"⊙", alt:"⚙"),
      (normal:"⌥", shift:"⌥", alt:"⌥"),
      (normal:" ", shift:" ", alt:" "),
      (normal:"←", shift:"←", alt:"←"),
      (normal:"↵", shift:"↵", alt:"↵")
    ]
  ]
  
  // dvorak
  var dvorakKeys = [
    [
      (normal:"1", shift:"!", alt:"!"),
      (normal:"2", shift:"@", alt:"@"),
      (normal:"3", shift:"#", alt:"#"),
      (normal:"4", shift:"$", alt:"$"),
      (normal:"5", shift:"%", alt:"%"),
      (normal:"6", shift:"^", alt:"^"),
      (normal:"7", shift:"&", alt:"&"),
      (normal:"8", shift:"*", alt:"*"),
      (normal:"9", shift:"(", alt:"("),
      (normal:"0", shift:")", alt:")")
    ], [
      (normal:"'", shift:"\"",alt:"`"),
      (normal:",", shift:"<", alt:"~"),
      (normal:".", shift:">", alt:"€"),
      (normal:"p", shift:"P", alt:"£"),
      (normal:"y", shift:"Y", alt:"¢"),
      (normal:"f", shift:"F", alt:"•"),
      (normal:"g", shift:"G", alt:"["),
      (normal:"c", shift:"C", alt:"]"),
      (normal:"r", shift:"R", alt:"{"),
      (normal:"l", shift:"L", alt:"}")
    ], [
      (normal:"a", shift:"A", alt:"ˆ"),
      (normal:"o", shift:"O", alt:"_"),
      (normal:"e", shift:"E", alt:"“"),
      (normal:"u", shift:"U", alt:"”"),
      (normal:"i", shift:"I", alt:"‘"),
      (normal:"d", shift:"D", alt:"’"),
      (normal:"h", shift:"H", alt:"«"),
      (normal:"t", shift:"T", alt:"»"),
      (normal:"n", shift:"N", alt:"–"),
      (normal:"s", shift:"S", alt:"—")
    ], [
      (normal:"↑", shift:"↑", alt:"↑"),
      (normal:"q", shift:"Q", alt:":"),
      (normal:"j", shift:"J", alt:";"),
      (normal:"k", shift:"K", alt:"?"),
      (normal:"x", shift:"X", alt:"="),
      (normal:"b", shift:"B", alt:"+"),
      (normal:"m", shift:"M", alt:"/"),
      (normal:"w", shift:"W", alt:"\\"),
      (normal:"v", shift:"V", alt:"<"),
      (normal:"z", shift:"Z", alt:">")
    ], [
      (normal:"⊙", shift:"⊙", alt:"⚙"),
      (normal:"⌥", shift:"⌥", alt:"⌥"),
      (normal:" ", shift:" ", alt:" "),
      (normal:"←", shift:"←", alt:"←"),
      (normal:"↵", shift:"↵", alt:"↵")
    ]
  ]
  
  var activeKeyTitles: [[String]] = []
  
  var keyLayers: [[KeyLayer]] = []
  
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
    
    let layout = NSUserDefaults.standardUserDefaults().stringForKey("layout")
    if layout? == "dvorak" {
      self.dvorakActive = true
    }
    
    let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    keyboardView.addGestureRecognizer(self.keypressGestureRecognizer)
    self.inputView.addSubview(keyboardView)
    
    keyboardView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    self.inputView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": keyboardView]))
    self.inputView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": keyboardView]))
    
    let scale = UIScreen.mainScreen().scale
    
    var isFirstRow = true
    for keyRow in self.quertyKeys {
      var layers: [KeyLayer] = []
      for key in keyRow {
        let layer = KeyLayer()
        layer.isFirstRow = isFirstRow
        
        layer.contentsScale = scale
        
        layers.append(layer)
        keyboardView.layer.addSublayer(layer)
      }
      self.keyLayers.append(layers)
      isFirstRow = false;
    }
    
    self.heightConstraint = NSLayoutConstraint(item: self.inputView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: CGFloat(self.portraitHeight))
    
    self.loadActiveKeyState()
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
  }
  
  func loadActiveKeyState()
  {
    var keyStates:[[String]] = []
    
    if self.dvorakActive {
      if self.altStateActive {
        for keyRow in self.dvorakKeys {
          var keyStateRow: [String] = []
          for key in keyRow {
            keyStateRow.append(key.alt)
          }
          keyStates.append(keyStateRow)
        }
      } else if self.shiftStateActive {
        for keyRow in self.dvorakKeys {
          var keyStateRow: [String] = []
          for key in keyRow {
            keyStateRow.append(key.shift)
          }
          keyStates.append(keyStateRow)
        }
      } else {
        for keyRow in self.dvorakKeys {
          var keyStateRow: [String] = []
          for key in keyRow {
            keyStateRow.append(key.normal)
          }
          keyStates.append(keyStateRow)
        }
      }
    } else {
      if self.altStateActive {
        for keyRow in self.quertyKeys {
          var keyStateRow: [String] = []
          for key in keyRow {
            keyStateRow.append(key.alt)
          }
          keyStates.append(keyStateRow)
        }
      } else if self.shiftStateActive {
        for keyRow in self.quertyKeys {
          var keyStateRow: [String] = []
          for key in keyRow {
            keyStateRow.append(key.shift)
          }
          keyStates.append(keyStateRow)
        }
      } else {
        for keyRow in self.quertyKeys {
          var keyStateRow: [String] = []
          for key in keyRow {
            keyStateRow.append(key.normal)
          }
          keyStates.append(keyStateRow)
        }
      }
    }
    
    self.activeKeyTitles = keyStates
    
    self.updateKeys()
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
      self.altStateActive = false
      self.loadActiveKeyState()
      
      NSUserDefaults.standardUserDefaults().setObject(self.dvorakActive ? "dvorak" : "querty", forKey: "layout")
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
    var rowHeight = ceil(self.inputView.frame.size.height / 5)
    var colWidth = ceil(self.inputView.frame.size.width / 10)
    
    var rowIndex = 0
    var colIndex = 0
    
    for row in self.keyLayers {
      for keyLayer in row {
        var cellWidth = colWidth
        
        
        let title = self.activeKeyTitles[rowIndex][colIndex]
        switch title {
        case "←", "↵", "⌥", "⚙", "⊙":
          cellWidth *= 1.5
          cellWidth = ceil(cellWidth)
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
          var h = rowHeight
          if (y + h > self.inputView.frame.size.height) {
            h = self.inputView.frame.size.height - y
          }
          
          var w = cellWidth
          if (x + w > self.inputView.frame.size.width) {
            w = self.inputView.frame.size.width - x
          }
          
          keyLayer.frame = CGRect(x: x, y: y, width: w, height: h)
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
    let rowHeight = Float(self.inputView.frame.size.height) / Float(self.activeKeyTitles.count)
    let row = floor(Float(location.y) / rowHeight)
    
    
    let columnWidth = Float(self.inputView.frame.size.width) / Float(self.activeKeyTitles[0].count)
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
    
    return self.activeKeyTitles[Int(floor(row))][Int(floor(column))]
  }
}
