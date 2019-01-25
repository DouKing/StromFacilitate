//
//  NSData+STM.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/2.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "NSData+STM.h"
#import <CommonCrypto/CommonCryptor.h>
#import <zlib.h>

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

- (NSString *)stm_hexString {
  if (0 == [self length]) {
    return @"";
  }
  NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[self length]];
  
  [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
    unsigned char *dataBytes = (unsigned char*)bytes;
    for (NSInteger i = 0; i < byteRange.length; i++) {
      NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
      if ([hexStr length] == 2) {
        [string appendString:hexStr];
      } else {
        [string appendFormat:@"0%@", hexStr];
      }
    }
  }];
  
  return string;
}

#pragma mark - gzip

- (NSData *)gzippedDataWithCompressionLevel:(float)level {
  if (self.length == 0 || [self isGzippedData]) {
    return self;
  }

  z_stream stream;
  stream.zalloc = Z_NULL;
  stream.zfree = Z_NULL;
  stream.opaque = Z_NULL;
  stream.avail_in = (uint)self.length;
  stream.next_in = (Bytef *)(void *)self.bytes;
  stream.total_out = 0;
  stream.avail_out = 0;

  static const NSUInteger ChunkSize = 16384;

  NSMutableData *output = nil;
  int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
  if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
    output = [NSMutableData dataWithLength:ChunkSize];
    while (stream.avail_out == 0) {
      if (stream.total_out >= output.length) {
        output.length += ChunkSize;
      }
      stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
      stream.avail_out = (uInt)(output.length - stream.total_out);
      deflate(&stream, Z_FINISH);
    }
    deflateEnd(&stream);
    output.length = stream.total_out;
  }

  return output;
}

- (NSData *)gzippedData {
  return [self gzippedDataWithCompressionLevel:-1.0f];
}

- (NSData *)gunzippedData {
  if (self.length == 0 || ![self isGzippedData]) {
    return self;
  }

  z_stream stream;
  stream.zalloc = Z_NULL;
  stream.zfree = Z_NULL;
  stream.avail_in = (uint)self.length;
  stream.next_in = (Bytef *)self.bytes;
  stream.total_out = 0;
  stream.avail_out = 0;

  NSMutableData *output = nil;
  if (inflateInit2(&stream, 47) == Z_OK) {
    int status = Z_OK;
    output = [NSMutableData dataWithCapacity:self.length * 2];
    while (status == Z_OK) {
      if (stream.total_out >= output.length) {
        output.length += self.length / 2;
      }
      stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
      stream.avail_out = (uInt)(output.length - stream.total_out);
      status = inflate (&stream, Z_SYNC_FLUSH);
    }
    if (inflateEnd(&stream) == Z_OK) {
      if (status == Z_STREAM_END) {
        output.length = stream.total_out;
      }
    }
  }

  return output;
}

- (BOOL)isGzippedData {
  const UInt8 *bytes = (const UInt8 *)self.bytes;
  return (self.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

@end
