//
//  UIColor+STM.h
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#ifndef RGBColor
#define RGBColor(rgb) [UIColor stm_colorWithRGBValue:rgb]
#endif

#ifndef RGBAColor
#define RGBAColor(rgb, a) [UIColor stm_colorWithRGBValue:rgb alpha:a]
#endif

@interface UIColor (STM)

/**
 *  根据RGB返回颜色
 *
 *  @param rgb 16进制数值，如：0xFFFFFF
 *
 *  @return UIColor
 */
+ (UIColor *)stm_colorWithRGBValue:(NSInteger)rgb;

/**
 *  根据RGB和alpha返回颜色
 *
 *  @param rgb   rgb 16进制数值，如：0xFFFFFF
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)stm_colorWithRGBValue:(NSInteger)rgb alpha:(CGFloat)alpha;

/**
 *  随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)stm_randomColor;

@end

NS_ASSUME_NONNULL_END
