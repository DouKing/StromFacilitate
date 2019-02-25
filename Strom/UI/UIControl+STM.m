//
//  UIControl+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2019/2/25.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import "UIControl+STM.h"
#import <objc/runtime.h>

@interface STMControlWrapper : NSObject <NSCopying>

- (instancetype)initWithHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;

@property (nonatomic) UIControlEvents controlEvents;
@property (nonatomic, copy) void (^handler)(id sender);

@end

@implementation STMControlWrapper

- (instancetype)initWithHandler:(void (^)(id))handler forControlEvents:(UIControlEvents)controlEvents {
  self = [super init];
  if (!self) return nil;

  self.handler = handler;
  self.controlEvents = controlEvents;

  return self;
}

- (id)copyWithZone:(NSZone *)zone {
  return [[STMControlWrapper alloc] initWithHandler:self.handler forControlEvents:self.controlEvents];
}

- (void)invoke:(id)sender {
  self.handler(sender);
}

@end

@implementation UIControl (STM)

- (void)stm_addEventHandlerForControlEvents:(UIControlEvents)controlEvents :(void (^)(id _Nonnull))handler {
  if (!handler) { return; }
  NSMutableDictionary *events = self.stm_events;
  NSNumber *key = @(controlEvents);
  NSMutableSet *handlers = events[key];
  if (!handlers) {
    handlers = [NSMutableSet set];
    events[key] = handlers;
  }

  STMControlWrapper *target = [[STMControlWrapper alloc] initWithHandler:handler forControlEvents:controlEvents];
  [handlers addObject:target];
  [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
}

- (void)stm_removeEventHandlersForControlEvents:(UIControlEvents)controlEvents {
  NSMutableDictionary<NSNumber *, NSMutableSet *> *events = [self stm_events];
  NSNumber *key = @(controlEvents);
  NSSet *handlers = events[key];
  if (!handlers) { return; }
  [handlers enumerateObjectsUsingBlock:^(id sender, BOOL *stop) {
    [self removeTarget:sender action:NULL forControlEvents:controlEvents];
  }];
  [events removeObjectForKey:key];
}

- (BOOL)stm_hasEventHandlersForControlEvents:(UIControlEvents)controlEvents {
  NSMutableDictionary<NSNumber *, NSMutableSet *> *events = [self stm_events];
  NSNumber *key = @(controlEvents);
  NSSet *handlers = events[key];
  if (!handlers) { return NO; }
  return handlers.count > 0;
}

- (NSMutableDictionary<NSNumber *, NSMutableSet *> *)stm_events {
  NSMutableDictionary<NSNumber *, NSMutableSet *> *events = objc_getAssociatedObject(self, _cmd);
  if (!events) {
    events = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, _cmd, events, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  return events;
}

@end
