//
//  NSDictionary+STMSafe.m
//  StromFacilitate
//
//  Created by iosci on 2017/3/29.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "NSDictionary+STMSafe.h"

@implementation NSDictionary (STMSafe)
  
+ (instancetype)dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
  NSMutableArray *objArray = [NSMutableArray array];
  NSMutableArray *keyArray = [NSMutableArray array];
  for (NSUInteger i = 0; i < cnt; i++) {
    if (objects[i] && keys[i]) {
      [objArray addObject:objects[i]];
      [keyArray addObject:keys[i]];
    } else {
      NSLog(@"dictionary can't insert nil object or use nil key");
    }
  }
  
  return [self dictionaryWithObjects:objArray forKeys:keyArray];
}

@end
