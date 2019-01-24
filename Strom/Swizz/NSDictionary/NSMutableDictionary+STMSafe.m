//
//  NSMutableDictionary+STMSafe.m
//  StromFacilitate
//
//  Created by iosci on 2017/3/29.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "NSMutableDictionary+STMSafe.h"
#import "STMObjectRuntime.h"

@implementation NSMutableDictionary (STMSafe)
  
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class aClass = [[self new] class];
    SEL systemSel = @selector(setObject:forKey:);
    SEL swizzSel = @selector(stm_setObject:forKey:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
    
    systemSel = @selector(removeObjectForKey:);
    swizzSel = @selector(stm_removeObjectForKey:);
    STMSwizzMethod(aClass, systemSel, swizzSel);
  });
}
  
- (void)stm_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
  if (!aKey) {
    return;
  }
  if (!anObject) {
    [self removeObjectForKey:aKey];
    return;
  }
  [self stm_setObject:anObject forKey:aKey];
}
  
- (void)stm_removeObjectForKey:(id<NSCopying>)aKey {
  if (!aKey) {
    return;
  }
  [self stm_removeObjectForKey:aKey];
}

@end
