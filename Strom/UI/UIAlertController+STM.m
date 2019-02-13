//
//  UIAlertController+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2019/2/12.
//  Copyright © 2019 secoo. All rights reserved.
//

#import "UIAlertController+STM.h"
#import <objc/runtime.h>

static NSString * const kSTMAlertActionTitleTextColorKey = @"titleTextColor";
static NSString * const kSTMAlertActionTitleTextAligmentKey = @"titleTextAlignment";
static NSString * const kSTMAlertActionImageKey = @"image";
static NSString * const kSTMAlertActionImageTintColorKey = @"imageTintColor";

@implementation UIAlertAction (STM)

+ (instancetype)stm_actionWithTitle:(NSString *)title image:(UIImage *)image style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction * _Nonnull))handler {
  UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
  action.stm_image = image;
  return action;
}

- (void)setStm_titleTextColor:(UIColor *)stm_titleTextColor {
  [self setValue:stm_titleTextColor forKey:kSTMAlertActionTitleTextColorKey];
}

- (UIColor *)stm_titleTextColor {
  return [self valueForKey:kSTMAlertActionTitleTextColorKey];
}

- (void)setStm_titleTextAlignment:(NSTextAlignment)stm_titleTextAlignment {
  [self setValue:@(stm_titleTextAlignment) forKey:kSTMAlertActionTitleTextAligmentKey];
}

- (NSTextAlignment)stm_titleTextAlignment {
  return [[self valueForKey:kSTMAlertActionTitleTextAligmentKey] integerValue];
}

- (void)setStm_image:(UIImage *)stm_image {
  [self setValue:stm_image forKey:kSTMAlertActionImageKey];
}

- (UIImage *)stm_image {
  return [self valueForKey:kSTMAlertActionImageKey];
}

- (void)setStm_imageTintColor:(UIColor *)stm_imageTintColor {
  [self setValue:stm_imageTintColor forKey:kSTMAlertActionImageTintColorKey];
}

- (UIColor *)stm_imageTintColor {
  return [self valueForKey:kSTMAlertActionImageTintColorKey];
}

@end


static NSString * const kSTMAlertControllerAttributedTitleKey = @"attributedTitle";
static NSString * const kSTMAlertControllerAttributedMessageKey = @"attributedMessage";
static NSString * const kSTMAlertControllerContentViewControllerKey = @"contentViewController";

@implementation UIAlertController (STM)

+ (instancetype)stm_alertControllerWithAttributedTitle:(NSAttributedString *)attributedTitle attributedMessage:(NSAttributedString *)attributedMessage preferredStyle:(UIAlertControllerStyle)preferredStyle {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:preferredStyle];
  alert.stm_attributedTitle = attributedTitle;
  alert.stm_attributedMessage = attributedMessage;
  return alert;
}

- (void)stm_setTitleFont:(UIFont *)font color:(UIColor *)color {
  if (!self.title) { return; }
  NSAssert(font != nil && color != nil, @"");
  NSDictionary *attributes = @{
                               NSFontAttributeName: font,
                               NSForegroundColorAttributeName: color,
                               };
  self.stm_attributedTitle = [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
}

- (void)stm_setMessageFont:(UIFont *)font color:(UIColor *)color {
  NSAssert(font != nil && color != nil, @"");
  NSDictionary *attributes = @{
                               NSFontAttributeName: font,
                               NSForegroundColorAttributeName: color,
                               };
  self.stm_attributedMessage = [[NSAttributedString alloc] initWithString:self.message attributes:attributes];
}

- (void)stm_addDefaultStyleActionsWithTitles:(NSArray<NSString *> *)titles handler:(void (^)(UIAlertAction * _Nonnull, NSInteger))handler {
  NSInteger i = 0;
  for (NSString *title in titles) {
    NSInteger index = i;
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      if (handler) {
        handler(action, index);
      }
    }];
    [self addAction:action];
    i++;
  }
}

- (void)stm_addActionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(UIAlertAction * _Nonnull))handler {
  UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:handler];
  [self addAction:action];
}

- (void)setStm_attributedTitle:(NSAttributedString *)stm_attributedTitle {
  [self setValue:stm_attributedTitle forKey:kSTMAlertControllerAttributedTitleKey];
}

- (NSAttributedString *)stm_attributedTitle {
  return [self valueForKey:kSTMAlertControllerAttributedTitleKey];
}

- (void)setStm_attributedMessage:(NSAttributedString *)stm_attributedMessage {
  [self setValue:stm_attributedMessage forKey:kSTMAlertControllerAttributedMessageKey];
}

- (NSAttributedString *)stm_attributedMessage {
  return [self valueForKey:kSTMAlertControllerAttributedMessageKey];
}

- (void)setStm_contentViewController:(UIViewController *)stm_contentViewController {
  [self setValue:stm_contentViewController forKey:kSTMAlertControllerContentViewControllerKey];
}

- (UIViewController *)stm_contentViewController {
  return [self valueForKey:kSTMAlertControllerContentViewControllerKey];
}

@end
