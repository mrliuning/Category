//
//  UIView+Corner.h
//  TojoyCloud
//
//  Created by rr wanggy on 2019/4/16.
//  Copyright © 2019 _Engineer_雷海洋_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corner)


/// 设置圆角
/// @param corner 圆角类型
/// @param cornerRadius 圆角大小
- (void)setCorner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius;


/// 设置边框
/// @param color 边框颜色
- (void)setBorderColor:(UIColor *)color;


/// 设置边框
/// @param color 边框颜色
/// @param lineWidth 边框大小
- (void)setBorderColor:(UIColor *)color lineWidth:(CGFloat)lineWidth;

- (void)setCorner:(UIRectCorner)corner cornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)color fillColor:(UIColor *)fillColor lineWidth:(CGFloat)lineWidth;
@end

NS_ASSUME_NONNULL_END
