//
//  NSLayoutConstraint+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2018/7/27.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface NSLayoutConstraint (STM)

@property (nonatomic, assign) IBInspectable CGFloat pixel;

@end

NS_ASSUME_NONNULL_END
