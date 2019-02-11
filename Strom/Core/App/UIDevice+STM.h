//
//  UIDevice+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2018/11/20.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (STM)

- (NSString *)stm_platform;
- (NSString *)stm_hwmodel;
- (NSString *)stm_macString;
- (NSString *)stm_idfaString;
- (NSString *)stm_idfvString;

@end

NS_ASSUME_NONNULL_END
