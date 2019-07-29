//
//  UIApplication+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2018/11/20.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (STM)

- (__kindof UIViewController *)stm_topViewController;

/// 打开设置页
- (void)stm_openSettingNotificationWithCompletionHandler:(void (^ __nullable)(BOOL success))completion NS_EXTENSION_UNAVAILABLE_IOS("");

/// 打开app在appStore的主页面
- (void)stm_openAppStoreWithAppId:(NSString *)appId completionHandler:(void (^ __nullable)(BOOL success))completion NS_EXTENSION_UNAVAILABLE_IOS("");

/// 打开app在appStore的评价页面
- (void)stm_openAppStoreReviewsWithAppId:(NSString *)appId completionHandler:(void (^ __nullable)(BOOL success))completion NS_EXTENSION_UNAVAILABLE_IOS("");

/// 打电话
- (void)stm_telTo:(NSString *)phoneNumber completionHandler:(void (^ __nullable)(BOOL success))completion NS_EXTENSION_UNAVAILABLE_IOS("");

- (void)stm_openURL:(NSString *)URLString completionHandler:(void (^ __nullable)(BOOL success))completion NS_EXTENSION_UNAVAILABLE_IOS("");

///状态栏背景色
@property (nullable, nonatomic, strong) UIColor *stm_statusBarColor;

@end

NS_ASSUME_NONNULL_END
