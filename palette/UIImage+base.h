//
//  UIImage+base.h
//
//  Created by cchhjj on 16/6/3.
//  Copyright © 2016年 CanHe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (base)
+ (UIImage *)imageFromColor:(UIColor *)color;

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageForResizeWithImageName:(NSString *)imageName resize:(CGSize)resize;

- (UIColor *)colorAtPixel:(CGPoint)point;

@end
