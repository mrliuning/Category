//
//  UITextField+Utils.m
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/29.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UITextField+Utils.h"
#import <objc/runtime.h>
#import <HUDManager/HUDManager.h>

@implementation UITextField (Utils)

/// 关联属性
/// @param maxTextLength 允许输入的最大字符串长度
- (void)setMaxTextLength:(NSInteger)maxTextLength {
    objc_setAssociatedObject(self, _cmd, @(maxTextLength), OBJC_ASSOCIATION_RETAIN);
    
    
    NSString *lang = [[UITextInputMode activeInputModes].firstObject primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];       //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            [self substringWhileMaxTextLength];
        }
    } else {// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        [self substringWhileMaxTextLength];
    }
}

/// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
- (void)substringWhileMaxTextLength {
    NSString *toBeString = self.text;
    if (toBeString.length > self.maxTextLength) {
        self.text = [toBeString substringToIndex:self.maxTextLength];
        [HUDManager showWarningWithText:@"字数超过限制"];
    }
}

/// maxTextLength get方法
- (NSInteger)maxTextLength {
    NSNumber *maxTextLength = objc_getAssociatedObject(self, @selector(setMaxTextLength:));
    return maxTextLength.integerValue;
}
@end
