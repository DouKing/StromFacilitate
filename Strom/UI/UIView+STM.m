//
// StromFacilitate
// UIView+STM.m
// Created by DouKing (https://github.com/DouKing) on 2017/12/27.
// Copyright © 2017年 secoo. All rights reserved.

#import "UIView+STM.h"
#import "STMObjectRuntime.h"
#import "UIImage+STM.h"

@interface UIView ()

@property (nonatomic, strong) UIImageView *cornerImageView;

@end

@implementation UIView (STM)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL systemSel = @selector(layoutSubviews);
    SEL swizzSel = @selector(stm_layoutSubviews);
    STMSwizzMethod(self, systemSel, swizzSel);
  });
}

- (void)stm_layoutSubviews {
  [self stm_layoutSubviews];
  self.cornerImageView.frame = self.bounds;
  [self bringSubviewToFront:self.cornerImageView];
}

#pragma mark - snapshot

- (UIImage *)stm_snapshotImage {
  @autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
  }
}

- (UIView *)stm_snapshotView {
  UIView *snapshot = [self snapshotViewAfterScreenUpdates:NO];
  if (!snapshot) {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.image = [self stm_snapshotImage];
    snapshot = imageView;
  }
  return snapshot;
}

#pragma mark -

- (void)stm_drawCornerRadius:(CGFloat)radius {
  [self stm_drawCornerRadius:radius fillColor:[UIColor whiteColor]];
}

- (void)stm_drawCornerRadius:(CGFloat)radius fillColor:(UIColor *)color {
  [self stm_drawCornerRadius:radius rectSize:self.bounds.size fillColor:color];
}

- (void)stm_drawCornerRadius:(CGFloat)radius rectSize:(CGSize)size fillColor:(UIColor *)color {
  UIImage *image = [self _drawCornerRadius:radius rectSize:size fillColor:color];
  if (!image) { return; }
  if (!self.cornerImageView) {
    self.cornerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cornerImageView];
  }
  self.cornerImageView.image = image;
}

- (UIImage *)_drawCornerRadius:(CGFloat)radius rectSize:(CGSize)size fillColor:(UIColor *)color {
  if (size.width < 1 && size.height < 1) { return nil; }
  @autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGPoint hLeftUpPoint = CGPointMake(radius, 0);
    CGPoint hRightUpPoint = CGPointMake(size.width - radius, 0);
    CGPoint hLeftDownPoint = CGPointMake(radius, size.height);
    CGPoint vLeftUpPoint = CGPointMake(0, radius);
    CGPoint vRightDownPoint = CGPointMake(size.width, size.height - radius);
    CGPoint centerLeftUp = CGPointMake(radius, radius);
    CGPoint centerRightUp = CGPointMake(size.width - radius, radius);
    CGPoint centerLeftDown = CGPointMake(radius, size.height - radius);
    CGPoint centerRightDown = CGPointMake(size.width - radius, size.height - radius);

    UIBezierPath *path = [UIBezierPath bezierPath];

    [path moveToPoint:hLeftUpPoint];
    [path addLineToPoint:hRightUpPoint];
    [path addArcWithCenter:centerRightUp radius:radius startAngle:M_PI * 3 / 2 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:vRightDownPoint];
    [path addArcWithCenter:centerRightDown radius:radius startAngle:0 endAngle:M_PI / 2 clockwise:YES];
    [path addLineToPoint:hLeftDownPoint];
    [path addArcWithCenter:centerLeftDown radius:radius startAngle:M_PI / 2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:vLeftUpPoint];
    [path addArcWithCenter:centerLeftUp radius:radius startAngle:M_PI endAngle:M_PI * 3 / 2 clockwise:YES];
    [path addLineToPoint:hLeftUpPoint];
    [path closePath];

    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(0, size.height)];
    [path addLineToPoint:CGPointMake(size.width, size.height)];
    [path addLineToPoint:CGPointMake(size.width, 0)];
    [path addLineToPoint:CGPointZero];
    [path closePath];

    [color setFill];
    [path fill];

    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
  }
}

#pragma mark - setter & getter

- (UIImageView *)cornerImageView {
  return objc_getAssociatedObject(self, _cmd);
}

- (void)setCornerImageView:(UIImageView *)cornerImageView {
  if (cornerImageView == self.cornerImageView) { return; }
  objc_setAssociatedObject(self, @selector(cornerImageView), cornerImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
