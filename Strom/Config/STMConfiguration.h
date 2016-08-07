//
//  STMConfiguration.h
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#define STMLog(...) NSLog(__VA_ARGS__)
#define STMLogObj(A) NSLog(@"%@", A)
#define STMLogMethod() NSLog(@"%s", __func__)
#else
#define STMLog(...)
#define STMLogMethod()
#define NSLog(...) {};
#endif


#define STMScreenBounds          ([[UIScreen mainScreen] bounds])
#define STMScreenWidth           (CGRectGetWidth([[UIScreen mainScreen] bounds]))
#define STMScreenHeight          (CGRectGetHeight([[UIScreen mainScreen] bounds]))
#define STMScreenScale           ([UIScreen mainScreen].scale)
#define STMSingleHeight          (1 / STMScreenScale)
#define STMStatusBarHeight       (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]))
#define STMNavigationBarHeight   (64)
#define STMTabBarHeight          (49)

FOUNDATION_EXPORT NSString * const STMDocumentPath();

FOUNDATION_EXPORT NSString * const STMAppVersion();
FOUNDATION_EXPORT NSString * const STMSystemVersion();

FOUNDATION_EXPORT BOOL STMSystemVersionEqualTo(NSString *version);
FOUNDATION_EXPORT BOOL STMSystemVersionGreaterThan(NSString *version);
FOUNDATION_EXPORT BOOL STMSystemVersionGreaterThanOrEqualTo(NSString *version);
FOUNDATION_EXPORT BOOL STMSystemVersionLessThan(NSString *version);
FOUNDATION_EXPORT BOOL STMSystemVersionLessThanOrEqualTo(NSString *version);

FOUNDATION_EXPORT BOOL STMSystemVersionIOS7Later();
FOUNDATION_EXPORT BOOL STMSystemVersionIOS8Later();
FOUNDATION_EXPORT BOOL STMSystemVersionIOS9Later();


@interface STMConfiguration : NSObject
@end

NS_ASSUME_NONNULL_END