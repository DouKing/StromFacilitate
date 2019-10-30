//
//  UIGestureRecognizer+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2019/10/29.
//  Copyright © 2019 secoo. All rights reserved.
//

#import "UIGestureRecognizer+STM.h"

static NSUInteger const kSTMGestureRecognizerInitialIdentifier = 1000;

@implementation UIGestureRecognizer (STM)

- (instancetype)stm_initWithHandler:(STMGestureRecognizerHandler)handler {
    UIGestureRecognizer *gesture = [self initWithTarget:self action:@selector(_stm_invoke:)];
    if (handler) {
        gesture.stm_handlers[@(gesture.stm_identifier)] = handler;
    }
    return gesture;
}

- (NSUInteger)stm_addHandler:(STMGestureRecognizerHandler)handler {
    if (!handler) { return 0; }
    NSUInteger identifier = ++self.stm_identifier;
    self.stm_handlers[@(identifier)] = handler;
    return identifier;
}

- (void)stm_removeHandlerWithIdentifier:(NSUInteger)identifier {
    [self.stm_handlers removeObjectForKey:@(identifier)];
}

- (void)stm_removeInitialHandler {
    [self stm_removeHandlerWithIdentifier:kSTMGestureRecognizerInitialIdentifier];
}

- (void)stm_removeAllHandlers {
    [self.stm_handlers removeAllObjects];
}

- (void)_stm_invoke:(UIGestureRecognizer *)sender {
    [self.stm_handlers enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, STMGestureRecognizerHandler  _Nonnull obj, BOOL * _Nonnull stop) {
        !obj ?: obj(sender);
    }];
}

- (void)setStm_identifier:(NSUInteger)stm_identifier {
    objc_setAssociatedObject(self, @selector(stm_identifier), @(stm_identifier), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)stm_identifier {
    NSNumber *identifier = objc_getAssociatedObject(self, _cmd);
    if (!identifier) {
        self.stm_identifier = kSTMGestureRecognizerInitialIdentifier;
        return kSTMGestureRecognizerInitialIdentifier;
    }
    return [identifier integerValue];
}

- (NSMutableDictionary<NSNumber *, STMGestureRecognizerHandler> *)stm_handlers {
    NSMutableDictionary *handlers = objc_getAssociatedObject(self, _cmd);
    if (!handlers) {
        handlers = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, handlers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return handlers;
}

@end
