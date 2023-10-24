//
//  UIImage+Blur.h
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/28.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 模糊图片、通过URL获取视频和pdf的图片
 */
@interface UIImage (Blur)

/// 高斯模糊
/// @param blur 模糊数
- (UIImage *)boxWithBlurNumber:(CGFloat)blur;

/// 获取视频第一帧图片
/// @param url 视频链接
/// @param size 图片的尺寸
/// @param error 错误
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size error:(NSError **)error;

/// 获取pdf想对应的y图片
/// @param url pdf文件链接
/// @param pageNumber 页数
/// @param rect rect
/// @param error 错误
+ (UIImage *)getPDFImageWithURL:(NSURL *)url pageNumber:(NSUInteger)pageNumber rect:(CGRect)rect error:(NSError **)error;

/// 获取视频指定时间图片
/// @param currentTime 指定时间
/// @param path 视频URL
+ (UIImage*)getVideoImageWithTime:(Float64)currentTime videoPath:(NSURL*)path;

/// 获取视频指定时间图片
/// @param path 视频URL
/// @param size 图片大小
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;

/// 获取pdf相对应的所有页面图片
/// @param url pdf文件链接
/// @param rect rect
/// @param error 错误
+ (NSArray<UIImage *> *)getPDFImageWithURL:(NSURL *)url rect:(CGRect)rect error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
