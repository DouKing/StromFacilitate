//
//  NSMutableArray+STMSafe.m
//  StromFacilitate
//
//  Created by iosci on 2017/3/29.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "NSMutableArray+STMSafe.h"
#import "STMObjectRuntime.h"

@implementation NSMutableArray (STMSafe)
  
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class aClass = [[self new] class];
    SEL systemSel = @selector(addObject:);
    SEL swizzSel = @selector(stm_addObject:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    
    systemSel = @selector(insertObject:atIndex:);
    swizzSel = @selector(stm_insertObject:atIndex:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    
    systemSel = @selector(removeObjectAtIndex:);
    swizzSel = @selector(stm_removeObjectAtIndex:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    
    systemSel = @selector(replaceObjectAtIndex:withObject:);
    swizzSel = @selector(stm_replaceObjectAtIndex:withObject:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
  });
}
  
- (void)stm_addObject:(id)anObject {
  if (!anObject) { return; }
  [self stm_addObject:anObject];
}
  
- (void)stm_insertObject:(id)anObject atIndex:(NSUInteger)index {
  if (index > self.count) { return; }
  if (!anObject) { return; }
  [self stm_insertObject:anObject atIndex:index];
}
  
- (void)stm_removeObjectAtIndex:(NSUInteger)index {
  if (index >= self.count) { return; }
  [self stm_removeObjectAtIndex:index];
}
  
- (void)stm_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
  if (index >= self.count) { return; }
  if (!anObject) {
    [self removeObjectAtIndex:index];
  }
  [self stm_replaceObjectAtIndex:index withObject:anObject];
}

@end
