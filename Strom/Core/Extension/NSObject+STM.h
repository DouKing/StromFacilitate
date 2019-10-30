//
//  NSObject+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2019/7/22.
//  Copyright © 2019 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (STM)
/// 使用该方法添加的 observer 会自释放
- (void)stm_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
- (void)stm_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;
- (void)stm_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
@end

#pragma mark -

typedef void (^STMDeallocExecutorBlock)(__unsafe_unretained id owner, NSUInteger identifier);

@interface NSObject (STMDeallocExecutor)

//@property (nonatomic, strong, readonly) dispatch_queue_t stm_deallocExecutorQueue;

- (NSUInteger)stm_addDeallocExecutor:(STMDeallocExecutorBlock)block;
- (BOOL)stm_removeDeallocExecutorWithIdentifier:(NSUInteger)identifier;
- (void)stm_removeAllDeallocExecutors;

@end

NS_ASSUME_NONNULL_END
