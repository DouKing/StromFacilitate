//
//  UIViewController+STM.m
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/3/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "UIViewController+STM.h"
#import "STMObjectRuntime.h"

static char * const kSTMAnimatingKey = "kSTMAnimatingKey";

@implementation UIViewController (STM)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL systemSel = @selector(viewDidAppear:);
    SEL swizzSel = @selector(stm_viewDidAppear:);
    STMSwizzMethod([self class], systemSel, swizzSel);
    
    systemSel = @selector(viewDidDisappear:);
    swizzSel = @selector(stm_viewDidDisAppear:);
    STMSwizzMethod([self class], systemSel, swizzSel);
  });
}

- (BOOL)stm_animating {
  return [objc_getAssociatedObject(self, kSTMAnimatingKey) boolValue];
}

- (void)setStm_animating:(BOOL)stm_animating {
  objc_setAssociatedObject(self, kSTMAnimatingKey, @(stm_animating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)stm_viewDidAppear:(BOOL)animated {
  [self stm_viewDidAppear:animated];
  self.stm_animating = NO;
}

- (void)stm_viewDidDisAppear:(BOOL)animated {
  [self stm_viewDidDisAppear:animated];
  self.stm_animating = NO;
}

@end
