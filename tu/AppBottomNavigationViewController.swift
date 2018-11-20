//
//  AppBottomNavigationViewController.swift
//  tu
//
//  Created by Rorschach on 2017/3/10.
//  Copyright © 2017年 Xiaofeng Yang. All rights reserved.
//

import UIKit
import  Material

class AppBottomNavigationViewController: BottomNavigationController {


    open override func prepare() {
        super.prepare()
    
        tabBar.setColors(background: Color.grey.lighten4, selectedBackground: Color.grey.lighten4, item: Color.grey.base, selectedItem: Color.lightGreen.base)
   
  
    }

}
