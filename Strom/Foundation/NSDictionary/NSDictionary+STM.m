//
//  NSDictionary+STM.m
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/3/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "NSDictionary+STM.h"

@implementation NSDictionary (STM)

- (NSDictionary *)stm_dictionaryBySettingObject:(id)anObject forKey:(id<NSCopying>)aKey {
  if (!anObject || !aKey) {
    return self;
  }
  NSMutableDictionary *dic = self ? [self mutableCopy] : [NSMutableDictionary dictionary];
  dic[aKey] = anObject;
  return [NSDictionary dictionaryWithDictionary:dic];
}

- (NSDictionary *)stm_dictionaryByRemovingObjectForKey:(id<NSCopying>)aKey {
  if (!aKey || !self) {
    return self;
  }
  NSMutableDictionary *dic = [self mutableCopy];
  [dic removeObjectForKey:aKey];
  return [NSDictionary dictionaryWithDictionary:dic];
}

- (NSDictionary *)stm_dictionaryByAppendingDictionary:(NSDictionary *)dictionary {
  if ([dictionary allKeys].count < 1) { return self; }
  NSMutableDictionary *temp = [self mutableCopy];
  [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    temp[key] = obj;
  }];
  return [NSDictionary dictionaryWithDictionary:temp];
}

@end
