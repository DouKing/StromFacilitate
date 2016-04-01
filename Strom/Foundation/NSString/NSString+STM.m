//
//  NSString+STM.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "NSString+STM.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (STM)

- (NSString *)stm_stringToMD5 {
  if (!self.length) {
    return nil;
  }
  const char *value = [self UTF8String];
  
  unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
  CC_MD5(value, (unsigned)strlen(value), outputBuffer);
  
  NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
  for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
    [outputString appendFormat:@"%02x", outputBuffer[count]];
  }
  return outputString;
}

- (NSString *)stm_base64EncodeString {
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  return [data base64EncodedStringWithOptions:0];
}

- (NSData *)stm_base64EncodeData {
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  return [data base64EncodedDataWithOptions:0];
}

- (NSString *)stm_base64DecodeString {
  NSData *data = [self stm_base64DecodeData];
  if (!data) { return nil; }
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData *)stm_base64DecodeData {
  if (!self.length) { return nil; }
  return [[NSData alloc] initWithBase64EncodedString:self options:0];
}

@end
