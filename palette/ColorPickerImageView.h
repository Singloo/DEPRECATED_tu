//
//  ColorPickerImageView.h
//  paletteTest
//
//  Created by cchhjj on 16/7/13.
//  Copyright © 2016年 CanHe Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPickerImageView : UIImageView

@property (assign, nonatomic) CGPoint currentPoint; 
@property (strong, nonatomic) UIColor *currentColor;


@property (assign, nonatomic) CGFloat R;
@property (assign, nonatomic) CGFloat G;
@property (assign, nonatomic) CGFloat B;
@property (assign, nonatomic) CGFloat L;

- (void)setColorAtPoint:(CGPoint)pointL;

@end
