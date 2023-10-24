//
//  NSString+Utils.h
//  NIMDemo
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Utils)


/// 计算文字的size
/// @param font 文字字体大小
- (CGSize)stringSizeWithFont:(UIFont *)font;


/// 计算文字的size
/// @param font 文字字体
/// @param maxW 最大宽度限制
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
/// @param lineSpace 行间距
- (CGSize)sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace  maxW:(CGFloat)maxW;


/// 计算文字的size
/// @param font 文字字体
/// @param maxH 最大高度限制
- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH;



/// 计算文字显示一行的size，
/// @param font 文字字体
- (CGSize)sizeWithFont:(UIFont *)font;


/// 获取MD5字符串
- (NSString *)MD5String;


/// 获取字符长度
- (NSUInteger)getBytesLength;


/// 删除图片后缀
- (NSString *)stringByDeletingPictureResolution;

/**
 * 根据图片地址截取宽高比
 */
- (float)getWhRatioWithPicURL;

/// 校验是否是电话号码
/// @param mobile 被校验的字符串
+(BOOL)valiMobile:(NSString *)mobile;


/// 校验是否是电话号码
- (BOOL)isValidPhoneNumber;


/// 校验是否包含电话号码
- (BOOL)isContainsPhoneNumber;

/// 校验字符串是否全部为数字
- (BOOL)isNumber ;

/// 校验是否包含网址
- (BOOL)isContainsUrl;


/// 转化成rtmpURL
- (NSString *)rtmpURL;


/// 检索aTargetString，并返回NSRange数组
/// @param aTargetString 被检索的关键词
- (NSArray *)doMatchCharacters:(NSString *)aTargetString;

/// 简单的将两个字符串以 / 进行分割，并返回NSAttributedString字符串
-(NSAttributedString *)getAttributeStringsubString:(NSString *)subString PreFont:(UIFont *)preFont PreColor:(UIColor *)preColor lastFont:(UIFont *)lastFont lastColor:(UIColor *)lastColor;
/**
 * 获取 NSAttributedString
 */
-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace;
-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace alignment:(NSTextAlignment)alignment;
-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace alignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode;
-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace wordsSpace:(float)space;
@end
