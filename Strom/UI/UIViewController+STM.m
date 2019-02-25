//
//  UIViewController+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2019/2/25.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import "UIViewController+STM.h"
#import <objc/runtime.h>

@implementation UIViewController (STM)

- (void)setStm_closeHandler:(void (^)(UIViewController * _Nonnull))stm_closeHandler {
  objc_setAssociatedObject(self, @selector(stm_closeHandler), stm_closeHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIViewController * _Nonnull))stm_closeHandler {
  return objc_getAssociatedObject(self, _cmd);
}

@end
