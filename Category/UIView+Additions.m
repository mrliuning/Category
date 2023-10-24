//
//  UIView+Additions.h
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/29.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UIView+Additions.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
static char kAddGestureRecognizerKey;
@implementation UIView (Additions)

/// 初始化父视图
/// @param parent 父视图
- (id)initWithParent:(UIView *)parent {
	self = [self initWithFrame:CGRectZero];
	
	if (!self)
		return nil;
	[parent addSubview:self];
	return self;
}

/// 设置背景图片
/// @param image 图片
- (void)setBackgroundImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(self.frame.size);
    [image drawInRect:self.bounds];
    UIImage *bgImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:bgImage];
}

/// 对当前屏幕截屏
- (UIImage*)toImage
{
     UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     [self.layer renderInContext:ctx];
     UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return tImage;
}
- (CGPoint)origin {
	return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin {
	CGRect rect = self.frame;
	rect.origin = origin;
	[self setFrame:rect];
}
- (CGFloat)left {
	return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}
- (CGFloat)top {
	return self.frame.origin.y;
}
- (void)setTop:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}
- (CGFloat)right {
	return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = right - frame.size.width;
	self.frame = frame;
}
- (CGFloat)bottom {
	return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}
- (CGFloat)centerX {
    return self.center.x;
}
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}
- (CGFloat)centerY {
    return self.center.y;
}
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}
- (BOOL)visible {
	return !self.hidden;
}
- (void)setVisible:(BOOL)visible {
	self.hidden=!visible;
}
/// 移除所有子视图
-(void)removeAllSubViews{
	for (UIView *subview in self.subviews){
		[subview removeFromSuperview];
	}
	
}
- (CGSize)size {
	return [self frame].size;
}

- (void)setSize:(CGSize)size {
	CGRect rect = self.frame;
	rect.size = size;
	[self setFrame:rect];
}
- (CGFloat)width {
	return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
	CGRect rect = self.frame;
	rect.size.width = width;
	[self setFrame:rect];
}
- (CGFloat)height {
	return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
	CGRect rect = self.frame;
	rect.size.height = height;
	[self setFrame:rect];
}
@end

@implementation UIView (create)

+ (nullable instancetype)viewWithSeperateLineView:(nullable UIView *)preView
{
    UIView *view = [[self alloc] init];
    
    view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1];
    
    CGRect aFrame = preView.frame;
    view.frame = CGRectMake(aFrame.origin.x, aFrame.origin.y + aFrame.size.height, aFrame.size.width, 1);
    return view;
}
+ (nullable instancetype)viewWithFrame:(CGRect)frame color:(nullable UIColor *)backgroundColor
{
    UIView *view = [[self alloc] init];
    view.frame = frame;
    view.backgroundColor = backgroundColor;
    
    return view;
}

-(void)setGestureTapBlock:(void (^)(UITapGestureRecognizer *))gestureTapBlock
{
    objc_setAssociatedObject(self, &kAddGestureRecognizerKey, gestureTapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(void (^)(UITapGestureRecognizer *))gestureTapBlock
{
    return objc_getAssociatedObject(self, &kAddGestureRecognizerKey);
}


-(void)addTapGestureWithCompletBlcok:(void (^)(UITapGestureRecognizer *gesture))tapBlock
{
    self.userInteractionEnabled = YES;
    self.gestureTapBlock = tapBlock;
    UITapGestureRecognizer * aTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:aTapGesture];
    
}
-(void)tapView:(UITapGestureRecognizer *)sender
{
    if (self.gestureTapBlock) {
        self.gestureTapBlock(sender);
    }
}

@end

@implementation UILabel (create)

+(nullable instancetype)labelWithTitle:(nullable NSString *)text color:(nullable UIColor *)textcolor textAlignment:(NSTextAlignment)textAlignment textFont:(NSInteger)sizeNum numberOfLines:(NSInteger)numberOfLines
{
    UILabel * label = [[self alloc]init];
    label.text=text;
    label.textColor =textcolor;
    if (sizeNum != 0) {
        label.font=[UIFont systemFontOfSize:sizeNum];
    }
    label.textAlignment =textAlignment;
    label.numberOfLines =numberOfLines;
    return label;
}


+(nullable instancetype)labelWithTitle:(nullable NSString *)text frame:(CGRect)frame color:(nullable UIColor *)textcolor textAlignment:(NSTextAlignment)textAlignment textFont:(NSInteger)sizeNum numberOfLines:(NSInteger)numberOfLines
{
    UILabel *label = [self labelWithTitle:text color:textcolor textAlignment:textAlignment textFont:sizeNum numberOfLines:numberOfLines];
    label.frame = frame;
    return label;
}

@end
static NSString *buttonClickKey = @"buttonClickKeybuttonClickKey";
@implementation UIButton (ClickBlock)
+ (void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA =@selector(sendAction:to:forEvent:);
        SEL selB =@selector(mySendAction:to:forEvent:);
        Method methodA =class_getInstanceMethod(self, selA);
        Method methodB =class_getInstanceMethod(self, selB);
        //将methodB的实现添加到系统方法中也就是说将methodA方法指针添加成方法methodB的返回值表示是否添加成功
        BOOL isAdd =class_addMethod(self, selA,method_getImplementation(methodB),method_getTypeEncoding(methodB));
        //添加成功了说明本类中不存在methodB所以此时必须将方法b的实现指针换成方法A的，否则b方法将没有实现。
        if(isAdd) {
            class_replaceMethod(self, selB,method_getImplementation(methodA),method_getTypeEncoding(methodA));
        }else{
            //添加失败了说明本类中有methodB的实现，此时只需要将methodA和methodB的IMP互换一下即可。
            method_exchangeImplementations(methodA, methodB);
        }
    });
}
- (BOOL)drawViewHierarchyInRect:(CGRect)rect
             afterScreenUpdates:(BOOL)afterUpdates;
{
    return YES;
}
- (void)setPerAction:(SEL)perAction
{
    objc_setAssociatedObject(self, _cmd, NSStringFromSelector(perAction), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SEL)perAction
{
    NSString *selector = objc_getAssociatedObject(self, @selector(setPerAction:));
    return NSSelectorFromString(selector);
}
- (void)setCallBlock:(ButtonClickCallBack)callBlock
{
    objc_setAssociatedObject(self, &buttonClickKey, callBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    // 设置button执行的方法
    [self addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
}
- (ButtonClickCallBack )callBlock
{
    return objc_getAssociatedObject(self, &buttonClickKey);
}
- (void)buttonClicked {
    // 通过静态的索引key，获取被关联对象（这里就是回调的block）
    ButtonClickCallBack callBack = objc_getAssociatedObject(self, &buttonClickKey);
    if (callBack) {
        callBack(self);
    }
}
-(BOOL)kForbidenClickWithTime:(CGFloat)seconds
{
    static BOOL shouldPrevent;
    if (shouldPrevent)
        return YES;
    shouldPrevent = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((seconds) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        shouldPrevent = NO;
    });
    return NO;
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent*)event
{
    if ([self kForbidenClickWithTime:0.5] && (action == self.perAction) && !self.isAllowContinuousClick) {
        return;
    }
    [self mySendAction:action to:target forEvent:event];
    
    self.perAction = action;
}
-(void)setIsAllowContinuousClick:(BOOL)isAllowContinuousClick
{
    objc_setAssociatedObject(self, @"isAllowContinuousClick", @(isAllowContinuousClick), OBJC_ASSOCIATION_RETAIN);
}
-(BOOL)isAllowContinuousClick
{
    NSNumber * number = objc_getAssociatedObject(self, @"isAllowContinuousClick");
    return [number boolValue];
}
@end
@implementation UIButton (create)

+(nullable instancetype)btnWithTitle:(nullable NSString *)title Color:(nullable UIColor *)titleColor Font:( NSInteger)sizeNum bgimage:(nullable UIImage *)image selectebgImage:(nullable UIImage *)selecteImage callBack:(void(^ _Nullable)(UIButton * _Nullable btn))block
{
    UIButton * btn =[self buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (sizeNum != 0) {
       btn.titleLabel.font =[UIFont systemFontOfSize:sizeNum];
    }
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:selecteImage forState:UIControlStateSelected];
    btn.callBlock = block;
    return btn;
}

+(nullable instancetype)btnWithTitle:(nullable NSString *)title frame:(CGRect)frame Color:(nullable UIColor *)titleColor Font:( NSInteger)sizeNum bgimage:(nullable UIImage *)image selectebgImage:(nullable UIImage *)selecteImage callBack:(void(^ _Nullable)(UIButton * _Nullable btn))block
{
    UIButton * btn =[self buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (sizeNum != 0) {
       [btn.titleLabel setFont:[UIFont systemFontOfSize:sizeNum]];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    if (image) {
        [btn setBackgroundImage:image forState:UIControlStateNormal];
    }
    if (selecteImage) {
        [btn setBackgroundImage:selecteImage forState:UIControlStateSelected];
    }
    btn.callBlock = block;
    return btn;
}


+ (nullable instancetype)btnWithTitle:(nullable NSString *)title Color:(nullable UIColor *)titleColor callBack:(void (^ _Nullable)(UIButton * _Nullable btn))block
{
    UIButton * btn =[self buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.callBlock = block;
    return btn;
}

/** 纯文字的按钮 */
+ (instancetype)btnWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color bgColor:(UIColor *)bgColor
{
    UIButton *btn = [[self alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    btn.backgroundColor = bgColor;
    btn.titleLabel.font = font;
    [btn sizeToFit];
    
    return btn;
}


/** 纯图片的按钮 */
+ (instancetype)btnWithImage:(NSString *)img margin:(CGFloat) margin
{
    return [self btnWithImage:img hMargin:margin vMargin:0];
}
/** 纯图片的按钮 */
+ (instancetype)btnWithImage:(NSString *_Nullable)img hMargin:(CGFloat)hMargin vMargin:(CGFloat)vMargin
{
    UIButton *btn = [[self alloc] init];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateHighlighted];
    UIImage *selectedImg = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s", img]];
    if (selectedImg) {
        [btn setImage:selectedImg forState:UIControlStateSelected];
    }
    btn.contentMode = UIViewContentModeCenter;
    [btn sizeToFit];
    if (hMargin > 0) {
        CGFloat width = btn.width;
        btn.width = width + 2*hMargin;
    }
    if (vMargin > 0) {
        CGFloat width = btn.height;
        btn.height = width + 2*vMargin;
    }
    return btn;
}

/** 图片 + 文字 的按钮 */
+ (instancetype)btnWithImage:(NSString *)img title:(NSString *)title font:(UIFont *)font color:(UIColor *)color padding:(CGFloat)padding
{
    UIButton *btn = [[self alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateHighlighted];
    btn.contentMode = UIViewContentModeCenter;
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, padding);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, padding, 0, -padding);
    [btn.titleLabel sizeToFit];
    [btn sizeToFit];
    CGFloat w = btn.width;
    btn.width = w + padding;
    CGFloat h = btn.height;
    btn.height = h + 10;
    return btn;
}

/** 背景图片 + 文字 的按钮 */
+ (instancetype)btnWithBgImage:(NSString *)bgImg title:(NSString *)title font:(UIFont *)font color:(UIColor *)color
{
    UIButton *btn = [[self alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn setBackgroundImage:[UIImage imageNamed:bgImg] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:bgImg] forState:UIControlStateHighlighted];
    [btn.titleLabel sizeToFit];
    [btn sizeToFit];
    return btn;
}
@end

@implementation UIImageView (create)

+(instancetype)imageViewWithImage:(nullable UIImage *)image
{
    UIImageView *imageName =[[self alloc]initWithImage:image];
    return imageName;
}

+(instancetype)imageViewWithImage:(nullable UIImage *)image frame:(CGRect)frame
{
    UIImageView *imageView = [self imageViewWithImage:image];
    imageView.clipsToBounds = YES;
    imageView.frame = frame;
    return imageView;
}

@end
@implementation UITextField (create)

+(instancetype)textFieldWithPlaceHolder:(nullable NSString *)placeholderString font:(NSInteger)sizeNum textAlignment:(NSTextAlignment)textAlignment borderStyle:(UITextBorderStyle)borderStyle clearOnBeginEditing:(BOOL)clear secure:(BOOL)secure keyBoardStyle:(UIKeyboardType)keyBoardStyle
{
    UITextField * textField =[[UITextField alloc]init];
    textField.placeholder =placeholderString;
    textField.font =[UIFont boldSystemFontOfSize:sizeNum];
    textField.textAlignment =textAlignment;
    textField.borderStyle =borderStyle;
    textField.clearsOnBeginEditing =clear;
    textField.secureTextEntry =secure;
    textField.keyboardType =keyBoardStyle;
    return textField;
}


+(instancetype)textFieldWithPlaceHolder:(nullable NSString *)placeholderString frame:(CGRect)frame font:(NSInteger)sizeNum textAlignment:(NSTextAlignment)textAlignment color:(nullable UIColor *)textColor
{
    UITextField * textField =[[UITextField alloc]initWithFrame:frame];
    textField.placeholder =placeholderString;
    textField.font =[UIFont boldSystemFontOfSize:sizeNum];
    textField.textAlignment =textAlignment;
    textField.textColor = textColor;
    return textField;
}
@end

