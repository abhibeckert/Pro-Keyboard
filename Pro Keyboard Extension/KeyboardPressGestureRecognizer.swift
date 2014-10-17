//
//  KeyboardPressGestureRecognizer.swift
//  Pro Keyboard
//
//  Created by Abhi Beckert on 14/10/2014.
//
//  This is free and unencumbered software released into the public domain.
//  See unlicense.org
//

import UIKit

class KeyboardPressGestureRecognizer: UIGestureRecognizer
{
  var keyTitles: [[String]]
  let touchBeganCallback: (touch: UITouch) -> ()
  let touchEndedCallback: (touch: UITouch) -> ()
  
  init(touchBegan:(touch: UITouch) -> (), touchEnded:(touch: UITouch) -> ())
  {
    self.keyTitles = [[]]
    
    self.touchBeganCallback = touchBegan
    self.touchEndedCallback = touchEnded
    
    super.init(target: "", action: "count")
  }
//  
//  override init(target: AnyObject, action: Selector)
//  {
//    self.keyTitles = [[]]
//    
//    super.init(target: target, action: action)
//  }
  
  func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
  {
    for touch in touches {
      self.touchBeganCallback(touch:touch as UITouch)
    }
  }
  
  func touchesEnded(touches: NSSet, withEvent event: UIEvent)
  {
    for touch in touches {
      self.touchEndedCallback(touch:touch as UITouch)
    }
  }
  
  func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
  {
    for touch in touches {
      self.touchEndedCallback(touch:touch as UITouch)
    }
  }
}