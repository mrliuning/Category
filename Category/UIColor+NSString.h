//
//  UIColor+NSString.h
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/28.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 字符串类型的色值转颜色
 */
@interface UIColor (NSString)

/// 以#开头的字符串（不区分大小写）转UIColor，如：#ffFFff，若需要alpha，则传#abcdef255，不传默认为1
/// @param name 色值字符串
+ (UIColor *)colorWithString:(NSString *)name;

/// 以#开头的字符串（不区分大小写）转UIColor
/// @param name 色值，如：#ffFFff
/// @param alpha 不透明度
+ (UIColor *)colorWithHexString:(NSString *)name alpha:(CGFloat)alpha;

/// 返回构成颜色的RGB颜色空间的分量
/// @param rPtr 红色
/// @param gPtr 绿色
/// @param bPtr 蓝色来源颜色
/// @param color 来源颜色
+ (void)getRed:(CGFloat *)rPtr green:(CGFloat *)gPtr blue:(CGFloat *)bPtr fromColor:(UIColor *)color;


/// 生成渐变颜色
/// @param fromColor 起始颜色
/// @param finalColor 最终颜色
/// @param ratio 转化率
+ (UIColor *)getColorWithFromColor:(UIColor *)fromColor finalColor:(UIColor *)finalColor andRatio:(CGFloat)ratio;
@end
