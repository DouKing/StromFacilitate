//
//  NSObject+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2019/7/22.
//  Copyright © 2019 secoo. All rights reserved.
//

#import "NSObject+STM.h"
#import "STMObjectRuntime.h"
#include <libkern/OSAtomic.h>
#import <pthread.h>

static BOOL autoRemoveKVOObserver = NO;
static NSHashTable *KVOHashTable = nil;

@implementation NSObject (STM)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        autoRemoveKVOObserver = [[[NSBundle mainBundle] infoDictionary][kSTMAutoRemoveKVOObserverKey] boolValue];
        if (autoRemoveKVOObserver) { KVOHashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory]; }

        SEL systemSel = @selector(addObserver:forKeyPath:options:context:);
        SEL swizzSel = @selector(stm_addObserver:forKeyPath:options:context:);
        STMSwizzMethod(self, systemSel, swizzSel);

        systemSel = @selector(removeObserver:forKeyPath:);
        swizzSel = @selector(stm_removeObserver:forKeyPath:);
        STMSwizzMethod(self, systemSel, swizzSel);

        systemSel = @selector(removeObserver:forKeyPath:context:);
        swizzSel = @selector(stm_removeObserver:forKeyPath:context:);
        STMSwizzMethod(self, systemSel, swizzSel);
    });
}

- (void)stm_addObserver:(NSObject *)observer
             forKeyPath:(NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(nullable void *)context {
    if (!autoRemoveKVOObserver) {
        [self stm_addObserver:observer forKeyPath:keyPath options:options context:context];
        return;
    }

    if (!observer || !keyPath || keyPath.length == 0) { return; }
    @synchronized (self) {
        NSString *kvoHash = [self _stm_Hash:observer :keyPath];
        if (![KVOHashTable containsObject:kvoHash]) {
            [KVOHashTable addObject:kvoHash];
            [self stm_addObserver:observer forKeyPath:keyPath options:options context:context];
            __weak typeof(self) __weak_self__ = self;
            [observer stm_addDeallocExecutor:^(__unsafe_unretained id  _Nonnull observedOwner, NSUInteger identifier) {
                [__weak_self__ stm_removeObserver:observedOwner forKeyPath:keyPath context:context];
            }];
        }
    }
}

- (void)stm_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context {
    if (!autoRemoveKVOObserver) {
        [self stm_removeObserver:observer forKeyPath:keyPath context:context];
        return;
    }

    if (!observer || !keyPath || keyPath.length == 0) { return; }
    @synchronized (self) {
        NSString *kvoHash = [self _stm_Hash:observer :keyPath];
        NSHashTable *hashTable = KVOHashTable;
        if (!hashTable) { return; }
        if ([hashTable containsObject:kvoHash]) {
            #if DEBUG
            NSLog(@"[StromFacilitate] %@ remove observer %@ keypath %@", self, observer, keyPath);
            #endif
            [self stm_removeObserver:observer forKeyPath:keyPath context:context];
            [hashTable removeObject:kvoHash];
        }
    }
}

- (void)stm_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (!autoRemoveKVOObserver) {
        [self stm_removeObserver:observer forKeyPath:keyPath];
        return;
    }

    if (!observer || !keyPath || keyPath.length == 0) { return; }
    @synchronized (self) {
        NSString *kvoHash = [self _stm_Hash:observer :keyPath];
        NSHashTable *hashTable = KVOHashTable;
        if (!hashTable) { return; }
        if ([hashTable containsObject:kvoHash]) {
            #if DEBUG
            NSLog(@"[StromFacilitate] %@ remove observer %@ keypath %@", self, observer, keyPath);
            #endif
            [self stm_removeObserver:observer forKeyPath:keyPath];
            [hashTable removeObject:kvoHash];
        }
    }
}

- (NSString *)_stm_Hash:(id)observer :(NSString *)keypath {
    return [NSString stringWithFormat:@"kvo_%p_%p_%@", self, observer, keypath];
}

@end

#pragma mark -

@interface _STMDeallocExecutor : NSObject
@property (nonatomic, assign) pthread_mutex_t lock;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, STMDeallocExecutorBlock> *blocksDictionary;
@property (nonatomic, unsafe_unretained) id owner;
- (instancetype)initWithOwner:(id)owner;
- (NSUInteger)addExecutor:(STMDeallocExecutorBlock)block forIdentifier:(NSUInteger)identifier;
- (BOOL)removeExecutorWithIdentifier:(NSUInteger)identifier;
- (void)removeAllExecutors;
@end

#pragma mark -

static long gSTMDeallocExecutorIdentifier = 1;

@implementation NSObject (STMDeallocExecutor)

- (NSUInteger)stm_addDeallocExecutor:(STMDeallocExecutorBlock)block {
    return [[self deallocExecutor] addExecutor:block forIdentifier:gSTMDeallocExecutorIdentifier++];
}

- (BOOL)stm_removeDeallocExecutorWithIdentifier:(NSUInteger)identifier {
    return [[self deallocExecutor] removeExecutorWithIdentifier:identifier];
}

- (void)stm_removeAllDeallocExecutors {
    [[self deallocExecutor] removeAllExecutors];
}

- (_STMDeallocExecutor *)deallocExecutor {
    _STMDeallocExecutor *executor = objc_getAssociatedObject(self, _cmd);
    if (!executor) {
        executor = [[_STMDeallocExecutor alloc] initWithOwner:self];
        objc_setAssociatedObject(self, _cmd, executor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return executor;
}

- (dispatch_queue_t)stm_deallocExecutorQueue {
    dispatch_queue_t queue = objc_getAssociatedObject(self, _cmd);
    if (!queue) {
        NSString *queueBaseLabel = [NSString stringWithFormat:@"com.douking.%@", NSStringFromClass([self class])];
        NSString *queueNameString = [NSString stringWithFormat:@"%@.STMDeallocExecutor.%@", queueBaseLabel, @(arc4random_uniform(MAXFLOAT))];
        const char *queueName = [queueNameString UTF8String];
        queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_SERIAL);
        objc_setAssociatedObject(self, _cmd, queue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return queue;
}

@end

#pragma mark -

@implementation _STMDeallocExecutor

- (void)dealloc {
    for (NSNumber *key in _blocksDictionary.allKeys) {
        STMDeallocExecutorBlock block = _blocksDictionary[key];
        block(_owner, key.unsignedIntegerValue);
    }
    pthread_mutex_destroy(&_lock);
}

- (instancetype)initWithOwner:(id)owner {
    self = [super init];
    if (self) {
        _owner = owner;
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (NSUInteger)addExecutor:(STMDeallocExecutorBlock)block forIdentifier:(NSUInteger)identifier {
    if (block && identifier > 0) {
        pthread_mutex_lock(&_lock);
        self.blocksDictionary[@(identifier)] = [block copy];
        pthread_mutex_unlock(&_lock);
        return identifier;
    }
    return 0;
}

- (BOOL)removeExecutorWithIdentifier:(NSUInteger)identifier {
    if (identifier > 0) {
        pthread_mutex_lock(&_lock);
        [self.blocksDictionary removeObjectForKey:@(identifier)];
        pthread_mutex_unlock(&_lock);
        return YES;
    }
    return NO;
}

- (void)removeAllExecutors {
    pthread_mutex_lock(&_lock);
    [self.blocksDictionary removeAllObjects];
    pthread_mutex_unlock(&_lock);
}

- (NSMutableDictionary<NSNumber *,STMDeallocExecutorBlock> *)blocksDictionary {
    if (!_blocksDictionary) {
        _blocksDictionary = [NSMutableDictionary dictionary];
    }
    return _blocksDictionary;
}

@end
