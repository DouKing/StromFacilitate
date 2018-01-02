//
// StromFacilitate
// UIView+STM.h
// Created by DouKing (https://github.com/DouKing) on 2017/12/27.
// Copyright © 2017年 secoo. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView (STM)

- (UIImage *)stm_snapshotImage;
- (UIView *)stm_snapshotView;

- (void)stm_drawCornerRadius:(CGFloat)radius;
- (void)stm_drawCornerRadius:(CGFloat)radius fillColor:(UIColor *)color;
- (void)stm_drawCornerRadius:(CGFloat)radius rectSize:(CGSize)size fillColor:(UIColor *)color;

@end
