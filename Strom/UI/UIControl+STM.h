//
//  UIControl+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/2/25.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^STMControlHandler)(__kindof UIControl *sender);

@interface UIControl (STM)

- (void)stm_addEventHandlerForControlEvents:(UIControlEvents)controlEvents :(STMControlHandler)handler;
- (void)stm_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents;
- (BOOL)stm_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents;

@end

NS_ASSUME_NONNULL_END
