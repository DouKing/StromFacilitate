//
//  NSURLProtocol+STMWebKit.m
//  StromFacilitate
//
//  Created by DouKing on 2021/5/8.
//  Copyright © 2021 secoo. All rights reserved.
//

#import "NSURLProtocol+STMWebKit.h"
#import <WebKit/WebKit.h>
#import <objc/message.h>

FOUNDATION_STATIC_INLINE Class STMContextControllerClass() {
	static Class cls = nil;
	if (!cls) {
		cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
	}
	return cls;
}

FOUNDATION_STATIC_INLINE SEL STMRegisterSchemeSelector() {
	return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL STMUnregisterSchemeSelector() {
	return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

@implementation NSURLProtocol (STMWebKit)

+ (void)stm_registerScheme:(NSString *)scheme {
	Class cls = STMContextControllerClass();
	SEL sel = STMRegisterSchemeSelector();
	if ([(id)cls respondsToSelector:sel]) {
		((void (*)(id, SEL, NSString *))(void *) objc_msgSend)(cls, sel, scheme);
	}
}

+ (void)stm_unregisterScheme:(NSString *)scheme {
	Class cls = STMContextControllerClass();
	SEL sel = STMUnregisterSchemeSelector();
	if ([(id)cls respondsToSelector:sel]) {
		((void (*)(id, SEL, NSString *))(void *) objc_msgSend)(cls, sel, scheme);
	}
}

@end
