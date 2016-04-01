//
//  NSString+STM.h
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSString (STM)

// md5
- (NSString *)stm_stringToMD5;

// string -> base64 string
- (NSString *)stm_base64EncodeString;
// string -> base64 data
- (NSData *)stm_base64EncodeData;

// base64 string -> data
- (NSData *)stm_base64DecodeData;
// base64 string -> string
- (NSString *)stm_base64DecodeString;

@end


NS_ASSUME_NONNULL_END