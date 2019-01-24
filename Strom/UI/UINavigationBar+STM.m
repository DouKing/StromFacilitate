//
//  UINavigationBar+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2018/10/12.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import "UINavigationBar+STM.h"
#import <objc/runtime.h>

@implementation UINavigationBar (STM)

- (void)setStm_hideBottomLine:(BOOL)stm_hideBottomLine {
  objc_setAssociatedObject(self, @selector(stm_isHideBottomLine), @(stm_hideBottomLine), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  self.bottomLine.hidden = stm_hideBottomLine;
}

- (BOOL)stm_isHideBottomLine {
  return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (UIView *)bottomLine {
  UIView *line = objc_getAssociatedObject(self, _cmd);
  if (!line) {
    NSArray<UIView *> *subViews = self.subviews.firstObject.subviews;
    for (UIView *obj in subViews) {
      if (![obj isKindOfClass:[UIImageView class]]) { continue; }
      if (obj.frame.size.height > 1) { continue; }
      line = obj;
      break;
    }
    objc_setAssociatedObject(self, _cmd, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return line;
}

@end
