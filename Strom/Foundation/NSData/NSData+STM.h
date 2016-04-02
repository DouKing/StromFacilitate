//
//  NSData+STM.h
//  StromFacilitate
//
//  Created by WuYikai on 16/4/2.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSData (STM)

/// 使用key加密
- (nullable NSData *)stm_AES256EncryptWithKey:(NSString *)key;

/// 使用key解密
- (nullable NSData *)stm_AES256DecryptWithKey:(NSString *)key;

@end


NS_ASSUME_NONNULL_END