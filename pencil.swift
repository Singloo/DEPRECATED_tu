//
//  pencil.swift
//  tu
//
//  Created by Rorschach on 2016/10/29.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit

class pencil: tools {
    override func drawInContext(context: CGContext) {
        
        
        if self.samplePoints.isEmpty {
            
        }
        else if self.samplePoints.count == 1{
            context.move(to: beginPoint)
            context.addLine(to: beginPoint)
        }
        else if self.samplePoints.count == 2{
            var mid:CGPoint
            
            mid = CGPoint(x: (beginPoint.x + endPoint.x)/2, y: (beginPoint.y + endPoint.y)/2)
            context.move(to: beginPoint)
            context.addQuadCurve(to: endPoint, control: mid)
            
        }
        else if self.samplePoints.count >= 3{
            
            let currentPT = self.samplePoints[self.samplePoints.count - 1]
            let lastPt = self.samplePoints[self.samplePoints.count - 2]
            
            let mid = CGPoint(x: (lastPt.x + currentPT.x)/2, y: (lastPt.y + currentPT.y)/2)
            
            let mid1 = CGPoint(x: (lastPt.x + mid.x)/2, y: (lastPt.y + mid.y)/2)
            let mid2 = CGPoint(x: (mid.x + currentPT.x)/2, y: (mid.y + currentPT.y)/2)
            context.setLineJoin(.round)
            
            context.move(to: lastPt)
            context.addQuadCurve(to: mid, control: mid1)
            context.move(to: mid)
            context.addQuadCurve(to: currentPT, control: mid2)

        }
 
    }
 
    
    override func supportedContinuesDrawing() -> Bool {
        return true
    }

}
