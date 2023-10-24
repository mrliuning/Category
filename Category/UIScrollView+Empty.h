//
//  UIScrollView+Empty.h
//  TojoyCloud
//
//  Created by 陈玉 on 2018/3/27.
//  Copyright © 2018年 _Engineer_雷海洋_. All rights reserved.
//

#import <UIKit/UIKit.h>

extern  NSInteger  emptyTag;
extern  NSInteger  emptyImgTag;
extern  NSInteger  tipsLabelTag;

@interface UIScrollView (Empty)

/// 设置是否显示空状态占位图
/// @param empty 是否显示
/// @param tip 显示的文案
- (void)setEmptyView:(BOOL)empty andTip:(NSString *)tip;


/// 重新设置占位图片的Y值
/// @param top 占位图的Y值
- (void)setEmptyViewTop:(CGFloat)top;


/// 重新设置图片和提示文字的y值
/// @param top 图片的y值
/// @param padding 提示文字label距离图片的间距
- (void)setEmptyImgViewTop:(CGFloat)top tipsLabelPadding:(CGFloat)padding;


/// 设置空状态占位视图的size和显示文案
/// @param width 宽
/// @param height 高
/// @param tip 显示文案
- (void)emptyViewWithWidth:(CGFloat)width andHeight:(CGFloat)height andTip:(NSString *)tip;


/// 设置空状态占位图
/// @param empty 是否展示self
/// @param tip 显示文案
/// @param imgName 显示的图片
- (void)setEmptyView:(BOOL)empty andTip:(NSString *)tip img:(NSString *)imgName;


/// 重新设置图片和提示文字的y值
/// @param empty 是否展示self
/// @param tip 提示文字
/// @param color 提示文字label色值
/// @param imgName 图片
- (void)setEmptyView:(BOOL)empty andTip:(NSString *)tip textColor:(UIColor *)color img:(NSString *)imgName;


@end


// ScrollView响应/传递侧滑pop手势
@interface UIScrollView (PanGesture)

@property(assign, nonatomic) BOOL shouldRecognizeSimultaneously;
@property(assign, nonatomic) CGSize minContentSize;

@end
