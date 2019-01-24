//
// StromFacilitate
// UIView+STM.h
// Created by DouKing (https://github.com/DouKing) on 2017/12/27.
// Copyright © 2017年 DouKing. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView (STM)

- (UIImage *)stm_snapshotImage;
- (UIView *)stm_snapshotView;

//- (void)stm_drawCornerRadius:(CGFloat)radius;
//- (void)stm_drawCornerRadius:(CGFloat)radius fillColor:(UIColor *)color;
//- (void)stm_drawCornerRadius:(CGFloat)radius rectSize:(CGSize)size fillColor:(UIColor *)color;

- (void)stm_drawCornerRadii:(CGSize)radii;
- (void)stm_drawCornerRadii:(CGSize)radii fillColor:(UIColor *)color;
- (void)stm_drawCornerRadii:(CGSize)radii byRoundingCorners:(UIRectCorner)corners;

- (void)stm_drawCornerRadii:(CGSize)radii
          byRoundingCorners:(UIRectCorner)corners
                   rectSize:(CGSize)size
                  fillColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_BEGIN


IB_DESIGNABLE
@interface UIView (Storyboard)

@property (nullable, nonatomic, strong)IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end


NS_ASSUME_NONNULL_END
