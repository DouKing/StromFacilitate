//
//  UITextField+STM.h
//  StromFacilitate
//
//  Created by WuYikai on 2017/6/30.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, STMTextFieldInputLenthLimitType) {
  STMTextFieldInputLenthLimitTypeCharacter,
  STMTextFieldInputLenthLimitTypeByte
};

IB_DESIGNABLE
@interface UITextField (STM)

@property (nonatomic, assign) STMTextFieldInputLenthLimitType limitType;

/**
 0 means no limit. default is 0
 */
@property (nonatomic, assign) IBInspectable NSUInteger limitLength;

@end


NS_ASSUME_NONNULL_END
