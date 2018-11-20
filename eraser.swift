//
//  eraser.swift
//  tu
//
//  Created by Rorschach on 2016/10/29.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import UIKit

class eraser: pencil {
    override func drawInContext(context: CGContext) {
        context.setBlendMode(.clear)
        context.setAlpha(0.5)
        super.drawInContext(context: context)
        
    }

}
