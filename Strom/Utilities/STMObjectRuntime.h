//
//  STMObjectRuntime.h
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN


/**
 *  替换实现
 *
 *  @param aClass         类
 *  @param originSelector 待替换方法
 *  @param swizzSelector  替换的方法
 */
FOUNDATION_EXPORT void STMSwizzMethod(Class aClass, SEL originSelector, SEL swizzSelector);

@interface STMObjectRuntime : NSObject
@end


NS_ASSUME_NONNULL_END