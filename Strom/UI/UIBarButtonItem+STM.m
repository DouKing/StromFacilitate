//
//  UIBarButtonItem+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2019/2/25.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import "UIBarButtonItem+STM.h"
#import <objc/runtime.h>

@implementation UIBarButtonItem (STM)

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style handler:(void (^)(UIBarButtonItem * _Nonnull))handler {
  self.handler = handler;
  return [self initWithImage:image style:style target:self action:@selector(_handleAction:)];
}

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style handler:(void (^)(UIBarButtonItem * _Nonnull))handler {
  self.handler = handler;
  return [self initWithTitle:title style:style target:self action:@selector(_handleAction:)];
}

- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem handler:(void (^)(UIBarButtonItem * _Nonnull))handler {
  self.handler = handler;
  return [self initWithBarButtonSystemItem:systemItem target:self action:@selector(_handleAction:)];
}

- (void)_handleAction:(UIBarButtonItem *)sender {
  if (self.handler) {
    self.handler(sender);
  }
}

- (void)setHandler:(void (^)(UIBarButtonItem * _Nonnull))handler {
  objc_setAssociatedObject(self, @selector(handler), handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIBarButtonItem * _Nonnull))handler {
  return objc_getAssociatedObject(self, _cmd);
}

@end
