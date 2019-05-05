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
    Class aClass = objc_getClass("__NSArray0");
    SEL systemSel = @selector(objectAtIndex:);
    SEL systemSel2 = @selector(objectAtIndexedSubscript:);
    SEL swizzSel = @selector(stm_array0_objectAtIndex:);
    SEL swizzSel2 = @selector(stm_array0_objectAtIndexedSubscript:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    STMSwizzMethod(aClass, systemSel2, swizzSel2);

    aClass = objc_getClass("__NSArrayI");
    systemSel = @selector(objectAtIndex:);
    systemSel2 = @selector(objectAtIndexedSubscript:);
    swizzSel = @selector(stm_arrayI_objectAtIndex:);
    swizzSel2 = @selector(stm_arrayI_objectAtIndexedSubscript:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    STMSwizzMethod(aClass, systemSel2, swizzSel2);

    aClass = objc_getClass("__NSArrayM");
    systemSel = @selector(objectAtIndex:);
    systemSel2 = @selector(objectAtIndexedSubscript:);
    swizzSel = @selector(stm_arrayM_objectAtIndex:);
    swizzSel2 = @selector(stm_arrayM_objectAtIndexedSubscript:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    STMSwizzMethod(aClass, systemSel2, swizzSel2);

    aClass = objc_getClass("__NSSingleObjectArrayI");
    systemSel = @selector(objectAtIndex:);
    systemSel2 = @selector(objectAtIndexedSubscript:);
    swizzSel = @selector(stm_singleObjectArrayI_objectAtIndex:);
    swizzSel2 = @selector(stm_singleObjectArrayI_objectAtIndexedSubscript:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    STMSwizzMethod(aClass, systemSel2, swizzSel2);

    aClass = objc_getClass("__NSFrozenArrayM");
    systemSel = @selector(objectAtIndex:);
    systemSel2 = @selector(objectAtIndexedSubscript:);
    swizzSel = @selector(stm_frozenArrayM_objectAtIndex:);
    swizzSel2 = @selector(stm_frozenArrayM_objectAtIndexedSubscript:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    STMSwizzMethod(aClass, systemSel2, swizzSel2);
  });
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

#pragma mark -  - (id)objectAtIndex:

- (id)stm_array0_objectAtIndex:(NSUInteger)index {
  return nil;
}

- (id)stm_arrayI_objectAtIndex:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_arrayI_objectAtIndex:index];
}

- (id)stm_arrayM_objectAtIndex:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_arrayM_objectAtIndex:index];
}

- (id)stm_singleObjectArrayI_objectAtIndex:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_singleObjectArrayI_objectAtIndex:index];
}

- (id)stm_frozenArrayM_objectAtIndex:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_frozenArrayM_objectAtIndex:index];
}

#pragma mark -  - (id)objectAtIndexedSubscript:

- (id)stm_array0_objectAtIndexedSubscript:(NSUInteger)index {
  return nil;
}

- (id)stm_arrayI_objectAtIndexedSubscript:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_arrayI_objectAtIndex:index];
}

- (id)stm_arrayM_objectAtIndexedSubscript:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_arrayM_objectAtIndex:index];
}

- (id)stm_singleObjectArrayI_objectAtIndexedSubscript:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_singleObjectArrayI_objectAtIndexedSubscript:index];
}

- (id)stm_frozenArrayM_objectAtIndexedSubscript:(NSUInteger)index {
  if (index >= self.count) { return nil; }
  return [self stm_frozenArrayM_objectAtIndexedSubscript:index];
}

@end
