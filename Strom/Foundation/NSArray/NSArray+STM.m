//
//  NSArray+STM.m
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "NSArray+STM.h"
#import "STMObjectRuntime.h"

@implementation NSArray (STM)

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

@end
