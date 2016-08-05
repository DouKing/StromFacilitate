//
//  NSDictionary+STM.m
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/3/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "NSDictionary+STM.h"
#import "STMConfiguration.h"

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

+ (instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
  NSMutableArray *objArray = [NSMutableArray array];
  NSMutableArray *keyArray = [NSMutableArray array];
  for (NSUInteger i = 0; i < cnt; i++) {
    if (objects[i] && keys[i]) {
      [objArray addObject:objects[i]];
      [keyArray addObject:keys[i]];
    } else {
      STMLog(@"dictionary can't insert nil object or use nil key");
    }
  }
  
  return [self dictionaryWithObjects:objArray forKeys:keyArray];
}

@end
