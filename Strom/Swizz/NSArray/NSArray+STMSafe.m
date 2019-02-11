//
//  NSArray+STMSafe.m
//  StromFacilitate
//
//  Created by DouKing on 2017/3/29.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "NSArray+STMSafe.h"
#import "STMObjectRuntime.h"

@implementation NSArray (STMSafe)
  
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class aClass = [[self array] class];
    SEL systemSel = @selector(objectAtIndex:);
    SEL swizzSel = @selector(stm_objectAtIndex:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
  });
}
  
- (id)stm_objectAtIndex:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_objectAtIndex:index];
}
  
+ (instancetype)arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
  NSMutableArray *objArray = [NSMutableArray array];
  for (NSUInteger i = 0; i < cnt; ++i) {
    if (objects[i]) {
      [objArray addObject:objects[i]];
    } else {
      NSLog(@"`arrayWithObjects:count:` can't insert nil");
    }
  }
  return [self arrayWithArray:objArray];
}

@end
