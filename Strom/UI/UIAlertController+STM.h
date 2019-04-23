//
//  UIAlertController+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/2/12.
//  Copyright © 2019 douking. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (STM)

@property (nullable, nonatomic, strong) UIImage *stm_image;
@property (nullable, nonatomic, strong) UIColor *stm_imageTintColor;
@property (nullable, nonatomic, strong) UIColor *stm_titleTextColor;
@property (nonatomic, assign) NSTextAlignment stm_titleTextAlignment;

+ (instancetype)stm_actionWithTitle:(nullable NSString *)title
                              image:(nullable UIImage *)image
                              style:(UIAlertActionStyle)style
                            handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end


@interface UIAlertController (STM)

@property (nullable, nonatomic, strong) NSAttributedString *stm_attributedTitle;
@property (nullable, nonatomic, strong) NSAttributedString *stm_attributedMessage;
@property (nullable, nonatomic, strong) UIViewController *stm_contentViewController;

+ (instancetype)stm_alertControllerWithAttributedTitle:(nullable NSAttributedString *)attributedTitle
                                     attributedMessage:(nullable NSAttributedString *)attributedMessage
                                        preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (void)stm_setTitleFont:(UIFont *)font color:(UIColor *)color;
- (void)stm_setMessageFont:(UIFont *)font color:(UIColor *)color;

- (void)stm_addDefaultStyleActionsWithTitles:(NSArray<NSString *> *)titles
                                     handler:(void (^ __nullable)(UIAlertAction *action, NSInteger index))handler;
- (void)stm_addActionWithTitle:(nullable NSString *)title
                         style:(UIAlertActionStyle)style
                       handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
