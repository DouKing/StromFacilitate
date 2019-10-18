//
//  NSObject+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/7/22.
//  Copyright © 2019 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 在 info.plist 中配置是否开启 KVO 自释放
static NSString * const kSTMAutoRemoveKVOObserverKey = @"STMAutoRemoveKVOObserver";

@interface NSObject (STM)

@end

#pragma mark -

typedef void (^STMDeallocExecutorBlock)(__unsafe_unretained id owner, NSUInteger identifier);

@interface NSObject (STMDeallocExecutor)

@property (nonatomic, strong, readonly) dispatch_queue_t stm_deallocExecutorQueue;

- (NSUInteger)stm_addDeallocExecutor:(STMDeallocExecutorBlock)block;
- (BOOL)stm_removeDeallocExecutorWithIdentifier:(NSUInteger)identifier;
- (void)stm_removeAllDeallocExecutors;

@end

NS_ASSUME_NONNULL_END
