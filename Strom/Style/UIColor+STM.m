//
//  UIColor+STM.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "UIColor+STM.h"

@implementation UIColor (STM)

+ (UIColor *)stm_colorWithRGBValue:(NSInteger)rgb {
  return [self stm_colorWithRGBValue:rgb alpha:1];
}

+ (UIColor *)stm_colorWithRGBValue:(NSInteger)rgb alpha:(CGFloat)alpha {
  return [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16)) / 255.0
                         green:((float)((rgb & 0xFF00) >> 8)) / 255.0
                          blue:((float)(rgb & 0xFF)) / 255.0
                         alpha:alpha];
}

+ (UIColor *)stm_randomColor {
  CGFloat r = arc4random() % 256 / 255.0;
  CGFloat g = arc4random() % 256 / 255.0;
  CGFloat b = arc4random() % 256 / 255.0;
  return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
