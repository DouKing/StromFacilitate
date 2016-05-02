//
//  UINavigationController+STM.m
//  StromFacilitate
//
//  Created by WuYikai on 16/5/2.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "UINavigationController+STM.h"
#import "UIViewController+STM.h"
#import "STMObjectRuntime.h"

static char * const kSTMCurrentShowVCKey = "kSTMCurrentShowVCKey";

@interface UINavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *currentShowVC;

@end

@implementation UINavigationController (STM)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL systemSel = @selector(initWithRootViewController:);
    SEL swizzSel = @selector(stm_initWithRootViewController:);
    STMSwizzMethod([self class], systemSel, swizzSel);
    
    systemSel = @selector(pushViewController:animated:);
    swizzSel = @selector(stm_pushViewController:animated:);
    STMSwizzMethod([self class], systemSel, swizzSel);
  });
}

- (void)stm_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  UIViewController *topVC = self.topViewController;
  if (topVC.stm_animating) { return; }
  topVC.stm_animating = YES;
  viewController.stm_animating = YES;
  [self stm_pushViewController:viewController animated:animated];
}

- (instancetype)stm_initWithRootViewController:(UIViewController *)rootViewController {
  typeof(self) nav = [self stm_initWithRootViewController:rootViewController];
  nav.delegate = self;
  nav.interactivePopGestureRecognizer.delegate = self;
  return nav;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  if (1 == navigationController.viewControllers.count) {
    self.currentShowVC = nil;
    return;
  }
  self.currentShowVC = viewController;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if (gestureRecognizer == self.interactivePopGestureRecognizer) {
    return (self.currentShowVC == self.topViewController);
  }
  return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
      [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - setter & getter

- (void)setCurrentShowVC:(UIViewController *)currentShowVC {
  objc_setAssociatedObject(self, kSTMCurrentShowVCKey, currentShowVC, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)currentShowVC {
  return objc_getAssociatedObject(self, kSTMCurrentShowVCKey);
}

@end
