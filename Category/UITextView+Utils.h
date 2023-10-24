//
//  UITextView+Utils.h
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/29.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
UITextField 类别 增加允许输入的最大字符串长度
*/
@interface UITextView (Utils)
//允许输入的最大字符串长度
@property (nonatomic, assign) NSInteger maxTextLength;
@property (nonatomic, strong) NSString* placeholder;
@property (nonatomic, strong) UILabel * placeholderLabel;
@property (nonatomic, strong) NSString* textValue;
-(void)checkIfNeedToDisplayPlaceholder;
+(instancetype)textViewWithPlaceHolder:(NSString *)placeHolder frame:(CGRect)frame textFont:(CGFloat)fontSize textColor:(UIColor *)textColor;
@end

NS_ASSUME_NONNULL_END
