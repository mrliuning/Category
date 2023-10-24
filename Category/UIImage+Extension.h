//
//  UIImage+Extension.h
//  PublishMoments-demo
//
//  Created by 李亚川 on 2020/4/27.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

/**
 修正图片转向、压缩、拉伸和截图图片
 */
@interface UIImage (Extension)

/// 修正图片转向
/// @param aImage 原图片
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/// 压缩到固定宽度
/// @param sourceImage 原图片
/// @param defineWidth 宽度
+ (UIImage *)compressSourceImage:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/// 压缩到固定宽度
/// @param width 宽度
- (UIImage *)compressOriginalToMaxDataWidth:(CGFloat)width;

/*!
 *  @brief 使图片压缩后刚好小于指定大小
 *
 *  @param image 当前要压缩的图 maxLength 压缩后的大小
 *
 *  @return 图片对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
+ (NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;

/// 创建一个拉伸不变形的图片
/// @param name 图片名称
+ (instancetype)resizableImageNamed:(NSString *)name;

/// 创建一个内容可拉伸，而边角不拉伸的图片
/// @param name 图片名称
/// @param left 左边不拉伸区域的宽度
/// @param top 上面不拉伸的高度
+ (instancetype)resizableImageNamed:(NSString *)name left:(CGFloat)left top:(CGFloat)top;

/// 截取一张透明图片  截取一张png图片
/// @param view 要截图的view
+ (UIImage *)imagePNGFromView:(UIView *)view;

/// 获取截屏，所有window的截屏
+ (UIImage *)imageDataScreenShot;

/** 根据指定的范围剪切图片中的一部分 rect：需要剪切的位置*/
- (UIImage *)cutImageWithRect:(CGRect)rect;

/// 把view截图，并生成一张毛玻璃图片
/// @param view 要截图的view
/// @param blur 模糊数
+ (UIImage *)boxblurImageFromView:(UIView *)view withBlurNumber:(CGFloat)blur;

/// 把image截图，并生成一张毛玻璃图片
/// @param image 要截图的image
/// @param blur 模糊数
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

//+ (void)WKWebViewScroll:(WKWebView *)webView CaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler ;

/// 生成二维码图片
/// @param urlString 二维码存储的数据
/// @param size 图片大小
+ (UIImage *)createQRImageWithUrl:(NSString *)urlString size:(CGFloat)size;


/// 获取圆形图
- (UIImage*)circleImage;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// 从指定bundle里面获取图片
/// @param name 图片名称
/// @param bundleName bundleName
+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName;
@end
