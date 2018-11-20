//
//  ColorPickerImageView.m
//  paletteTest
//
//  Created by cchhjj on 16/7/13.
//  Copyright © 2016年 CanHe Chen. All rights reserved.
//

#import "ColorPickerImageView.h"

#define pickerIndent 5 

@implementation ColorPickerImageView {

    UIBezierPath *bezierPath;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width)];
    if (self) {
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = frame.size.width/2;

        self.layer.masksToBounds = YES;

    }
    return self;
}



- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint pointL = [touch locationInView:self];
    
    [self setColorAtPoint:pointL];
    
}

- (void)setColorAtPoint:(CGPoint)pointL {
    
    if (!bezierPath) {
        CGRect rect;
        CGFloat width = self.bounds.size.width - 6;
        CGFloat height = self.bounds.size.height - 6;
        rect = CGRectMake(3, 3, width , height);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
        bezierPath = path;
    }

    if (CGPathContainsPoint(bezierPath.CGPath, NULL, pointL, NO)) {
        CGPoint point = pointL;
        UIColor *color = [self colorAtPixel:point];
        self.currentColor = color;
        self.currentPoint = point;
    }


}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    UITouch *touch = [touches anyObject];
    [self setColorAtPoint:[touch locationInView:self]];
}


- (void)setImage:(UIImage *)image {
    UIImage *temp = [self imageForResizeWithImage:image resize:CGSizeMake(self.frame.size.width, self.frame.size.width)];
    [super setImage:temp];
}

- (UIImage *)imageForResizeWithImage:(UIImage *)picture resize:(CGSize)resize {
    CGSize imageSize = resize; //CGSizeMake(25, 25)
    UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [picture drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    return image;
}

//获取图片某一点的颜色
- (UIColor *)colorAtPixel:(CGPoint)point {
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.image.size.width, self.image.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.image.CGImage;
    NSUInteger width = self.image.size.width;
    NSUInteger height = self.image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    self.R = red;
    self.G = green;
    self.B = blue;
    self.L = alpha;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
