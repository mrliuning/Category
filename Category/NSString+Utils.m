//
//  NSString+Utils.m
//  NIMDemo
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//


#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <Macro/CommonObjectMacros.h>
#import <Macro/CommonBaseMacros.h>

#define http_str   @"http:"
#define https_str  @"https:"
#define m3u8_str   @".m3u8"
#define flv_str    @".flv"

@implementation NSString (Utils)

- (CGSize)stringSizeWithFont:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(ceil(maxW), MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font maxH:(CGFloat)maxH
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, ceil(maxH));
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGSize)sizeWithFont:(UIFont *)font lineSpace:(CGFloat)lineSpace  maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(ceil(maxW), MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

- (NSString *)MD5String {
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


- (NSUInteger)getBytesLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}


- (NSString *)stringByDeletingPictureResolution{
    NSString *doubleResolution  = @"@2x";
    NSString *tribleResolution = @"@3x";
    NSString *fileName = self.stringByDeletingPathExtension;
    NSString *res = [self copy];
    if ([fileName hasSuffix:doubleResolution] || [fileName hasSuffix:tribleResolution]) {
        res = [fileName substringToIndex:fileName.length - 3];
        if (self.pathExtension.length) {
           res = [res stringByAppendingPathExtension:self.pathExtension];
        }
    }
    return res;
}



/**
 * 根据图片地址截取宽高比
 */
-(float)getWhRatioWithPicURL{
    float aspectRatio = 1.0f;
    NSInteger extLocation = [NSString getExtLocation:self];
    if(extLocation == NSNotFound){
        return aspectRatio;
    }
    
    NSString * whRatioStr = @"whRatio";
    NSRange whRatioRange = [self rangeOfString:whRatioStr options:NSBackwardsSearch range:NSMakeRange(0, self.length)];
    if(whRatioRange.location != NSNotFound) {
        int startIndex = (int)whRatioRange.location + 8;
        NSString * whRatio = [self substringWithRange:NSMakeRange(startIndex, extLocation - startIndex)];
        aspectRatio = [whRatio floatValue];
    }
    return aspectRatio;
}

/**
 * 获取图片格式位置
 */
+(NSInteger)getExtLocation:(NSString *)picURL{
    //.png
    NSRange pngRange = [picURL rangeOfString:@".png" options:NSBackwardsSearch range:NSMakeRange(0, picURL.length)];
    while (pngRange.location != NSNotFound) {
        return pngRange.location;
    }
    
    //.jpeg
    NSRange jpegRange = [picURL rangeOfString:@".jpeg" options:NSBackwardsSearch range:NSMakeRange(0, picURL.length)];
    while (jpegRange.location != NSNotFound) {
        return jpegRange.location;
    }
    
    //.jpg
    NSRange jpgRange = [picURL rangeOfString:@".jpg" options:NSBackwardsSearch range:NSMakeRange(0, picURL.length)];
    while (jpgRange.location != NSNotFound) {
        return jpgRange.location;
    }
    
    //.bmp
    NSRange bmpRange = [picURL rangeOfString:@".bmp" options:NSBackwardsSearch range:NSMakeRange(0, picURL.length)];
    while (bmpRange.location != NSNotFound) {
        return bmpRange.location;
    }
    
    //.gif
    NSRange gifRange = [picURL rangeOfString:@".gif" options:NSBackwardsSearch range:NSMakeRange(0, picURL.length)];
    while (gifRange.location != NSNotFound) {
        return gifRange.location;
    }
    
    //.tiff
    NSRange tiffRange = [picURL rangeOfString:@".tiff" options:NSBackwardsSearch range:NSMakeRange(0, picURL.length)];
    while (tiffRange.location != NSNotFound) {
        return tiffRange.location;
    }
    
    return NSNotFound;
}

/// 校验是否是电话号码
/// @param mobile 被校验的字符串
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|7[0678])\\d{8}$";
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"(^1(3[0-2]|4[5]|5[56]|6[6]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];

        BOOL isMatch4 = [pred4 evaluateWithObject:mobile];

        
        if (isMatch1 || isMatch2 || isMatch3 || isMatch4) {
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
    }
}


/// 判断是否是手机号
//国际化临时代码
- (BOOL)isValidPhoneNumber
{
//    return YES;//为国际化打包做测试，不做手机号检验
    if ([self hasPrefix:@"286"]) {
        return YES;
    }
    NSString *regex = @"^1[0-9]{10}";
    return [self isValidateByRegex:regex];
}

- (BOOL)isValidateByRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}
/// 校验字符串是否全部为数字
- (BOOL)isNumber {
    NSString * checkedNumString = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}

/// 校验是否包含电话号码
- (BOOL)isContainsPhoneNumber {
    NSString *regex =  @"(.*?)[1][3-9][0-9]{9}(.*?)";
    NSString *aNewText = [self stringByReplacingOccurrencesOfString:@"-" withString:@""];
    aNewText = [aNewText stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [aNewText isValidateByRegex:regex];
}

/// 校验是否包含网址
- (BOOL)isContainsUrl
{
    NSError *error;
    NSDataDetector *dataDetector=[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSArray *arrayOfAllMatches=[dataDetector matchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    return arrayOfAllMatches.count;
}

- (NSString *)rtmpURL {
    if (([self hasPrefix:http_str] || [self hasPrefix:https_str]) && [self hasSuffix:m3u8_str]) {
        NSUInteger loc = https_str.length;
        NSUInteger len = self.length - https_str.length -  m3u8_str.length;
        if ([self hasPrefix:http_str]) {
            loc = http_str.length;
            len = self.length - http_str.length -  m3u8_str.length;
        }
        NSString *string = [self substringWithRange:NSMakeRange(loc, len)];
        return [NSString stringWithFormat:@"rtmp:%@", string];
    }
    
    if (([self hasPrefix:http_str] || [self hasPrefix:https_str]) && [self hasSuffix:flv_str]) {
        NSUInteger loc = https_str.length;
        NSUInteger len = self.length - https_str.length -  flv_str.length;
        if ([self hasPrefix:http_str]) {
            loc = http_str.length;
            len = self.length - http_str.length -  flv_str.length;
        }
        NSString *string = [self substringWithRange:NSMakeRange(loc, len)];
        return [NSString stringWithFormat:@"rtmp:%@", string];
    }
    
    return self;
}

/// 里面检索aTargetString，并返回NSRange数组
/// @param aTargetString 被检索的关键词
-(NSArray *)doMatchCharacters:(NSString *)aTargetString
{
    if (aTargetString.length==0 || !aTargetString) {
        return nil;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"%@",aTargetString] options:0 error:nil];

    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0,self.length)];

    NSMutableArray * aRangeArray = [NSMutableArray array];
    for(NSTextCheckingResult *result in [matches objectEnumerator]) {
        NSRange matchRange = [result range];
        [aRangeArray addObject:[NSValue valueWithRange:matchRange]];
    }
    return aRangeArray;
}
-(NSAttributedString *)getAttributeStringsubString:(NSString *)subString PreFont:(UIFont *)preFont PreColor:(UIColor *)preColor lastFont:(UIFont *)lastFont lastColor:(UIColor *)lastColor
{
    if (beNil(self)) {
        return [NSAttributedString new];
    }
    if (beNil(subString)) {
        NSMutableAttributedString * aAttStr = [[NSMutableAttributedString alloc]initWithString:self];
        [aAttStr addAttribute:NSFontAttributeName value:preFont range:NSMakeRange(0, self.length)];
        [aAttStr addAttribute:NSForegroundColorAttributeName value:preColor range:NSMakeRange(0, self.length)];
        return aAttStr;
    }
    NSRange range = [self rangeOfString:subString];
    NSRange preRange = range;
    NSRange lastRange = range;
    if (range.location == 0) {
        preRange = range;
        lastRange = NSMakeRange(preRange.length, self.length - preRange.length);
    }else
    {
        preRange = NSMakeRange(0,self.length - range.length);
        lastRange = range;
    }
    if (lastRange.location == NSNotFound) {
        NSAssert(lastRange.location == NSNotFound, @"请校验前后字符串是否是前包含后面的关系");
    }
    NSMutableAttributedString * aAttStr = [[NSMutableAttributedString alloc]initWithString:self];
    [aAttStr addAttribute:NSFontAttributeName value:preFont range:preRange];
    [aAttStr addAttribute:NSForegroundColorAttributeName value:preColor range:preRange];
    
    [aAttStr addAttribute:NSFontAttributeName value:lastFont range:lastRange];
    [aAttStr addAttribute:NSForegroundColorAttributeName value:lastColor range:lastRange];
    return  aAttStr;
}

/**
 * 获取 NSAttributedString
 */
-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace
{
    return [self getAttributeStrWithFont:font lineSpace:linespace alignment:NSTextAlignmentLeft];
}

-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace alignment:(NSTextAlignment)alignment
{
    return [self getAttributeStrWithFont:font lineSpace:linespace alignment:alignment lineBreakMode:NSLineBreakByCharWrapping];
}

-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace alignment:(NSTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    NSString *aString = self;
    if (beNil(self)) {
        aString = @" ";
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paraStyle.alignment = alignment;
    paraStyle.lineSpacing = linespace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};

    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:aString attributes:dic];
    return attributeStr;
}
/**
 * 获取 NSAttributedString
 */
-(NSAttributedString * )getAttributeStrWithFont:(UIFont*)font lineSpace:(float)linespace wordsSpace:(float)space
{
    NSString *aString = self;
    if (beNil(self)) {
        aString = @" ";
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = linespace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(space)
                          };

    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:aString attributes:dic];
    return attributeStr;
}
@end
