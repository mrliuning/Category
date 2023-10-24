//
//  UIColor+NSString.m
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/28.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UIColor+NSString.h"
#import <Macro/CommonGlobalMacro.h>

int convertToInt(char c)
{
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    } else {
        return printf("字符非法!");
    }
}

@implementation UIColor (NSString)

/// 以#开头的字符串（不区分大小写），如：#ffFFff，若需要alpha，则传#abcdef255，不传默认为1
/// @param name 色值字符串
+ (UIColor *)colorWithString:(NSString *)name
{
    if (![[name substringToIndex:0] isEqualToString:@"#"] && name.length < 7) {
        return nil;
    }
    const char *str = [[name substringWithRange:NSMakeRange(1, 6)] UTF8String];
    NSString *alphaString = [name substringFromIndex:7];
    CGFloat red = (convertToInt(str[0])*16 + convertToInt(str[1])) / 255.0f;
    CGFloat green = (convertToInt(str[2])*16 + convertToInt(str[3])) / 255.0f;
    CGFloat blue = (convertToInt(str[4])*16 + convertToInt(str[5])) / 255.0f;
    CGFloat alpha = [alphaString isEqualToString:@""] ? 1 : alphaString.floatValue/255;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 以#开头的字符串（不区分大小写）转UIColor
/// @param name 色值，如：#ffFFff
/// @param alpha 不透明度
+ (UIColor *)colorWithHexString:(NSString *)name alpha:(CGFloat)alpha
{
    if (![[name substringToIndex:0] isEqualToString:@"#"] && name.length < 7) {
        return nil;
    }
    const char *str = [[name substringWithRange:NSMakeRange(1, 6)] UTF8String];
    CGFloat red = (convertToInt(str[0])*16 + convertToInt(str[1])) / 255.0f;
    CGFloat green = (convertToInt(str[2])*16 + convertToInt(str[3])) / 255.0f;
    CGFloat blue = (convertToInt(str[4])*16 + convertToInt(str[5])) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/// 返回构成颜色的RGB颜色空间的分量
/// @param rPtr 红色
/// @param gPtr 绿色
/// @param bPtr 蓝色来源颜色
/// @param color 来源颜色
+ (void)getRed:(CGFloat *)rPtr green:(CGFloat *)gPtr blue:(CGFloat *)bPtr fromColor:(UIColor *)color {
#if TARGET_OS_IPHONE
    
    // iOS
    
    BOOL done = NO;
    
    if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        done = [color getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
    }
    
    if (!done) {
        // The method getRed:green:blue:alpha: was only available starting iOS 5.
        // So in iOS 4 and earlier, we have to jump through hoops.
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        
        unsigned char pixel[4];
        CGContextRef context = CGBitmapContextCreate(&pixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)(kCGBitmapAlphaInfoMask & kCGImageAlphaNoneSkipLast));
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
        
        if (rPtr) {
            *rPtr = pixel[0] / 255.0f;
        }
        
        if (gPtr) {
            *gPtr = pixel[1] / 255.0f;
        }
        
        if (bPtr) {
            *bPtr = pixel[2] / 255.0f;
        }
        
        CGContextRelease(context);
        CGColorSpaceRelease(rgbColorSpace);
    }
    
#elif defined(DD_CLI) || !__has_include(<AppKit/NSColor.h>)
    
    // OS X without AppKit
    
    [color getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
    
#else /* if TARGET_OS_IPHONE */
    
    // OS X with AppKit
    
    NSColor *safeColor = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    [safeColor getRed:rPtr green:gPtr blue:bPtr alpha:NULL];
#endif /* if TARGET_OS_IPHONE */
}

/// 生成渐变颜色
/// @param fromColor 起始颜色
/// @param finalColor 最终颜色
/// @param ratio 比例
+(UIColor *)getColorWithFromColor:(UIColor *)fromColor finalColor:(UIColor *)finalColor andRatio:(CGFloat)ratio
{
    CGFloat theAlpha = 0;
    if ([finalColor isEqual:fromColor]) {
        return  finalColor;
    }
    if ([finalColor isEqual:[UIColor clearColor]]) {
        theAlpha = 1;
       return  finalColor = [fromColor colorWithAlphaComponent:(1 - ratio)];
    }
    if ([fromColor isEqual:[UIColor clearColor]]) {
        theAlpha = 2;
        return  finalColor = [finalColor colorWithAlphaComponent:ratio];
    }
    CGFloat preRed,preGreen,preBlue;
    CGFloat lastRed,lastGreen,lastBlue;
    [UIColor getRed:&preRed green:&preGreen blue:&preBlue fromColor:fromColor];
    [UIColor getRed:&lastRed green:&lastGreen blue:&lastBlue fromColor:finalColor];
    CGFloat Rcolor = lastRed - preRed;
    CGFloat Gcolor = lastGreen - preGreen;
    CGFloat Bcolor = lastBlue - preBlue;
    return ColorFromRGBA(preRed *255 + Rcolor*255*ratio, preGreen*255 + Gcolor*255*ratio, preBlue*255 + Bcolor*255*ratio,theAlpha==0?1:theAlpha==1?(1-ratio):ratio);
}
@end
