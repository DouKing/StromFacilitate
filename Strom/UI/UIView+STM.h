//
// StromFacilitate
// UIView+STM.h
// Created by DouKing (https://github.com/DouKing) on 2017/12/27.
// Copyright © 2017年 DouKing. All rights reserved.

#import <UIKit/UIKit.h>
#import "UIGestureRecognizer+STM.h"

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface UIView (STM)

- (nullable UIImage *)stm_snapshotImage;
- (UIView *)stm_snapshotView;

- (nullable UIImage *)stm_drawCornerRadii:(CGSize)radii;
- (nullable UIImage *)stm_drawCornerRadii:(CGSize)radii fillColor:(UIColor *)color;
- (nullable UIImage *)stm_drawCornerRadii:(CGSize)radii byRoundingCorners:(UIRectCorner)corners;
- (nullable UIImage *)stm_drawCornerRadii:(CGSize)radii
                        byRoundingCorners:(UIRectCorner)corners
                                 rectSize:(CGSize)size
                                fillColor:(UIColor *)color;

- (void)stm_addTapGestureRecognizer:(void(^ _Nullable)(UITapGestureRecognizer *gestureRecognizer))configure
                      actionHandler:(void(^)(UITapGestureRecognizer *gestureRecognizer))handler;
- (void)stm_addTapGestureRecognizerWithActionHandler:(void(^)(UITapGestureRecognizer *gestureRecognizer))handler;

- (void)stm_addLongPressGestureRecognizer:(void(^ _Nullable)(UILongPressGestureRecognizer *gestureRecognizer))configure
                            actionHandler:(void(^)(UILongPressGestureRecognizer *gestureRecognizer))handler;
- (void)stm_addLongPressGestureRecognizerWithActionHandler:(void(^)(UILongPressGestureRecognizer *gestureRecognizer))handler;

#pragma mark -

+ (instancetype)stm_viewFromNib;
+ (instancetype)stm_viewFromNibWithOwner:(nullable id)ownerOrNil options:(nullable NSDictionary *)optionsOrNil;

@property (nullable, nonatomic, strong)IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
