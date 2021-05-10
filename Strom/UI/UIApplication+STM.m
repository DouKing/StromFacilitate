//
//  UIApplication+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2018/11/20.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import "UIApplication+STM.h"
#import <objc/message.h>

@implementation UIApplication (STM)

- (UIViewController *)stm_topViewController {
  UIViewController *rootVC = self.keyWindow.rootViewController;
  return [self _stm_topViewControllerOnViewController:rootVC];
}

- (void)stm_openSettingNotificationWithCompletionHandler:(void (^)(BOOL))completion {
  [self stm_openURL:UIApplicationOpenSettingsURLString completionHandler:completion];
}

- (void)stm_openAppStoreWithAppId:(NSString *)appId completionHandler:(void (^ _Nullable)(BOOL))completion {
  NSString *appStoreString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
  [self stm_openURL:appStoreString completionHandler:completion];
}

- (void)stm_openAppStoreReviewsWithAppId:(NSString *)appId completionHandler:(void (^ _Nullable)(BOOL))completion {
  NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
  [self stm_openURL:str completionHandler:completion];
}

- (void)stm_telTo:(NSString *)phoneNumber completionHandler:(void (^ _Nullable)(BOOL))completion {
  phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *str = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self stm_openURL:str completionHandler:completion];
  });
}

- (void)stm_openURL:(NSString *)URLString completionHandler:(void (^)(BOOL success))completion {
  NSURL *URL = [NSURL URLWithString:URLString];
  void(^handler)(BOOL succeed) = ^(BOOL succeed) {
    if (!completion) { return; }
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(succeed);
    });
  };
  if (URL && [self canOpenURL:URL]) {
    if (@available(iOS 10.0, *)) {
      [self openURL:URL options:@{} completionHandler:handler];
    } else {
      [self openURL:URL];
      if (handler) { handler(YES); }
    }
  } else {
    if (handler) { handler(NO); }
  }
}

- (void)stm_exit {
	SEL suspend = @selector(suspend);
	if ([self respondsToSelector:suspend]) {
		((void (*)(id, SEL))(void *)objc_msgSend)(self, suspend);
		exit(0);
	} else {
		abort();
	}
}

- (__kindof UIViewController *)_stm_topViewControllerOnViewController:(UIViewController *)rootVC {
  if ([rootVC isKindOfClass:UINavigationController.class]) {
    UINavigationController *nav = (UINavigationController *)rootVC;
    return [self _stm_topViewControllerOnViewController:nav.visibleViewController];
  }
  else if ([rootVC isKindOfClass:UITabBarController.class]) {
    UITabBarController *tabBarController = (UITabBarController *)rootVC;
    return [self _stm_topViewControllerOnViewController:tabBarController.selectedViewController];
  }
  else if (rootVC.presentedViewController) {
    return [self _stm_topViewControllerOnViewController:rootVC.presentedViewController];
  }

  return rootVC;
}

- (UIView *)_statusBarView {
  if (@available(iOS 13.0, *)) {
    return nil;
  } else {
    return [[self valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
  }
}

- (void)setStm_statusBarColor:(UIColor *)stm_statusBarColor {
  UIView *statusBar = [self _statusBarView];
  if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
    [statusBar setBackgroundColor:stm_statusBarColor];
  }
}

- (UIColor *)stm_statusBarColor {
  UIView *statusBar = [self _statusBarView];
  if ([statusBar respondsToSelector:@selector(backgroundColor)]) {
    return [statusBar backgroundColor];
  }
  return nil;
}

@end
