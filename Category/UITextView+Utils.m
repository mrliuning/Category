//
//  UITextView+Utils.m
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/29.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UITextView+Utils.h"
#import <objc/runtime.h>

@implementation UITextView (Utils)
@dynamic placeholder;
@dynamic placeholderLabel;
@dynamic textValue;



+(instancetype)textViewWithPlaceHolder:(NSString *)placeHolder frame:(CGRect)frame textFont:(CGFloat)fontSize textColor:(UIColor *)textColor
{
    UITextView * aTextView = [[self alloc] initWithFrame:frame];
    aTextView.font = [UIFont systemFontOfSize:fontSize];
    aTextView.textColor = textColor;
    aTextView.placeholder =placeHolder;
    return aTextView;
}
/// 关联属性
/// @param maxTextLength 允许输入的最大字符串长度
- (void)setMaxTextLength:(NSInteger)maxTextLength {
    objc_setAssociatedObject(self, _cmd, @(maxTextLength), OBJC_ASSOCIATION_RETAIN);
    
    NSString *toBeString = self.text;
    NSString *lang = [[UITextInputMode activeInputModes].firstObject primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];       //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxTextLength) {
                self.text = [toBeString substringToIndex:maxTextLength];
            }
        }
    } else {// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > maxTextLength) {
            self.text = [toBeString substringToIndex:maxTextLength];
        }
    }
}

/// maxTextLength get方法
- (NSInteger)maxTextLength {
    NSNumber *maxTextLength = objc_getAssociatedObject(self, @selector(setMaxTextLength:));
    return maxTextLength.integerValue;
}
-(void)setTextValue:(NSString *)textValue
{
    //  Change the text of our UITextView, and check whether we need to display the placeholder.
    self.text = textValue;
    if (self.delegate&& [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self];
    }
    [self checkIfNeedToDisplayPlaceholder];
}
-(NSString*)textValue
{
    return self.text;
}

-(void)checkIfNeedToDisplayPlaceholder
{
    //  If our UITextView is empty, display our Placeholder label (if we have one)
    if (self.placeholderLabel == nil)
        return;
    
    self.placeholderLabel.hidden = (![self.text isEqualToString:@""]);
}

-(void)onTap
{
    //  When the user taps in our UITextView, we'll see if we need to remove the placeholder text.
    [self checkIfNeedToDisplayPlaceholder];
    
    //  Make the onscreen keyboard appear.
    [self becomeFirstResponder];
}

-(void)keyPressed:(NSNotification*)notification
{
    //  The user has just typed a character in our UITextView (or pressed the delete key).
    //  Do we need to display our Placeholder label ?
    [self checkIfNeedToDisplayPlaceholder];
}

#pragma mark - Add a "placeHolder" string to the UITextView class

NSString const *kTJKeyPlaceHolder = @"kTJKeyPlaceHolder";
-(void)setPlaceholder:(NSString *)_placeholder
{
    //  Sets our "placeholder" text string, creates a new UILabel to contain it, and modifies our UITextView to cope with
    //  showing/hiding the UILabel when needed.
    objc_setAssociatedObject(self, &kTJKeyPlaceHolder, (id)_placeholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.frame.size.width-8, 0)];
    self.placeholderLabel.numberOfLines = 3;
    self.placeholderLabel.text = _placeholder;
    self.placeholderLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.userInteractionEnabled = true;
    self.placeholderLabel.font = self.font;
    [self addSubview:self.placeholderLabel];
    
    [self.placeholderLabel sizeToFit];
    
    //  Whenever the user taps within the UITextView, we'll give the textview the focus, and hide the placeholder if necessary.
    [self.placeholderLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
    
    //  Whenever the user types something in the UITextView, we'll see if we need to hide/show the placeholder label.
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyPressed:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self checkIfNeedToDisplayPlaceholder];
}
-(NSString*)placeholder
{
    //  Returns our "placeholder" text string
    return objc_getAssociatedObject(self, &kTJKeyPlaceHolder);
}

#pragma mark - Add a "UILabel" to this UITextView class

NSString const *kTJKeyLabel = @"kTJKeyLabel";
-(void)setPlaceholderLabel:(UILabel *)placeholderLabel
{
    //  Stores our new UILabel (which contains our placeholder string)
    objc_setAssociatedObject(self, &kTJKeyLabel, (id)placeholderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyPressed:) name:UITextViewTextDidChangeNotification object:nil];
    
    [self checkIfNeedToDisplayPlaceholder];
}
-(UILabel*)placeholderLabel
{
    //  Returns our new UILabel
    return objc_getAssociatedObject(self, &kTJKeyLabel);
}

@end
