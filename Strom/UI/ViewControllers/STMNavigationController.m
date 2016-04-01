//
//  WYNavigationController.m
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/3/11.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "STMNavigationController.h"
#import "UIViewController+STM.h"

@interface STMNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *currentShowVC;

@end

@implementation STMNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
  UIViewController *topVC = self.topViewController;
  if (topVC.stm_animating) { return; }
  topVC.stm_animating = YES;
  viewController.stm_animating = YES;
  [super pushViewController:viewController animated:animated];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
  typeof(self) nav = [super initWithRootViewController:rootViewController];
  nav.interactivePopGestureRecognizer.delegate = self;
  nav.delegate = self;
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
  if (self.currentShowVC != self.topViewController) {
    return NO;
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

@end
