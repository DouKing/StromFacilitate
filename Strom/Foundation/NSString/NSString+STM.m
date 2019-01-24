//
//  NSString+STM.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 DouKing. All rights reserved.
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

- (NSData *)stm_hexStringToData {
  if (0 == [self length]) {
    return nil;
  }
  NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
  NSRange range;
  if ([self length] % 2 == 0) {
    range = NSMakeRange(0, 2);
  } else {
    range = NSMakeRange(0, 1);
  }
  for (NSInteger i = range.location; i < [self length]; i += 2) {
    unsigned int anInt;
    NSString *hexCharStr = [self substringWithRange:range];
    NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
    
    [scanner scanHexInt:&anInt];
    NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
    [hexData appendData:entity];
    
    range.location += range.length;
    range.length = 2;
  }
  return hexData;
}

@end
