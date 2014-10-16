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
  let callback: (key: String) -> ()
  
  init(callback:(key: String) -> ())
  {
    self.keyTitles = [[]]
    
    self.callback = callback
    
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
      let title = self.keyTitleForPosition(touch.locationInView(nil))
      
      self.callback(key:title)
    }
  }
  
  
  func keyTitleForPosition(location: CGPoint) -> String
  {
    let rowHeight = Float(self.view!.frame.size.height) / Float(keyTitles.count)
    let row = floor(Float(location.y) / rowHeight)
    
    
    let columnWidth = Float(self.view!.frame.size.width) / Float(keyTitles[0].count)
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
    
    return keyTitles[Int(floor(row))][Int(floor(column))]
  }
}