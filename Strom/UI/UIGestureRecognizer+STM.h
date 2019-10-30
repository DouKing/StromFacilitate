//
//  UIGestureRecognizer+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/10/29.
//  Copyright © 2019 secoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^STMGestureRecognizerHandler)(__kindof UIGestureRecognizer *sender);

@interface UIGestureRecognizer (STM)

- (instancetype)stm_initWithHandler:(STMGestureRecognizerHandler)handler;

- (NSUInteger)stm_addHandler:(STMGestureRecognizerHandler)handler;
- (void)stm_removeHandlerWithIdentifier:(NSUInteger)identifier;
- (void)stm_removeInitialHandler;
- (void)stm_removeAllHandlers;

@end

NS_ASSUME_NONNULL_END
