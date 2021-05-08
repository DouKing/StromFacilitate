//
//  NSURLProtocol+STMWebKit.h
//  StromFacilitate
//
//  Created by DouKing on 2021/5/8.
//  Copyright © 2021 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLProtocol (STMWebKit)

+ (void)stm_registerScheme:(NSString *)scheme;
+ (void)stm_unregisterScheme:(NSString *)scheme;

@end

NS_ASSUME_NONNULL_END
