//
//  brush.swift
//  tu
//
//  Created by Rorschach on 2017/6/2.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit

class brush: tools {

    override func drawInContext(context: CGContext) {
        context.setAlpha(0.4)
        context.addLines(between: samplePoints)
        context.setLineJoin(.round)
    }
}
