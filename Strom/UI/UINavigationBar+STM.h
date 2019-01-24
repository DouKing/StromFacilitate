//
//  UINavigationBar+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2018/10/12.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (STM)
@property (nonatomic, assign, getter=stm_isHideBottomLine) BOOL stm_hideBottomLine;
@end

NS_ASSUME_NONNULL_END
