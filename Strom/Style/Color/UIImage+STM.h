//
//  UIImage+STM.h
//  StromFacilitate
//
//  Created by iosci on 2017/3/7.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIImage (STM)

/**
 改变图片颜色，不保留灰度信息，只保留透明度信息

 @param tintColor 将图片改变为该色
 @return 改变后的图片
 */
- (UIImage *)stm_imageWithTintColor:(nullable UIColor *)tintColor;

/**
 改变图片颜色，保留灰度信息和透明度信息

 @param tintColor 将图片改变为该色
 @return 改变后的图片
 */
- (UIImage *)stm_imageWithGradientTintColor:(nullable UIColor *)tintColor;

- (UIImage *)stm_imageWithTintColor:(nullable UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end


NS_ASSUME_NONNULL_END
