//
// StromFacilitate
// UIView+STM.m
// Created by DouKing (https://github.com/DouKing) on 2017/12/27.
// Copyright © 2017年 DouKing. All rights reserved.

#import "UIView+STM.h"
#import "STMObjectRuntime.h"

@implementation UIView (STM)

+ (instancetype)stm_viewFromNib {
    return [self stm_viewFromNibWithOwner:nil options:nil];
}

+ (instancetype)stm_viewFromNibWithOwner:(id)ownerOrNil options:(NSDictionary *)optionsOrNil {
    return [[UINib nibWithNibName:NSStringFromClass(self) bundle:nil]
            instantiateWithOwner:ownerOrNil options:optionsOrNil].firstObject;
}

- (NSArray<__kindof UIView *> *)allSubViewsOfType:(Class)aClass {
  NSMutableArray *temp = [NSMutableArray array];
  if ([self isKindOfClass:aClass]) {
    [temp addObject:self];
  }
  for (UIView *subView in self.subviews) {
    [temp addObjectsFromArray:[subView allSubViewsOfType:aClass]];
  }
  return [temp copy];
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

#pragma mark - Draw image

- (UIImage *)stm_drawCornerRadii:(CGSize)radii {
  return [self stm_drawCornerRadii:radii fillColor:[UIColor whiteColor]];
}

- (UIImage *)stm_drawCornerRadii:(CGSize)radii fillColor:(UIColor *)color {
  return [self stm_drawCornerRadii:radii byRoundingCorners:UIRectCornerAllCorners rectSize:self.bounds.size fillColor:color];
}

- (UIImage *)stm_drawCornerRadii:(CGSize)radii byRoundingCorners:(UIRectCorner)corners {
  return [self stm_drawCornerRadii:radii byRoundingCorners:corners rectSize:self.bounds.size fillColor:[UIColor whiteColor]];
}

- (UIImage *)stm_drawCornerRadii:(CGSize)radii
          byRoundingCorners:(UIRectCorner)corners
                   rectSize:(CGSize)size
                  fillColor:(UIColor *)color {
  UIImage *image = [self _drawCornerRadii:radii byRoundingCorners:corners rectSize:size fillColor:color];
  return image;
}

- (void)stm_addTapGestureRecognizer:(void (^)(UITapGestureRecognizer * _Nonnull))configure actionHandler:(void (^)(UITapGestureRecognizer * _Nonnull))handler {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] stm_initWithHandler:^(UITapGestureRecognizer * _Nonnull sender) {
        !handler ?: handler(sender);
    }];
    !configure ?: configure(tap);
    [self addGestureRecognizer:tap];
}

- (void)stm_addTapGestureRecognizerWithActionHandler:(void (^)(UITapGestureRecognizer * _Nonnull))handler {
    [self stm_addTapGestureRecognizer:nil actionHandler:handler];
}

- (void)stm_addLongPressGestureRecognizer:(void (^)(UILongPressGestureRecognizer * _Nonnull))configure actionHandler:(void (^)(UILongPressGestureRecognizer * _Nonnull))handler {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] stm_initWithHandler:^(UILongPressGestureRecognizer * _Nonnull sender) {
        !handler ?: handler(sender);
    }];
    !configure ?: configure(longPress);
    [self addGestureRecognizer:longPress];
}

- (void)stm_addLongPressGestureRecognizerWithActionHandler:(void (^)(UILongPressGestureRecognizer * _Nonnull))handler {
    [self stm_addLongPressGestureRecognizer:nil actionHandler:handler];
}

#pragma mark - Private

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
