//
//  UIView+common.h
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/29.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CAShapeLayer.h>
#import <QuartzCore/QuartzCore.h>
@interface UIView (common)


@property (assign, nonatomic) NSInteger typeTag;

/// toast 居中
/// @param text toast的文案
- (void)showMessageWithText:(NSString *)text;


/// toast 偏上
/// @param text text toast的文案
- (void)showMessageAtTopWithText:(NSString *)text;


/// toast 偏下
/// @param text text toast的文案
- (void)showMessageAtBottomCornerWithText:(NSString *)text;

/// toast 居中
/// @param text toast的文案
/// @param icon 显示图片
- (void)showMessageWithText:(NSString *)text icon:(NSString *)icon;
/// 找到自己的vc
- (UIViewController *)viewController;


/// 获取半角视图
-(void)getHalfCornerView;

/// 设置圆角
/// @param radiu 半径大小
-(void)getCornerViewWithRadius:(CGFloat)radiu;


/// 设置圆角
/// @param radiu 半径大小   borderColor 边框颜色  borderWidth 边框宽度
-(void)getCornerViewWithRadius:(CGFloat)radiu borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/// 设置顶部圆角
/// @param radiu 半径大小
-(void)getTopCornerWithRatio:(CGFloat)radiu;

/// 设置底部圆角
/// @param radiu 半径大小
-(void)getBottomCornerWithRatio:(CGFloat)radiu;

/// 设置左边圆角
/// @param radiu 半径大小
-(void)getLeftCornerWithRatio:(CGFloat)radiu;

/// 设置圆角
/// @param radiu 半径大小
-(void)getCornerByRoundingCorners:(UIRectCorner)corners ratio:(CGFloat)radiu;

/// 添加由浅到深的蓝色渐变色，添加之前需要设置self.frame
- (CAGradientLayer *)doAddNormalBlueGradientLayer;


/// 添加由深到浅的蓝色渐变色，添加之前需要设置self.frame
- (CAGradientLayer *)doAddCustomBlueGradientLayer;


/// 添加渐变色，添加之前需要设置self.frame
/// @param startColor 开始颜色
/// @param endColor 结束颜色
- (CAGradientLayer *)doAddBlueGradientLayerStartColor:(CGColorRef)startColor endColor:(CGColorRef)endColor;

/// 添加渐变色，添加之前需要设置self.frame
/// @param startColor 开始颜色
/// @param endColor 结束颜色
/// @param startPoint 开始点
/// @param endPoint 结束点
- (CAGradientLayer *)doAddBlueGradientLayerStartColor:(CGColorRef)startColor endColor:(CGColorRef)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;


/// 顶部添加一个透明渐变的图层，直播间的聊天室
/// @param multiple 多样的
- (void)doAddAlphaGradientLayer:(CGFloat)multiple;
- (void)doAddAlphaGradientLayer:(CGFloat)multiple direction:(NSInteger)direction;

/// 移除渐变色layer
- (void)doRemoveGraditentLayer;

/// 获取渐变色layer
- (CAGradientLayer *)doGetGraditentLayer;

/// 边框阴影
/// @param aCornerRadius 半径
/// @param color 颜色
- (void)setupShadowWithCornerRadius:(CGFloat)aCornerRadius color:(UIColor *)color;


/// 从UISearchBar里面获取输入框控件
/// @param aSearchBar 搜索框
+ (UITextField *)doGetTextFiledFromSearchBar:(UISearchBar *)aSearchBar;

@end


@interface UIView (TJViewBorder)


/// layer传nil则默认为self.layer
/// @param width 宽
/// @param color 颜色
/// @param cornerRadius 半径
/// @param layer layer
- (void)setupBorderWidth:(CGFloat)width color:(CGColorRef)color cornerRadius:(CGFloat)cornerRadius needMaskLayer:(CALayer *)layer;

@end


@interface CALayer (TJTagLayer)
//tag
@property (nonatomic,assign)NSInteger mTag;
@end


