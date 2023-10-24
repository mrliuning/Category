//
//  UIImage+Blur.m
//  TojoyCloud
//
//  Created by 李亚川 on 2020/4/28.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UIImage+Blur.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Blur)

/// 高斯模糊
/// @param blur 模糊数
- (UIImage *)boxWithBlurNumber:(CGFloat)blur {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *ciImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:ciImage forKey:kCIInputImageKey];
    //设置模糊程度
    [filter setValue:@(blur) forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:ciImage.extent];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

/// 获取视频第一帧图片
/// @param url 视频链接
/// @param size 图片的尺寸
/// @param error 错误
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:error];
    if (!*error) {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

/// 获取视频指定时间图片
/// @param path 视频URL
/// @param size 图片大小
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

/// 获取视频指定时间图片
/// @param currentTime 指定时间
/// @param path 视频URL
+ (UIImage*)getVideoImageWithTime:(Float64)currentTime videoPath:(NSURL*)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.requestedTimeToleranceAfter = kCMTimeZero;
    assetGen.requestedTimeToleranceBefore = kCMTimeZero;
    assetGen.appliesPreferredTrackTransform = YES;

    CMTime time = CMTimeMakeWithSeconds(currentTime, asset.duration.timescale);
    NSError*error =nil;
    CMTime actualTime;
    
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

/// 获取pdf想对应的y图片
/// @param url pdf文件链接
/// @param pageNumber 页数
/// @param rect rect
/// @param error 错误
+ (UIImage *)getPDFImageWithURL:(NSURL *)url pageNumber:(NSUInteger)pageNumber rect:(CGRect)rect error:(NSError **)error {
    CGPDFDocumentRef pdfDocument = [self createWithURL:url error:error];
    if (*error) {
        return nil;
    }
    size_t pageCount = CGPDFDocumentGetNumberOfPages(pdfDocument);
    if (pageCount < pageNumber) {
        *error = [NSError errorWithDomain:@"pageNumber should less than PDFDocumentGetNumberOfPages" code:1 userInfo:nil];
        return nil;
    }
    UIImage *image = [self pdfToImage:pdfDocument pageNumber:pageNumber rect:rect];
    CGPDFDocumentRelease(pdfDocument);
    return image;
}

+ (CGPDFDocumentRef)createWithURL:(NSURL *)url error:(NSError **)error {
    if (!url) {
        *error = [NSError errorWithDomain:@"url is nil" code:1 userInfo:nil];
        return nil;
    }
    //创建CGPDFDocument对象
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL((CFURLRef)url);
    if (pdfDocument == NULL) {
        *error = [NSError errorWithDomain:@"pdfDocument is nil" code:1 userInfo:nil];
        return nil;
    }
    return pdfDocument;
}

+ (UIImage *)pdfToImage:(CGPDFDocumentRef)pdfDocument pageNumber:(NSUInteger)pageNumber rect:(CGRect)rect {
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocument, pageNumber);
    CGSize imageSize = CGPDFPageGetBoxRect(page, kCGPDFCropBox).size;
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context,CGRectMake(0, 0, imageSize.width, imageSize.height));
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, imageSize.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextScaleCTM(context, 1, 1);
    @try {
        CGContextDrawPDFPage(context, page);
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 获取pdf相对应的所有页面图片
/// @param url pdf文件链接
/// @param rect rect
/// @param error 错误
+ (NSArray<UIImage *> *)getPDFImageWithURL:(NSURL *)url rect:(CGRect)rect error:(NSError **)error {
    CGPDFDocumentRef pdfDocument = [self createWithURL:url error:error];
    if (*error) {
        return nil;
    }

    size_t pageCount = CGPDFDocumentGetNumberOfPages(pdfDocument);
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:pageCount];
    for (size_t pageNumber = 1; pageNumber <= pageCount; pageNumber++) {
        UIImage *image = [self pdfToImage:pdfDocument pageNumber:pageNumber rect:rect];
        if (image) {
            [array addObject:image];
        }
    }
    CGPDFDocumentRelease(pdfDocument);
    return array;
}

@end
