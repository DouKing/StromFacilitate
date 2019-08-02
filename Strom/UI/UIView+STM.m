//
// StromFacilitate
// UIView+STM.m
// Created by DouKing (https://github.com/DouKing) on 2017/12/27.
// Copyright © 2017年 DouKing. All rights reserved.

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

- (void)stm_drawCornerRadii:(CGSize)radii {
  [self stm_drawCornerRadii:radii fillColor:[UIColor whiteColor]];
}

- (void)stm_drawCornerRadii:(CGSize)radii fillColor:(UIColor *)color {
  [self stm_drawCornerRadii:radii byRoundingCorners:UIRectCornerAllCorners rectSize:self.bounds.size fillColor:color];
}

- (void)stm_drawCornerRadii:(CGSize)radii byRoundingCorners:(UIRectCorner)corners {
  [self stm_drawCornerRadii:radii byRoundingCorners:corners rectSize:self.bounds.size fillColor:[UIColor whiteColor]];
}

- (void)stm_drawCornerRadii:(CGSize)radii
          byRoundingCorners:(UIRectCorner)corners
                   rectSize:(CGSize)size
                  fillColor:(UIColor *)color {
  UIImage *image = [self _drawCornerRadii:radii byRoundingCorners:corners rectSize:size fillColor:color];
  if (!image) { return; }
  if (!self.cornerImageView) {
    self.cornerImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.cornerImageView];
  }
  self.cornerImageView.image = image;
}

- (UIImage *)_drawCornerRadii:(CGSize)radii
            byRoundingCorners:(UIRectCorner)corners
                     rectSize:(CGSize)size
                    fillColor:(UIColor *)color {
  if (size.width < 1 && size.height < 1) { return nil; }
  @autoreleasepool {
    UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect rect = (CGRect){CGPointZero, size};
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
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


@implementation UIView (Storyboard)

- (void)setBorderColor:(UIColor *)borderColor {
  self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  self.layer.cornerRadius = cornerRadius;
}

- (UIColor *)borderColor {
  if (!self.layer.borderColor) {
    return nil;
  }
  return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (CGFloat)borderWidth {
  return self.layer.borderWidth;
}

- (CGFloat)cornerRadius {
  return self.layer.cornerRadius;
}

@end

@implementation UIView (Nib)

+ (instancetype)stm_viewFromNib {
    return [self stm_viewFromNibWithOwner:nil options:nil];
}

+ (instancetype)stm_viewFromNibWithOwner:(id)ownerOrNil options:(NSDictionary *)optionsOrNil {
    return [[UINib nibWithNibName:NSStringFromClass(self) bundle:nil]
            instantiateWithOwner:ownerOrNil options:optionsOrNil].firstObject;
}

@end
