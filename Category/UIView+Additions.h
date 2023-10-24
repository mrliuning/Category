//
//  UIView+Additions.h
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/29.
//  Copyright © 2020 tianjiu. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIView (Additions)

// Position of the top-left corner in superview's coordinates
@property CGPoint origin;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
// makes hiding more logical
@property BOOL    visible;
// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

/// 初始化父视图
/// @param parent 父视图
- (id) initWithParent:(UIView *)parent;

/// 移除所有子视图
-(void)removeAllSubViews;

/// 设置背景图片
/// @param image 图片
- (void)setBackgroundImage:(UIImage*)image;

/// 对当前屏幕截屏
- (UIImage*)toImage;


@end


@interface UIView (create)

/// 手势添加block事件

@property (nonatomic,copy)void(^gestureTapBlock)(UITapGestureRecognizer * gesture);

/// 在preView底部插件一条分割线
/// @param preView preView
+ (nullable instancetype)viewWithSeperateLineView:(nullable UIView *)preView;

/// 实例化一个视图
/// @param frame 视图的frame
/// @param backgroundColor 视图背景色
+ (nullable instancetype)viewWithFrame:(CGRect)frame color:(nullable UIColor *)backgroundColor;

/// 给View 添加手势回调
/// @param tapBlock 手势j点击回调
-(void)addTapGestureWithCompletBlcok:(void (^)(UITapGestureRecognizer *gesture))tapBlock;

@end

@interface UILabel (create)

/// 实例化一个label
/// @param text label上显示的文字
/// @param textcolor 字体颜色
/// @param textAlignment 显示模式
/// @param sizeNum 字体大小
/// @param numberOfLines 显示行数
+(nullable instancetype)labelWithTitle:(nullable NSString *)text color:(nullable UIColor *)textcolor textAlignment:(NSTextAlignment)textAlignment textFont:(NSInteger)sizeNum numberOfLines:(NSInteger)numberOfLines;


/// 实例化一个label
/// @param text label上显示的文字
/// @param frame fram大小
/// @param textcolor 字体颜色
/// @param textAlignment 显示模式
/// @param sizeNum 字体大小
/// @param numberOfLines 显示行数
+(nullable instancetype)labelWithTitle:(nullable NSString *)text frame:(CGRect)frame color:(nullable UIColor *)textcolor textAlignment:(NSTextAlignment)textAlignment textFont:(NSInteger)sizeNum numberOfLines:(NSInteger)numberOfLines;

@end

typedef void(^ButtonClickCallBack)(UIButton *button);

@interface UIButton (ClickBlock)

/// 给UIButton添加一个点击事件的回调
@property (copy, nonatomic) ButtonClickCallBack callBlock;
@property (nonatomic) SEL perAction;
@property (nonatomic,assign) BOOL isAllowContinuousClick;//是否允许连续点击

@end
@interface UIButton (create)

/// 实例化一个UIButton
/// @param title 按钮显示的文字
/// @param titleColor 文字颜色
/// @param sizeNum 字体大小
/// @param image 按钮显示的图片
/// @param selecteImage 按钮选中状态显示的图片
/// @param block 按钮点击事件block回调
+(nullable instancetype)btnWithTitle:(nullable NSString *)title Color:(nullable UIColor *)titleColor Font:( NSInteger)sizeNum bgimage:(nullable UIImage *)image selectebgImage:(nullable UIImage *)selecteImage callBack:(void(^ _Nullable)(UIButton * _Nullable btn))block;

/// 实例化一个UIButton
/// @param title 按钮显示的文字
/// @param frame fram大小
/// @param titleColor 文字颜色
/// @param sizeNum 字体大小
/// @param image 按钮显示的图片
/// @param selecteImage 按钮选中状态显示的图片
/// @param block 按钮点击事件block回调
+(nullable instancetype)btnWithTitle:(nullable NSString *)title frame:(CGRect)frame Color:(nullable UIColor *)titleColor Font:( NSInteger)sizeNum bgimage:(nullable UIImage *)image selectebgImage:(nullable UIImage *)selecteImage callBack:(void(^ _Nullable)(UIButton * _Nullable btn))block;


/// 实例化一个UIButton
/// @param title 按钮显示的文字
/// @param titleColor 文字颜色
/// @param block 按钮点击事件block回调
+ (nullable instancetype)btnWithTitle:(nullable NSString *)title Color:(nullable UIColor *)titleColor callBack:(void (^ _Nullable)(UIButton * _Nullable btn))block;

/// 实例化一个纯文字的UIButton
/// @param title 按钮显示的文字
/// @param font 字体大小
/// @param color 字体颜色
/// @param bgColor 按钮背景色
+ (_Nullable instancetype)btnWithTitle:(NSString *_Nullable)title font:(UIFont *_Nullable)font color:(UIColor *_Nullable)color bgColor:(UIColor *_Nullable)bgColor;


/// 实例化一个纯图片的UIButton
/// @param img 图片
/// @param margin 图片左右预留的边距
+ (instancetype _Nullable)btnWithImage:(NSString *_Nullable)img margin:(CGFloat) margin;


/// 实例化一个纯图片的UIButton
/// @param img 图片
/// @param hMargin 图片左右预留的边距
/// @param vMargin 图片上下预留的边距
+ (instancetype _Nullable)btnWithImage:(NSString *_Nullable)img hMargin:(CGFloat)hMargin vMargin:(CGFloat)vMargin;


/// 实例化一个 图片 + 文字 的按钮
/// @param img 图片
/// @param title 文字
/// @param font 字体大小
/// @param color 字体颜色
/// @param padding 图片和文字的间距
+ (instancetype _Nullable)btnWithImage:(NSString *_Nullable)img title:(NSString *_Nullable)title font:(UIFont *_Nullable)font color:(UIColor *_Nullable)color padding:(CGFloat)padding;


/// 实例化一个 背景图片 + 文字 的按钮
/// @param bgImg 背景图片
/// @param title 文字
/// @param font 字体大小
/// @param color 字体颜色
+ (instancetype _Nullable)btnWithBgImage:(NSString *_Nullable)bgImg title:(NSString *_Nullable)title font:(UIFont *_Nullable)font color:(UIColor *_Nullable)color;

@end

@interface UIImageView (create)

/// 实例化一个UIImageView
/// @param image UIImageView显示的图片
+(nullable instancetype)imageViewWithImage:(nullable UIImage *)image;



/// 实例化一个UIImageView
/// @param image UIImageView显示的图片
/// @param frame frame大小
+(nullable instancetype)imageViewWithImage:(nullable UIImage *)image frame:(CGRect)frame;

@end
@interface UITextField (create)

/// 实例化一个UITextfield
/// @param placeholderString 占位文字
/// @param sizeNum 字体大小
/// @param textAlignment 显示模式
/// @param borderStyle 边框类型
/// @param clear 开始编辑之前是否清空文字
/// @param secure 是否是secureTextEntry
/// @param keyBoardStyle 键盘模式
+(nullable instancetype)textFieldWithPlaceHolder:(nullable NSString *)placeholderString font:(NSInteger)sizeNum textAlignment:(NSTextAlignment)textAlignment borderStyle:(UITextBorderStyle)borderStyle clearOnBeginEditing:(BOOL)clear secure:(BOOL)secure keyBoardStyle:(UIKeyboardType)keyBoardStyle;



/// 实例化一个UITextfield
/// @param placeholderString 占位文字
/// @param frame frame
/// @param sizeNum 字体大小
/// @param textAlignment 显示模式
/// @param textColor 字体颜色
+(nullable instancetype)textFieldWithPlaceHolder:(nullable NSString *)placeholderString frame:(CGRect)frame font:(NSInteger)sizeNum textAlignment:(NSTextAlignment)textAlignment color:(nullable UIColor *)textColor;

@end
