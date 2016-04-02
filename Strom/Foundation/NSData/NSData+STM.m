//
//  NSData+STM.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/2.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "NSData+STM.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (STM)

- (NSData *)stm_AES256EncryptWithKey:(NSString *)key {
  char keyPtr[kCCKeySizeAES256 + 1];
  bzero(keyPtr, sizeof(keyPtr));
  [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
  NSUInteger dataLength = [self length];
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  size_t numBytesEncrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                        kCCOptionPKCS7Padding | kCCOptionECBMode,
                                        keyPtr, kCCBlockSizeAES128,
                                        NULL,
                                        [self bytes], dataLength,
                                        buffer, bufferSize,
                                        &numBytesEncrypted);
  if (cryptStatus != kCCSuccess) {
    free(buffer);
    return nil;
  }
  NSData *encryData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
  free(buffer);
  return encryData;
}

- (NSData *)stm_AES256DecryptWithKey:(NSString *)key {
  char keyPtr[kCCKeySizeAES256 + 1];
  bzero(keyPtr, sizeof(keyPtr));
  [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
  NSUInteger dataLength = [self length];
  size_t bufferSize = dataLength + kCCBlockSizeAES128;
  void *buffer = malloc(bufferSize);
  size_t numBytesDecrypted = 0;
  CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                        kCCOptionPKCS7Padding | kCCOptionECBMode,
                                        keyPtr, kCCBlockSizeAES128,
                                        NULL,
                                        [self bytes], dataLength,
                                        buffer, bufferSize,
                                        &numBytesDecrypted);
  if (cryptStatus != kCCSuccess) {
    free(buffer);
    return nil;
  }
  NSData *decryData = [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
  free(buffer);
  return decryData;
}

@end
