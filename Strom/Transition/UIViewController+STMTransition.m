//
//  UIViewController+STMTransition.m
//  StromFacilitate
//
//  Created by WuYikai on 16/7/21.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "UIViewController+STMTransition.h"
#import "STMObjectRuntime.h"

@implementation UIViewController (STMTransition)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL systemSel = @selector(viewDidLoad);
    SEL swizzSel = @selector(_stm_viewDidLoad);
    STMSwizzMethod([self class], systemSel, swizzSel);
  });
}

- (void)_stm_viewDidLoad {
  [self _stm_viewDidLoad];
  self.navigationTransitionStyle = STMNavigationTransitionStyleNone;
}

- (STMNavigationTransitionStyle)navigationTransitionStyle {
  NSNumber *style = objc_getAssociatedObject(self, @selector(navigationTransitionStyle));
  if (!style) {
    style = @(STMNavigationTransitionStyleNone);
    self.navigationTransitionStyle = [style integerValue];
  }
  return [style integerValue];
}

- (void)setNavigationTransitionStyle:(STMNavigationTransitionStyle)navigationTransitionStyle {
  objc_setAssociatedObject(self, @selector(navigationTransitionStyle), @(navigationTransitionStyle), OBJC_ASSOCIATION_RETAIN);
}

@end
