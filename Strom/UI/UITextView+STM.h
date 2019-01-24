//
//  UITextView+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/1/24.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, STMTextViewInputLenthLimitType) {
  STMTextViewInputLenthLimitTypeCharacter,
  STMTextViewInputLenthLimitTypeByte
};

IB_DESIGNABLE
@interface UITextView (STM)

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger limitType;
#else
@property (nonatomic, assign) STMTextViewInputLenthLimitType limitType;
#endif

/**
 0 means no limit. default is 0
 */
@property (nonatomic, assign) IBInspectable NSUInteger limitLength;

@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

+ (UIColor *)defaultPlaceholderColor;

@end

NS_ASSUME_NONNULL_END
