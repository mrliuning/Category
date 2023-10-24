//
//  UIView+Corner.m
//  TojoyCloud
//
//  Created by rr wanggy on 2019/4/16.
//  Copyright © 2019 _Engineer_雷海洋_. All rights reserved.
//

#import "UIView+Corner.h"
#import <objc/runtime.h>
#import "UIColor+NSString.h"

@implementation UIView (Corner)

/// 设置圆角
/// @param corner 圆角类型
/// @param cornerRadius 圆角大小
- (void)setCorner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius {
    CAShapeLayer *mask = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(cornerRadius*2, cornerRadius*2)];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

/// 设置边框
/// @param color 边框颜色
- (void)setBorderColor:(UIColor *)color {
    [self setBorderColor:color lineWidth:1];
}

/// 设置边框
/// @param color 边框颜色
/// @param lineWidth 边框大小
- (void)setBorderColor:(UIColor *)color lineWidth:(CGFloat)lineWidth {
    [self setCorner:UIRectCornerAllCorners cornerRadius:self.frame.size.height/2 borderColor:color fillColor:[UIColor clearColor] lineWidth:lineWidth];
}

- (void)setCorner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)color fillColor:(nonnull UIColor *)fillColor lineWidth:(CGFloat)lineWidth {
    CAShapeLayer *mask;
    for (CALayer *layer in self.layer.sublayers) {
        NSNumber *tag = objc_getAssociatedObject(layer, _cmd);
        if (tag.integerValue == 10000) {
            mask = (CAShapeLayer *)layer;
        }
    }
    if (!mask) {
        mask = [CAShapeLayer layer];
        objc_setAssociatedObject(mask, _cmd, @(10000), OBJC_ASSOCIATION_RETAIN);
        mask.lineWidth = lineWidth;
        //背景填充色
        mask.fillColor = fillColor.CGColor;
        [self.layer insertSublayer:mask atIndex:0];
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(cornerRadius*2, cornerRadius*2)];
    mask.path = path.CGPath;
    mask.path = path.CGPath;
    //圆环的颜色
    mask.strokeColor = color.CGColor;
}

@end
