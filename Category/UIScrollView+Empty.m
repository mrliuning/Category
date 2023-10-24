//
//  UIScrollView+Empty.m
//  TojoyCloud
//
//  Created by 陈玉 on 2018/3/27.
//  Copyright © 2018年 _Engineer_雷海洋_. All rights reserved.
//


#import "UIScrollView+Empty.h"
#import "UIViewController+URLRouter.h"
#import <Macro/CommonGlobalMacro.h>
#import <Macro/CommonBaseMacros.h>
#import <objc/runtime.h>

NSInteger emptyTag = 10812;
NSInteger emptyImgTag = 10813;
NSInteger tipsLabelTag = 10814;

@implementation UIScrollView (Empty)


/// 设置是否显示空状态占位图
/// @param empty 是否显示
/// @param tip 显示的文案
- (void)setEmptyView:(BOOL)empty andTip:(NSString *)tip
{
    UIView * aEmptyView = [self viewWithTag:emptyTag];
    if (aEmptyView && [self.subviews containsObject:aEmptyView]) {
        [aEmptyView removeFromSuperview];
    }
    if (empty) {
        [self emptyViewWithWidth:self.frame.size.width andHeight:self.frame.size.height andTip:tip];
    }
}


/// 重新设置占位图片的Y值
/// @param top 占位图的Y值
- (void)setEmptyViewTop:(CGFloat)top
{
    UIView * aEmptyImgView = [self viewWithTag:emptyImgTag];
    CGRect frame = aEmptyImgView.frame;
    aEmptyImgView.frame = CGRectMake(frame.origin.x, top, frame.size.width, frame.size.height);
    
    UIView * aEmptyTipView = [self viewWithTag:tipsLabelTag];
    CGRect aTipFrame = aEmptyTipView.frame;
    aEmptyTipView.frame = CGRectMake(aTipFrame.origin.x, top+frame.size.height+Ratio(24), aTipFrame.size.width, aTipFrame.size.height);
    
}


/// 重新设置图片和提示文字的y值
/// @param top 图片的y值
/// @param padding 提示文字label距离图片的间距
- (void)setEmptyImgViewTop:(CGFloat)top tipsLabelPadding:(CGFloat)padding
{
    UIImageView * aEmptyView = [self viewWithTag:emptyImgTag];
    CGRect frame = aEmptyView.frame;
    aEmptyView.frame = CGRectMake(frame.origin.x, top, frame.size.width, frame.size.height);
    
    UILabel * aLabel = [self viewWithTag:tipsLabelTag];
    frame = aLabel.frame;
    CGFloat aTop = aEmptyView.frame.origin.y + aEmptyView.frame.size.height + padding;
    aLabel.frame = CGRectMake(frame.origin.x, aTop, frame.size.width, frame.size.height);
}


/// 设置空状态占位视图的size和显示文案
/// @param width 宽
/// @param height 高
/// @param tip 显示文案
- (void)emptyViewWithWidth:(CGFloat)width andHeight:(CGFloat)height andTip:(NSString *)tip{
    
    UIView * aEmptyView = [self getEmptyViewWithFrame:CGRectMake(0, 0, width, height) Tips:tip textColor:UIColorFromRGBA(0xe4e5e9, 1) img:@"TJ_Empty_Logo"];

    [self insertSubview:aEmptyView atIndex:0];
}


/// 设置空状态占位图
/// @param tip 显示文案
/// @param imgName 显示的图片
- (void)setEmptyView:(BOOL)empty andTip:(NSString *)tip img:(NSString *)imgName
{
    [self setEmptyView:empty andTip:tip textColor:[UIColor colorWithWhite:0 alpha:0.6] img:imgName];
}


/// 重新设置图片和提示文字的y值
/// @param empty 是否展示self
/// @param tip 提示文字
/// @param color 提示文字label色值
/// @param imgName 图片
- (void)setEmptyView:(BOOL)empty andTip:(NSString *)tip textColor:(UIColor *)color img:(NSString *)imgName
{
    UIView * aEmptyView = [self viewWithTag:emptyTag];
    if (aEmptyView && [self.subviews containsObject:aEmptyView]) {
        [aEmptyView removeFromSuperview];
    }
    if (empty) {
        UIView * aEmptyView = [self getEmptyViewWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) Tips:tip textColor:color img:imgName];
        
        [self insertSubview:aEmptyView atIndex:0];
    }
}


/// 设置空状态占位图
/// @param frame 视图frame
/// @param tip 显示文案
/// @param color 文字颜色
/// @param imgName 显示的图片
- (UIView *)getEmptyViewWithFrame:(CGRect)frame Tips:(NSString *)tip textColor:(UIColor *)color img:(NSString *)imgName
{
    UIView *aEmptyView = [[UIView alloc] initWithFrame:frame];
    aEmptyView.userInteractionEnabled = NO;
    aEmptyView.backgroundColor = [UIColor clearColor];
    aEmptyView.tag = emptyTag;
    
    UIImageView *aEmptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    aEmptyImageView.tag = emptyImgTag;
   
    CGSize aScreenSize = [UIScreen mainScreen].bounds.size;
    CGRect aFrame = aEmptyImageView.frame;
    aEmptyImageView.frame = CGRectMake((aScreenSize.width - Ratio(72))/2, MAX(0, self.frame.size.height/2 - aFrame.size.height/2-Ratio(10) ), aFrame.size.width, aFrame.size.height);
    
    aEmptyImageView.center = CGPointMake(aScreenSize.width / 2, aEmptyImageView.center.y);
    
    [aEmptyView addSubview:aEmptyImageView];
    
    UILabel *aEmptyTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, aEmptyImageView.frame.origin.y+aEmptyImageView.frame.size.height+Ratio(24), aScreenSize.width, 15)];
    
    aEmptyTipLabel.tag = tipsLabelTag;
    aEmptyTipLabel.text = beNil(tip)?@"":tip;
    aEmptyTipLabel.textColor = color;
    aEmptyTipLabel.textAlignment = NSTextAlignmentCenter;
    aEmptyTipLabel.font = [UIFont systemFontOfSize:Ratio(15)];
    
    [aEmptyView addSubview:aEmptyTipLabel];
    
    return aEmptyView;
}

@end



@implementation UIScrollView (PanGesture)
+(void)load
{
    swizzling_exchangeMethod([self class] ,@selector(setContentSize:), @selector(swizzling_setContentSize:));
}
static inline void swizzling_exchangeMethod(Class clazz ,SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    
    BOOL success = class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
// 返回YES时，手势事件会一直往下传递
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([self panBack:gestureRecognizer] || self.shouldRecognizeSimultaneously) {
        return YES;
    }
    return NO;
}
-(void)swizzling_setContentSize:(CGSize)contentSize
{
//    if (!CGSizeEqualToSize(self.minContentSize, CGSizeZero))
//    {
        [self swizzling_setContentSize:CGSizeMake(MAX(contentSize.width, self.minContentSize.width), MAX(contentSize.height, self.minContentSize.height))];
        
//    }
//    else
//    [self swizzling_setContentSize:contentSize];
}
-(void)setMinContentSize:(CGSize)minContentSize
{
    objc_setAssociatedObject(self, @"minContentSize", [NSValue valueWithCGSize:minContentSize], OBJC_ASSOCIATION_RETAIN);
}
-(CGSize)minContentSize
{
    NSValue * value = objc_getAssociatedObject(self, @"minContentSize");
    return [value CGSizeValue];
}
// location_X可自己定义,其代表的是滑动返回距左边的有效长度
- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
    
    // 是滑动返回距左边的有效长度
    UINavigationController *nav = [UIViewController currentNavigationController];
    if (![nav isKindOfClass:[UINavigationController class]]) {
        return NO;
    }
    
    int location_X = nav.childViewControllers.count > 1? Ratio(44) : 1;
    
    if (gestureRecognizer ==self.panGestureRecognizer) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [pan translationInView:self];
        UIGestureRecognizerState state = gestureRecognizer.state;
        if (UIGestureRecognizerStateBegan == state ||UIGestureRecognizerStatePossible == state) {
            CGPoint location = [gestureRecognizer locationInView:self];

            // 是只允许在scrollView.contentOffset.x为0时侧滑返回生效
            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if ([self panBack:gestureRecognizer]) {
        return NO;
    }
    return YES;
}
-(BOOL)shouldRecognizeSimultaneously
{
    return [objc_getAssociatedObject(self, @"shouldRecognizeSimultaneously") boolValue];
}
-(void)setShouldRecognizeSimultaneously:(BOOL)shouldRecognizeSimultaneously
{
    objc_setAssociatedObject(self, @"shouldRecognizeSimultaneously", @(shouldRecognizeSimultaneously), OBJC_ASSOCIATION_RETAIN);
}

@end
