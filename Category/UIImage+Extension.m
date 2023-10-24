//
//  UIImage+Extension.m
//  PublishMoments-demo
//
//  Created by 李亚川 on 2020/4/27.
//  Copyright © 2020 tianjiu. All rights reserved.
//

#import "UIImage+Extension.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Extension)

/// 修正图片转向
/// @param aImage 原图片
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/// 压缩到固定宽度
/// @param sourceImage 原图片
/// @param defineWidth 宽度
+ (UIImage *)compressSourceImage:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    // UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if (!newImage) {
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

/// 压缩到固定宽度
/// @param width 宽度
- (UIImage *)compressOriginalToMaxDataWidth:(CGFloat)width
{
    float imageWidth = self.size.width;
    float imageHeight = self.size.height;
    
    if (imageWidth > width) {
        
        float height = self.size.height/(self.size.width/width);
        
        float widthScale = imageWidth /width;
        float heightScale = imageHeight /height;
        
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
        
        if (widthScale > heightScale) {
            [self drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
        }
        else {
            [self drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
        }
        
        // 从当前context中创建一个改变大小后的图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();

        return newImage;
    }
    
    return self;
    
    
//
//    NSData * data = UIImageJPEGRepresentation(self, 1.0);
//    CGFloat dataKBytes = data.length/1000.0;
//    CGFloat maxQuality = 0.5f;
//    CGFloat lastData = dataKBytes;
//    while (dataKBytes > size && maxQuality > 0.01f) {
//        maxQuality = maxQuality - 0.01f;
//        data = UIImageJPEGRepresentation(self, maxQuality);
//        dataKBytes = data.length / 1000.0;
//        if (lastData == dataKBytes) {
//            break;
//        }else{
//            lastData = dataKBytes;
//        }
//    }
//
//    UIImage *image = [UIImage imageWithData: data];
//    return image;
}

/*!
 *  @brief 使图片压缩后刚好小于指定大小
 *
 *  @param image 当前要压缩的图 maxLength 压缩后的大小
 *
 *  @return 图片对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
+ (NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    data = UIImageJPEGRepresentation(resultImage, compression);
    if (data.length < maxLength) return data;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return data;
}

/// 创建一个拉伸不变形的图片
/// @param name 图片名称
+ (instancetype)resizableImageNamed:(NSString *)name
{
    UIImage *img = [UIImage imageNamed:name];
    
    CGFloat left = img.size.height / 2;
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(0, left, 0, left) resizingMode:UIImageResizingModeTile];
    return img;
    //    return [self resizableImageNamed:name left:0.5 top:0.5];
}

/// 创建一个内容可拉伸，而边角不拉伸的图片
/// @param name 图片名称
/// @param left 左边不拉伸区域的宽度
/// @param top 上面不拉伸的高度
+ (instancetype)resizableImageNamed:(NSString *)name left:(CGFloat)leftRatio top:(CGFloat)topRatio
{
    UIImage *image = [UIImage imageNamed:name];
    CGFloat left = image.size.width * leftRatio;
    CGFloat top = image.size.height * topRatio;
    return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
}

#pragma mark - 图片毛玻璃处理
/// 把image截图，并生成一张毛玻璃图片
/// @param image 要截图的image
/// @param blur 模糊数
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    if (inBitmapData) {
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    }
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    if (inBitmapData) {
        CFRelease(inBitmapData);
    }
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
    
}

/// 把view截图，并生成一张毛玻璃图片
/// @param view 要截图的view
/// @param blur 模糊数
+ (UIImage *)boxblurImageFromView:(UIView *)view withBlurNumber:(CGFloat)blur
{
    UIImage *img = nil;
    if ([view isKindOfClass:WKWebView.class]) {
        
        if (@available(iOS 11.0, *)) {
            img = [self imageForWebView:(WKWebView *)view];
        } else {
            WKWebView *webView = (WKWebView *)view;
            img = [self doScreenShotWithWebView:webView];
        }
    }else{
        img = [self imagePNGFromView:view];
    }
    
    UIImage *newImg = [self boxblurImage:img withBlurNumber:blur];
    
    return newImg;
}

/// 截取一张透明图片
/// @param view 要截图的view
+ (UIImage *)imagePNGFromView:(UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    return [UIImage imageWithData:imageData];
}
/// 获取截屏，所有window的截屏
+ (UIImage *)imageDataScreenShot
{
    CGSize imageSize = CGSizeZero;
    imageSize = [UIScreen mainScreen].bounds.size;

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        [[UIColor clearColor] setFill];
        [[UIBezierPath bezierPathWithRect:window.bounds] fill];
        CGContextRestoreGState(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
//    UIWindow * window = UIApplication.sharedApplication.delegate.window;
//    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:window.frame.size];
//    UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
//        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
//    }];
    return image;
}

#pragma mark - 根据指定的范围剪切图片中的一部分
/** rect：需要剪切的位置*/
- (UIImage *)cutImageWithRect:(CGRect)rect
{
    if (rect.size.width <= 0 || rect.size.height <= 0) {
        return nil;
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    // 开启图形上下文
    UIGraphicsBeginImageContext(smallRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallRect, subImageRef);
    UIImage * image = [UIImage imageWithCGImage:subImageRef];
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    CGImageRelease(subImageRef);
    
    return image;
}

/// 从网页上截取一张透明图片，适用于iOS11及之后
/// @param webView 要截取的webView
+ (UIImage *)imageForWebView:(WKWebView *)webView
{
    // 1.获取WebView的宽高
    CGSize boundsSize = webView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    // 2.获取contentSize
    CGSize contentSize = webView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    // 3.保存原始偏移量，便于截图后复位
    CGPoint offset = webView.scrollView.contentOffset;
    // 4.设置最初的偏移量为(0,0);
    [webView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0 && contentSize.width > 0) {
        // 5.获取CGContext 5.获取CGContext
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 6.渲染要截取的区域
        [webView.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 7.截取的图片保存起来
        [images addObject:image];
        
        CGFloat offsetY = webView.scrollView.contentOffset.y;
        [webView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    // 8 webView 恢复到之前的显示区域
    [webView.scrollView setContentOffset:offset];
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    // 9.根据设备的分辨率重新绘制、拼接成完整清晰图片
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,
                                     scale * boundsHeight * idx,
                                     scale * boundsWidth,
                                     scale * boundsHeight)];
    }];
    
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return fullImage;
}

/** 从网页上截取一张透明图片，适用于iOS11之前 */
+ (UIImage*)doScreenShotWithWebView:(WKWebView *)webView
{
    UIImage* image = nil;
    //优化图片截取不清晰
    UIGraphicsBeginImageContextWithOptions(webView.scrollView.contentSize, true, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = webView.scrollView.contentOffset;
        CGRect savedFrame = webView.scrollView.frame;
        webView.scrollView.contentOffset = CGPointZero;
        webView.scrollView.frame = CGRectMake(0, 0, webView.scrollView.contentSize.width, webView.scrollView.contentSize.height);
        for (UIView * subView in webView.subviews) {
//            [subView drawViewHierarchyInRect:subView.bounds afterScreenUpdates:YES];
            [subView drawViewHierarchyInRect:subView.bounds afterScreenUpdates:NO];
        }
        image = UIGraphicsGetImageFromCurrentImageContext();
        webView.scrollView.contentOffset = savedContentOffset;
        webView.scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }
    return nil;
}

//+ (UIImage *)doScreenShotWithScrollView:(UIScrollView *)scrollView withSize:(CGSize)size
//{
//    UIImage* image;
//
//    UIGraphicsBeginImageContextWithOptions(size.width==0?scrollView.contentSize:size, NO, [UIScreen mainScreen].scale);
//    {
//        CGPoint savedContentOffset = scrollView.contentOffset;
//        CGRect savedFrame = scrollView.frame;
//        scrollView.contentOffset = CGPointZero;
//        scrollView.frame = size.width==0? CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height):CGRectMake(0, 0, size.width, size.height);
//        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        scrollView.contentOffset = savedContentOffset;
//        scrollView.frame = savedFrame;
//    }
//    UIGraphicsEndImageContext();
//
//    if (image != nil)
//    {
//        return image;
//    }
//    return nil;
//}


//+ (void)WKWebViewScroll:(WKWebView *)webView CaptureCompletionHandler:(void(^)(UIImage *capturedImage))completionHandler {
//
//    // 制作了一个UIView的副本
//    UIView *snapShotView = [webView snapshotViewAfterScreenUpdates:YES];
//
//    snapShotView.frame = CGRectMake(webView.frame.origin.x, webView.frame.origin.y, snapShotView.frame.size.width, snapShotView.frame.size.height);
//
//    [webView.superview addSubview:snapShotView];
//
//    // 获取当前UIView可滚动的内容长度
//    CGPoint scrollOffset = webView.scrollView.contentOffset;
//
//    // 向上取整数 － 可滚动长度与UIView本身屏幕边界坐标相差倍数
//    float maxIndex = ceilf(webView.scrollView.contentSize.height/webView.bounds.size.height);
//
//    // 保持清晰度
//    UIGraphicsBeginImageContextWithOptions(webView.scrollView.contentSize, false, [UIScreen mainScreen].scale);
//
//    NSLog(@"--index--%d", (int)maxIndex);
//
//    // 滚动截图
//    [self ZTContentScroll:webView PageDraw:0 maxIndex:(int)maxIndex drawCallback:^{
//        UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//
//        // 恢复原UIView
//        [webView.scrollView setContentOffset:scrollOffset animated:NO];
//        [snapShotView removeFromSuperview];
//
//        //        UIImage *resultImg = [UIImage imageWithData:UIImageJPEGRepresentation(capturedImage, 0.5)];
//
////        completionHandler(capturedImage);
//
//        UIImage *newImg = [self boxblurImage:capturedImage withBlurNumber:0.8];
//
//        completionHandler(newImg);
//
//    }];
//}
//
//// 滚动截图
//+ (void)ZTContentScroll:(WKWebView *)webView PageDraw:(int)index maxIndex:(int)maxIndex drawCallback:(void(^)(void))drawCallback{
//    [webView.scrollView setContentOffset:CGPointMake(0, (float)index * webView.frame.size.height)];
//    CGRect splitFrame = CGRectMake(0, (float)index * webView.frame.size.height, webView.bounds.size.width, webView.bounds.size.height);
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [webView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
//        if(index < maxIndex){
//            [self ZTContentScroll:webView PageDraw: index + 1 maxIndex:maxIndex drawCallback:drawCallback];
//        }else{
//            drawCallback();
//        }
//    });
//}

+ (CIImage *)creatQRcodeWithUrlstring:(NSString *)urlString{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return outputImage;
}

/// 生成二维码图片
+ (UIImage *)createQRImageWithUrl:(NSString *)urlString size:(CGFloat)size
{
    CIImage *image = [self creatQRcodeWithUrlstring:urlString];
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (UIImage*)circleImage {
    UIGraphicsBeginImageContextWithOptions(self.size,NO, 0.0);
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    CGRect rect =CGRectMake(0, 0,self.size.width,self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    [self drawInRect:rect];
    UIImage*image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;

}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
      
    return img;
}

/// 从指定bundle里面获取图片
/// @param name 图片名称
/// @param bundleName bundleName
+ (UIImage *)imageNamed:(NSString *)name ofBundle:(NSString *)bundleName {
    
    UIImage *image = nil;
    NSString *image_name = name;
    
    if (![name containsString:@".png"]) {
        image_name = [NSString stringWithFormat:@"%@.png", name];
    }
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];;
    
    image = [[UIImage alloc] initWithContentsOfFile:image_path];
    
    return image;
    
}

@end
