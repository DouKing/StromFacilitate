//
//  NSArray+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2018/10/8.
//  Copyright © 2018 secoo. All rights reserved.
//

#import "NSArray+STM.h"

@implementation NSArray (STM)

- (NSArray *)stm_map:(id (^)(id _Nonnull, NSUInteger))block {
  NSCParameterAssert(block);
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
  for (NSUInteger i = 0; i < self.count; ++i) {
    id result = block(self[i], i);
    if (result) {
      [array addObject:result];
    }
  }
  return [array copy];
}

- (NSArray *)stm_filter:(BOOL (^)(id))block {
  NSCParameterAssert(block);
  NSMutableArray *array = [NSMutableArray array];
  for (id value in self) {
    if (block(value)) {
      [array addObject:value];
    }
  }
  return array;
}

- (NSArray *)stm_subArrayToIndex:(NSUInteger)index {
  NSMutableArray *temp = [NSMutableArray arrayWithCapacity:index + 1];
  [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [temp addObject:obj];
    if (idx >= index) {
      *stop = YES;
    }
  }];
  return [temp copy];
}

- (NSArray *)stm_subArrayFromIndex:(NSUInteger)index {
  NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.count - index];
  [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if (idx >= index) {
      [temp addObject:obj];
    }
  }];
  return [temp copy];
}

- (NSArray *)stm_splitWithCount:(NSUInteger)count {
  NSAssert(count > 0, @"count 不能为 0");
  NSMutableArray *temp = [NSMutableArray arrayWithCapacity:ceil((float)self.count / (float)count)];
  NSArray *array = [self copy];
  while (array.count > 0) {
    NSInteger index = count - 1;
    NSArray *sub = [array stm_subArrayToIndex:index];
    [temp addObject:sub];
    if (array.count > index + 1) {
      array = [array stm_subArrayFromIndex:index + 1];
    } else {
      array = nil;
    }
  }
  return temp;
}

@end
