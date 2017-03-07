//
//  UIImage+STM.m
//  StromFacilitate
//
//  Created by iosci on 2017/3/7.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "UIImage+STM.h"

@implementation UIImage (STM)

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

@end
