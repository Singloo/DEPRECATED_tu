//
//  circle.swift
//  tu
//
//  Created by Rorschach on 2016/10/29.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit

class circle: tools {

    override func drawInContext(context: CGContext) {
        context.addEllipse(in: CGRect(origin: CGPoint(x: min(beginPoint.x, endPoint.x), y: min(beginPoint.y, endPoint.y)), size: CGSize(width: abs(endPoint.x - beginPoint.x), height: abs(endPoint.y - beginPoint.y))))
    }
}
