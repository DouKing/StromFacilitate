//
//  UIImage+STM.m
//  StromFacilitate
//
//  Created by iosci on 2017/3/7.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "UIImage+STM.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (STM)

+ (UIImage *)stm_imageWithColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha {
  @autoreleasepool {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, alpha);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
  }
}

+ (UIImage *)stm_imageWithColor:(UIColor *)color size:(CGSize)size {
  return [self stm_imageWithColor:color size:size alpha:1];
}

- (UIImage *)stm_imageWithTintColor:(UIColor *)tintColor {
  return [self stm_imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)stm_imageWithGradientTintColor:(UIColor *)tintColor {
  return [self stm_imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *)stm_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
  //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  [tintColor setFill];
  CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
  UIRectFill(bounds);
  
  //Draw the tinted image in context
  [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
  
  //保留透明度
  if (blendMode != kCGBlendModeDestinationIn) {
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
  }
  
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return tintedImage;
}

- (UIImage *)stm_addCornerRadius:(CGFloat)radius withSize:(CGSize)size {
  return [self stm_addCornerRadii:CGSizeMake(radius, radius) byRoundingCorners:UIRectCornerAllCorners withSize:size];
}

- (UIImage *)stm_addCornerRadii:(CGSize)radii byRoundingCorners:(UIRectCorner)corners withSize:(CGSize)size {
  @autoreleasepool {
    CGRect rect = (CGRect){CGPointZero, size};
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    [self drawInRect:rect];
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
  }
}

- (UIImage *)stm_blurredImageWithRadius:(CGFloat)radius {
  UIImage *inputImage = self;
  CGImageRef imageRef = inputImage.CGImage;
  CGFloat imageScale = inputImage.scale;
  UIImageOrientation imageOrientation = inputImage.imageOrientation;

  // Image must be nonzero size
  if (CGImageGetWidth(imageRef) * CGImageGetHeight(imageRef) == 0) {
    return inputImage;
  }

  //convert to ARGB if it isn't
  if (CGImageGetBitsPerPixel(imageRef) != 32 ||
      CGImageGetBitsPerComponent(imageRef) != 8 ||
      !((CGImageGetBitmapInfo(imageRef) & kCGBitmapAlphaInfoMask))) {
    UIGraphicsBeginImageContextWithOptions(inputImage.size, NO, inputImage.scale);
    [inputImage drawAtPoint:CGPointZero];
    imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
    UIGraphicsEndImageContext();
  }

  vImage_Buffer buffer1, buffer2;
  buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
  buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
  buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
  size_t bytes = buffer1.rowBytes * buffer1.height;
  buffer1.data = malloc(bytes);
  buffer2.data = malloc(bytes);

  // A description of how to compute the box kernel width from the Gaussian
  // radius (aka standard deviation) appears in the SVG spec:
  // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
  uint32_t boxSize = floor((radius * imageScale * 3 * sqrt(2 * M_PI) / 4 + 0.5) / 2);
  boxSize |= 1; // Ensure boxSize is odd

  //create temp buffer
  void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                               NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));

  //copy image data
  CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
  memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
  CFRelease(dataSource);

  //perform blur
  vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
  vImageBoxConvolve_ARGB8888(&buffer2, &buffer1, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
  vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

  //free buffers
  free(buffer2.data);
  free(tempBuffer);

  //create image context from buffer
  CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                           8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                           CGImageGetBitmapInfo(imageRef));

  //create image from context
  imageRef = CGBitmapContextCreateImage(ctx);
  UIImage *outputImage = [UIImage imageWithCGImage:imageRef scale:imageScale orientation:imageOrientation];
  CGImageRelease(imageRef);
  CGContextRelease(ctx);
  free(buffer1.data);
  return outputImage;
}

@end
