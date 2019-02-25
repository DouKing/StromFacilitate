//
//  UIBarButtonItem+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/2/25.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (STM)

- (instancetype)initWithImage:(nullable UIImage *)image
                        style:(UIBarButtonItemStyle)style
                      handler:(nullable void(^)(UIBarButtonItem *barButtonItem))handler;

- (instancetype)initWithTitle:(nullable NSString *)title
                        style:(UIBarButtonItemStyle)style
                      handler:(nullable void(^)(UIBarButtonItem *barButtonItem))handler;

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                                    handler:(nullable void(^)(UIBarButtonItem *barButtonItem))handler;

@property (nullable, nonatomic, copy) void(^handler)(UIBarButtonItem *barButtonItem);

@end

NS_ASSUME_NONNULL_END
