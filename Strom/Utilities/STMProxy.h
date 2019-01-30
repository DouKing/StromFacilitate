//
//  STMProxy.h
//  StromFacilitate
//
//  Created by DouKing on 2019/1/30.
//  Copyright © 2019 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface STMProxy : NSProxy

@property (nullable, nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(nullable id)target;
+ (instancetype)proxyWithTarget:(nullable id)target;

@end

NS_ASSUME_NONNULL_END
