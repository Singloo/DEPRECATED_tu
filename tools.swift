//
//  tools.swift
//  tu
//
//  Created by Rorschach on 16/10/24.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import CoreGraphics

protocol PaintBrush {
    func supportedContinuesDrawing() -> Bool
    func drawInContext(context:CGContext)
}

class tools: NSObject,PaintBrush{
    var beginPoint:CGPoint!
    var endPoint:CGPoint!
    var lastPoint:CGPoint?
    var currentPoint:CGPoint?
    var samplePoints = [CGPoint]()
    
    var strokeWidth:CGFloat!
    
    func supportedContinuesDrawing() -> Bool {
        return false
    }
    func drawInContext(context: CGContext) {
        assert(false, "")
    }
}
