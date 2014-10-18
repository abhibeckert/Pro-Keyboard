//
//  KeyLayer.swift
//  Pro Keyboard
//
//  Created by Abhi Beckert on 17/10/2014.
//  Copyright (c) 2014 Abhi Beckert. All rights reserved.
//

import UIKit

class KeyLayer: CALayer
{
  var key = ""
  var active = false
  
  override init()
  {
    super.init()
  }
  
  override init(layer: AnyObject!)
  {
    super.init(layer: layer)
    
    self.key = layer.key
    self.active = layer.active
  }
  
  required init(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawInContext(context: CGContext!)
  {
    CGContextSaveGState(context)
    
    // background gradient
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let componentCount : UInt = 2
    
    var colourComponents : [CGFloat] = [
      1, 1, 1, 1,
      0.9,   0.9,   0.9,   1,
    ]
    if (self.active) {
      colourComponents = [
//        0.248, 0.365, 0.483, 1,
//        0.348, 0.465, 0.583, 1,
        0.39, 0.82, 1.00, 1.0,
        0.19, 0.62, 0.87, 1.0,
      ]
    }
    
    let locations : [CGFloat] = [0, 1.0]
    
    let gradient = CGGradientCreateWithColorComponents(colorSpace, colourComponents, locations, componentCount)
    
    let startPoint = CGPoint(x: 0, y: 0)
    let endPoint = CGPoint(x: 0, y: self.bounds.size.height)
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
    
    // lines between keys
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, CGColorCreate(colorSpace, [0, 0, 0, 0.3]));
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.size.width, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextSetStrokeColorWithColor(context, CGColorCreate(colorSpace, [1, 1, 1, 1.0]));
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, self.bounds.size.height);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0.2);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0.2);
    CGContextStrokePath(context);
    
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    
    
    // load
    let font = CTFontCreateWithName("Avenir-Roman", 21, nil)
    let attributes = [kCTForegroundColorAttributeName:UIColor.blackColor().CGColor, kCTFontAttributeName: font]
    let attributedString = NSAttributedString(string: self.key, attributes: attributes)
    
    let typesetter = CTTypesetterCreateWithAttributedString(attributedString)
    let line = CTTypesetterCreateLine(typesetter, CFRangeMake(0, CFAttributedStringGetLength(attributedString)))
    
    
    
    let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
    let frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: attributedString.length), nil, CGSize(width: CGFloat.max, height: CGFloat.max), nil)
    
    
    
    CGContextSetTextPosition(context, (self.bounds.size.width / 2) - (frameSize.width / 2), (self.bounds.size.height / 2) - (frameSize.height / 2) + 5.5)
    CTLineDraw(line, context)
    
    CGContextRestoreGState(context)
  }
}