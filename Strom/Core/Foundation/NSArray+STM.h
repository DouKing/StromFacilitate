//
//  NSArray+STM.h
//  StromFacilitate
//
//  Created by DouKing on 2018/10/8.
//  Copyright © 2018 DouKing. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (STM)

- (NSArray *)stm_map:(nullable id (^)(ObjectType value, NSUInteger index))block;
- (NSArray<ObjectType> *)stm_filter:(BOOL (^)(ObjectType value))block;
- (NSArray<ObjectType> *)stm_subArrayToIndex:(NSUInteger)index;
- (NSArray<ObjectType> *)stm_subArrayFromIndex:(NSUInteger)index;
- (NSArray<NSArray<ObjectType> *> *)stm_splitWithCount:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
