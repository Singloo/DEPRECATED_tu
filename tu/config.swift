//
//  config.swift
//  tu
//
//  Created by Rorschach on 2016/10/30.
//  Copyright © 2016年 Xiaofeng Yang. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

func RGB(r:Float,g:Float,b:Float)->UIColor{
    return UIColor(colorLiteralRed: r/255, green: g/255, blue: b/255, alpha: 1)
}
//let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
//let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
//
//
//func RGB(r:Float,g:Float,b:Float)->UIColor{
//    return UIColor(colorLiteralRed: r/255, green: g/255, blue: b/255, alpha: 1)
//}
