//
//  PaletteView.h
//
//  Created by cchhjj on 16/7/13.
//  Copyright © 2016年 CanHe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerImageView.h"

@interface PaletteView : UIView
/**
 选中颜色的圆块，默认是白色背景色 size 20 20
 */
@property (strong, nonatomic) UIImageView *slider;


@property (assign, nonatomic) CGPoint colorPickerPoint;

@property (strong, nonatomic) ColorPickerImageView *colorPicker;

/**
 颜色回调
 */
@property (copy, nonatomic) void(^currentColorBlock)(CGFloat R,CGFloat G,CGFloat B,CGFloat L);


/**
 要被拾取颜色的图片
 */
@property (strong, nonatomic) UIImage *colorPickerImage;


- (instancetype)initWithFrame:(CGRect)frame colorPickerImage:(UIImage *)colorPickerImage;

@end
