//
//  UIView+common.m
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/29.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UIView+common.h"
#import "NSString+Utils.h"
#import <objc/runtime.h>
#import <Macro/CommonGlobalMacro.h>
#import "UIView+Additions.h"
#import "YYText.h"
#import <MBProgressHUD.h>>

@implementation UIView (common)

- (void)setTypeTag:(NSInteger)typeTag {
    objc_setAssociatedObject(self, @"typeTag", @(typeTag), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)typeTag {
    NSNumber * aNum = objc_getAssociatedObject(self, @"typeTag");
    return [aNum integerValue];
}

- (void)showMessageWithText:(NSString *)text{
    if (!text.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *alertLabel = [self creatLabelWithText:text atBottom:NO];
        
        NSTimeInterval duration = text.length > 15 ? 3 : 2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                alertLabel.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [alertLabel removeFromSuperview];
            }];
        });
    });
}

- (void)showMessageAtTopWithText:(NSString *)text
{
    if (!text.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *alertLabel = [self creatLabelWithText:text atBottom:NO];
        alertLabel.top = (self.height - alertLabel.height) * 0.4;
        
        NSTimeInterval duration = text.length > 15 ? 3 : 2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                alertLabel.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [alertLabel removeFromSuperview];
            }];
        });
    });
}

- (void)showMessageAtBottomCornerWithText:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *alertLabel = [self creatLabelWithText:text atBottom:YES];
        
        NSTimeInterval duration = text.length > 15 ? 3 : 2;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                alertLabel.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [alertLabel removeFromSuperview];
            }];
        });
    });
}

- (void)showMessageWithText:(NSString *)text icon:(NSString *)icon {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:(self?:[UIApplication sharedApplication].keyWindow) animated:YES];
        hud.userInteractionEnabled = NO;
        hud.label.text = text;
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.contentColor = [UIColor whiteColor];
        hud.customView = [UIImageView imageViewWithImage:[UIImage imageNamed:icon]];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0.75f];
        hud.bezelView.layer.masksToBounds = YES;
        hud.bezelView.layer.cornerRadius = 10;
        hud.mode = MBProgressHUDModeCustomView;
        hud.removeFromSuperViewOnHide = YES;
        NSTimeInterval duration = text.length > 15 ? 3 : 2;
        [hud hideAnimated:YES afterDelay:duration];
    });
}

- (UIView *)creatLabelWithText:(NSString *)text atBottom:(BOOL)atBottom
{
    UIView *aAlert = [[UIView alloc] init];
    
    YYLabel *alertLabel = [[YYLabel alloc] init];
    alertLabel.numberOfLines = 0;
    NSString *aText = ([text isEqual:@"error"]?@"网络错误,请检查网络":text)?:@"";
    
    NSMutableAttributedString *aAtt = [[NSMutableAttributedString alloc] initWithString:aText];
    aAtt.yy_font = [UIFont systemFontOfSize:14];
    aAtt.yy_color = [UIColor whiteColor];
    aAtt.yy_lineSpacing = 4;
    alertLabel.attributedText = aAtt;
    
    CGFloat left = 20;
    CGFloat top = 16;
    CGFloat maxW = self.width - left*4;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    YYTextLayout *aLayout = [YYTextLayout layoutWithContainerSize:maxSize text:aAtt];
    CGSize aSize = aLayout.textBoundingSize;
    alertLabel.size = CGSizeMake(aSize.width+0.5, aSize.height);
    alertLabel.left = left;
    alertLabel.top = top;
   
    // 放在前面会影响部分机型
    aAtt.yy_alignment = NSTextAlignmentCenter;

    aAlert.size = CGSizeMake(alertLabel.width + 2*left, alertLabel.height+top*2) ;
    aAlert.centerX = self.width/2;
    aAlert.top = !atBottom? (self.height - aAlert.height) * 0.5 : self.height - 2*aAlert.height;

    aAlert.layer.masksToBounds = YES;
    aAlert.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1.0];
    aAlert.layer.cornerRadius = 10.0f;
    [aAlert addSubview:alertLabel];
    [self?:[UIApplication sharedApplication].keyWindow addSubview:aAlert];
    [aAlert.superview bringSubviewToFront:aAlert];
    
    return aAlert;
}


/// 找到自己的vc
- (UIViewController *)viewController{
    for (UIView* next = self; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
/// 获取半角视图
-(void)getHalfCornerView
{
    if (!self.bounds.size.width || !self.bounds.size.height) {
        return;
    }
    UIBezierPath *bezierPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.width, self.height)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}

/// 设置圆角
/// @param radiu 半径大小
-(void)getCornerViewWithRadius:(CGFloat)radiu
{
    if (!self.bounds.size.width || !self.bounds.size.height) {
        return;
    }
    UIBezierPath *bezierPath=[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radiu];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = bezierPath.CGPath;
    self.layer.mask = maskLayer;
}

/// 设置圆角
/// @param radiu 半径大小   borderColor 边框颜色  borderWidth 边框宽度
-(void)getCornerViewWithRadius:(CGFloat)radiu borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    if (!self.bounds.size.width || !self.bounds.size.height) {
        return;
    }
    CAShapeLayer *maskLayer = nil;
    UIBezierPath *bezierPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth/2, borderWidth/2, self.bounds.size.width-borderWidth, self.bounds.size.height-borderWidth) cornerRadius:radiu];
    for (CALayer *subLayer in self.layer.sublayers) {
        if([subLayer.name isEqualToString:@"borderLayer"] && subLayer.superlayer){
            maskLayer = subLayer;
            break;
        }
    }
    if(!maskLayer){
        maskLayer = [CAShapeLayer layer];
        maskLayer.path = bezierPath.CGPath;
        maskLayer.frame = self.bounds;
        maskLayer.name = @"borderLayer";
    }
    maskLayer.strokeColor= borderColor.CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.lineWidth = borderWidth;
    [self.layer insertSublayer:maskLayer atIndex:0];
}

/// 设置顶部圆角
/// @param radiu 半径大小
-(void)getTopCornerWithRatio:(CGFloat)radiu
{
    if (!self.bounds.size.width || !self.bounds.size.height) {
        return;
    }
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radiu,radiu)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

/// 设置底部圆角
/// @param radiu 半径大小
-(void)getBottomCornerWithRatio:(CGFloat)radiu
{
    if (!self.bounds.size.width || !self.bounds.size.height) {
        return;
    }
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radiu,radiu)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

/// 设置左边圆角
/// @param radiu 半径大小
-(void)getLeftCornerWithRatio:(CGFloat)radiu
{
    if (!self.bounds.size.width || !self.bounds.size.height) {
        return;
    }
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(radiu,radiu)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}

/// 设置圆角
/// @param radiu 半径大小
-(void)getCornerByRoundingCorners:(UIRectCorner)corners ratio:(CGFloat)radiu
{
    if (!self.bounds.size.width || !self.bounds.size.height) {
        return;
    }
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radiu,radiu)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;

}

/// 添加由浅到深的蓝色渐变色，添加之前需要设置self.frame
- (CAGradientLayer *)doAddNormalBlueGradientLayer
{
    [self doRemoveGraditentLayer];
    // 渐变色,由浅到深
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.mTag = 1212;
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x539ffc).CGColor, (__bridge id)UIColorFromRGB(0x396ad7).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    return gradientLayer;
}

/// 移除渐变色layer
- (void)doRemoveGraditentLayer
{
    // 渐变色,由浅到深
    for (CAGradientLayer * layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAGradientLayer.class]) {
            if (layer.mTag == 1212) {
                [layer removeFromSuperlayer];
                return;
            }
        }
    }
   
}

/// 获取渐变色layer
- (CAGradientLayer *)doGetGraditentLayer
{
    // 渐变色,由浅到深
    for (CAGradientLayer * layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAGradientLayer.class]) {
            if (layer.mTag == 1212) {
                return layer;
            }
        }
    }
}


/// 添加由深到浅的蓝色渐变色，添加之前需要设置self.frame
- (CAGradientLayer *)doAddCustomBlueGradientLayer
{
    [self doRemoveGraditentLayer];
    // 渐变色,由深到浅
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.mTag = 1212;
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)UIColorFromRGB(0x396ad7).CGColor, (__bridge id)UIColorFromRGB(0x539ffc).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    return gradientLayer;
}

/// 添加渐变色，添加之前需要设置self.frame
/// @param startColor 开始颜色
/// @param endColor 结束颜色
- (CAGradientLayer *)doAddBlueGradientLayerStartColor:(CGColorRef)startColor endColor:(CGColorRef)endColor
{
    return [self doAddBlueGradientLayerStartColor:startColor endColor:endColor startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
}

/// 添加渐变色，添加之前需要设置self.frame
/// @param startColor 开始颜色
/// @param endColor 结束颜色
/// @param startPoint 开始点
/// @param endPoint 结束点
- (CAGradientLayer *)doAddBlueGradientLayerStartColor:(CGColorRef)startColor endColor:(CGColorRef)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    [self doRemoveGraditentLayer];
    // 渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    [self.layer insertSublayer:gradientLayer atIndex:0];
    gradientLayer.mTag = 1212;
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(__bridge id)startColor, (__bridge id)endColor];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    return gradientLayer;
}

/// 顶部添加一个透明渐变的图层，直播间的聊天室
/// @param multiple 多样的
- (void)doAddAlphaGradientLayer:(CGFloat)multiple
{
    [self doAddAlphaGradientLayer:multiple direction:0];
}
- (void)doAddAlphaGradientLayer:(CGFloat)multiple direction:(NSInteger)direction
{
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    layer.colors = @[
                     (__bridge id)[UIColor colorWithWhite:0 alpha:0.0f].CGColor,
                     (__bridge id)[UIColor colorWithWhite:0 alpha:0.2f].CGColor,
                     (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor
                     ];
    layer.locations = @[@0, @(0.1* multiple), @(0.4 * multiple)];
    
    switch (direction) {
        case 0://从上至下
            layer.startPoint = CGPointMake(0.5, 0);
            layer.endPoint = CGPointMake(0.5, 1);
            break;
        case 1://从左至右
            layer.startPoint = CGPointMake(0, 0.5);
            layer.endPoint = CGPointMake(1, 0.5);
//            layer.frame = CGRectMake(0, 0, CGRectGetWidth(layer.frame) * multiple, CGRectGetHeight(layer.frame));
            break;
        case 2://从下至上
            layer.startPoint = CGPointMake(0.5, 1);
            layer.endPoint = CGPointMake(0.5, 0);
            break;
        case 3://从右至左
            layer.startPoint = CGPointMake(1, 0.5);
            layer.endPoint = CGPointMake(0, 0.5);
//            layer.frame = CGRectMake(CGRectGetWidth(layer.frame) * (1-multiple), 0, CGRectGetWidth(layer.frame) * multiple, CGRectGetHeight(layer.frame));
            break;
        case 4://左右都加
            layer.colors = @[
                             (__bridge id)[UIColor colorWithWhite:0 alpha:0.0f].CGColor,
                             (__bridge id)[UIColor colorWithWhite:0 alpha:0.2f].CGColor,
                             (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor,
                             (__bridge id)[UIColor colorWithWhite:0 alpha:1.0f].CGColor,
                             (__bridge id)[UIColor colorWithWhite:0 alpha:0.2f].CGColor,
                             (__bridge id)[UIColor colorWithWhite:0 alpha:0.0f].CGColor,
                             ];
            layer.locations = @[@0, @(0.1* multiple), @(0.4 * multiple),@(1 - 0.4 * multiple),@(1 - 0.1 * multiple),@1];
            layer.startPoint = CGPointMake(0, 0.5);
            layer.endPoint = CGPointMake(1, 0.5);
//            layer.frame = CGRectMake(CGRectGetWidth(layer.frame) * (1-multiple), 0, CGRectGetWidth(layer.frame) * multiple, CGRectGetHeight(layer.frame));
            break;
            
        default:
            layer.startPoint = CGPointMake(0.5, 0);
            layer.endPoint = CGPointMake(0.5, 1);
            break;
    }
    layer.frame = self.bounds;
    self.layer.mask = layer;
}

/// 边框阴影
/// @param aCornerRadius 半径
/// @param color 颜色
- (void)setupShadowWithCornerRadius:(CGFloat)aCornerRadius color:(UIColor *)color
{
    self.layer.cornerRadius = aCornerRadius;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowRadius = aCornerRadius;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.layer.bounds].CGPath;
}


/// 从UISearchBar里面获取输入框控件
/// @param aSearchBar 搜索框
+ (UITextField *)doGetTextFiledFromSearchBar:(UISearchBar *)aSearchBar
{
    UITextField *searchField = nil;
    for (UIView *aView in [[aSearchBar subviews].firstObject subviews]) {
       if ([aView isKindOfClass:[UITextField class]]) {
           searchField = (UITextField *)aView;
           break;
       }
       for (UIView *aSubView in aView.subviews) {
           if ([aSubView isKindOfClass:[UITextField class]]) {
               searchField = (UITextField *)aSubView;
               break;
           }
       }
    }
    return searchField;
}

@end


@implementation UIView (TJViewBorder)

/// layer传nil则默认为self.layer
/// @param width 宽
/// @param color 颜色
/// @param cornerRadius 半径
/// @param layer layer
- (void)setupBorderWidth:(CGFloat)width color:(CGColorRef)color cornerRadius:(CGFloat)cornerRadius needMaskLayer:(CALayer *)layer
{
    for (CAGradientLayer * layer in self.layer.sublayers) {
        if ([layer isKindOfClass:CAShapeLayer.class]) {
            if (layer.mTag == 1213) {
                [layer removeFromSuperlayer];
                break;
            }
        }
    }
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.lineWidth = width;
    borderLayer.mTag = 1213;
    borderLayer.strokeColor = color;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    borderLayer.path = bezierPath.CGPath;
    
    [self.layer insertSublayer:borderLayer atIndex:0];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = bezierPath.CGPath;
    if (layer) {
        [self.layer setMask:maskLayer];
    }else{
        [layer setMask:maskLayer];
    }
}

@end


@implementation CALayer (TJTagLayer)

-(NSInteger)mTag
{
    return  [objc_getAssociatedObject(self, @"layerTag") integerValue];
}
-(void)setMTag:(NSInteger)mTag
{
    objc_setAssociatedObject(self, @"layerTag", @(mTag), OBJC_ASSOCIATION_RETAIN);
}
@end
