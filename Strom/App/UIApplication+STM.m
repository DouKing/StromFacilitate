//
//  UIApplication+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2018/11/20.
//  Copyright © 2018 secoo. All rights reserved.
//

#import "UIApplication+STM.h"

@implementation UIApplication (STM)

- (void)stm_openSettingNotificationWithCompletionHandler:(void (^)(BOOL))completion {
  [self _stm_openURL:UIApplicationOpenSettingsURLString completionHandler:completion];
}

- (void)stm_openAppStoreWithAppId:(NSString *)appId completionHandler:(void (^ _Nullable)(BOOL))completion {
  NSString *appStoreString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId];
  [self _stm_openURL:appStoreString completionHandler:completion];
}

- (void)stm_openAppStoreReviewsWithAppId:(NSString *)appId completionHandler:(void (^ _Nullable)(BOOL))completion {
  NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
  [self _stm_openURL:str completionHandler:completion];
}

- (void)stm_telTo:(NSString *)phoneNumber completionHandler:(void (^ _Nullable)(BOOL))completion {
  phoneNumber = [phoneNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  NSString *str = [NSString stringWithFormat:@"telprompt://%@", phoneNumber];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self _stm_openURL:str completionHandler:completion];
  });
}

- (void)_stm_openURL:(NSString *)URLString completionHandler:(void (^)(BOOL success))completion {
  NSURL *URL = [NSURL URLWithString:URLString];
  void(^handler)(BOOL succeed) = ^(BOOL succeed) {
    if (!completion) { return; }
    dispatch_async(dispatch_get_main_queue(), ^{
      completion(succeed);
    });
  };
  if (@available(iOS 10.0, *)) {
    [self openURL:URL options:@{} completionHandler:handler];
  } else {
    if ([self canOpenURL:URL]) {
      [self openURL:URL];
      if (handler) { handler(YES); }
    } else {
      if (handler) { handler(NO); }
    }
  }
}

@end
