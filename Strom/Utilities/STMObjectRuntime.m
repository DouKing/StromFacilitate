//
//  STMObjectRuntime.m
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "STMObjectRuntime.h"

void STMSwizzMethod(Class aClass, SEL originSelector, SEL swizzSelector) {
  Method systemMethod = class_getInstanceMethod(aClass, originSelector);
  Method swizzMethod = class_getInstanceMethod(aClass, swizzSelector);
  BOOL isAdd = class_addMethod(aClass,
                               originSelector,
                               method_getImplementation(swizzMethod),
                               method_getTypeEncoding(swizzMethod));
  if (isAdd) {
    class_replaceMethod(aClass,
                        swizzSelector,
                        method_getImplementation(systemMethod),
                        method_getTypeEncoding(systemMethod));
  } else {
    method_exchangeImplementations(systemMethod, swizzMethod);
  }
}

@implementation STMObjectRuntime
@end
