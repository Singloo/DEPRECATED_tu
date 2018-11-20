//
//  PaletteView.m
//
//  Created by cchhjj on 16/7/13.
//  Copyright © 2016年 CanHe Chen. All rights reserved.
//

#import "PaletteView.h"
#import "UIImage+base.h"

@implementation PaletteView

- (void)dealloc
{
    [_colorPicker removeObserver:self forKeyPath:@"currentPoint"];
    NSLog(@"%@",[self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame colorPickerImage:(UIImage *)colorPickerImage
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
        self.colorPickerImage = colorPickerImage;
        
        
        
    }
    return self;
}

- (void)setup {
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = w/2;
    self.layer.masksToBounds = YES;
    [self.colorPicker addObserver:self forKeyPath:@"currentPoint" options:NSKeyValueObservingOptionNew context:nil];
    self.slider.center = CGPointMake(w/2, h/2);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"currentPoint"]) {

        NSValue *value = change[NSKeyValueChangeNewKey];
        CGPoint point = [value CGPointValue];
        
        CGPoint point1 = [self convertPoint:point fromView:self.colorPicker];
        self.colorPickerPoint = point;
        self.slider.center = point1;
        self.backgroundColor = self.colorPicker.currentColor;
        

        if (self.currentColorBlock) {
            self.currentColorBlock(self.colorPicker.R,self.colorPicker.G,self.colorPicker.B,self.colorPicker.L);
        }

    }


}

- (void)setColorPickerImage:(UIImage *)colorPickerImage {
    
    self.colorPicker.image = colorPickerImage;
    
    _colorPickerImage = colorPickerImage;
}


- (UIImageView *)slider {
    if (!_slider) {
        UIImageView *temp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        temp.backgroundColor = [UIColor whiteColor];
        temp.layer.cornerRadius = 10;
        temp.layer.masksToBounds = YES;
        [self addSubview:temp];
        _slider  = temp;
    }
    
    return _slider;
}

- (ColorPickerImageView *)colorPicker {
    if (!_colorPicker) {
        ColorPickerImageView *temp = [[ColorPickerImageView alloc]initWithFrame:CGRectMake(0, 0, 190, 190)];
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        temp.center = CGPointMake(w/2, h/2);
        [self addSubview:temp];
        _colorPicker = temp;
    }
    return _colorPicker;
}




@end
