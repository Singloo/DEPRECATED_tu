//
//  dot.swift
//  tu
//
//  Created by Rorschach on 2017/6/2.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit

class dot: tools{

    override func drawInContext(context: CGContext) {
   
        for point in 1 ... samplePoints.count{
            if samplePoints.count <= 3{
                context.move(to: samplePoints[point - 1])
                context.addLine(to: samplePoints[point - 1])
            }else{
                if point.isOdd{
                    context.move(to: samplePoints[point - 1])
                    context.addLine(to: samplePoints[point - 1])
                }
            }
        }
    }
}
