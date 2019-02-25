//
//  UIViewController+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/2/25.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (STM)

@property (nullable, nonatomic, copy) void(^stm_closeHandler)(UIViewController *closedViewController);

@end

NS_ASSUME_NONNULL_END
