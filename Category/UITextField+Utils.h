//
//  UITextField+Utils.h
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
@interface UITextField (Utils)
//允许输入的最大字符串长度
@property (nonatomic, assign) NSInteger maxTextLength;

@end

NS_ASSUME_NONNULL_END
