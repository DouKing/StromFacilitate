//
//  STMConfiguration.h
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO-" DEFER_STRINGIFY(__COUNTER__) "] " MSG " \n" \
                              DEFER_STRINGIFY(__FILE__) " line " DEFER_STRINGIFY(__LINE__)
#define TODO(MSG) PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))

#define STMFinalClass            __attribute__((objc_subclassing_restricted))
#define STMNSValueEnable         __attribute__((objc_boxable))
#define STMRename(s)             __attribute__((objc_runtime_name(s)))

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
