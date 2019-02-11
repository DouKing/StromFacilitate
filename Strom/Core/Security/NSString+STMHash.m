
#import "NSString+STMHash.h"
#import <CommonCrypto/CommonCrypto.h>

static NSUInteger const kSTMFileHashDefaultChunkSizeForReadingData = 4096;

typedef unsigned char *(*HashFunc)(const void *, CC_LONG, unsigned char *);

@implementation NSString (STMHash)

- (NSString *)stm_hashWithType:(STMHashType)type {
    const char *str = self.UTF8String;

    HashFunc func;
    int length = 0;
    switch (type) {
        case STMHashTypeMD5: {
            length = CC_MD5_DIGEST_LENGTH;
            func = CC_MD5;
        } break;
        case STMHashTypeSHA1: {
            length = CC_SHA1_DIGEST_LENGTH;
            func = CC_SHA1;
        } break;
        case STMHashTypeSHA256: {
            length = CC_SHA256_DIGEST_LENGTH;
            func = CC_SHA256;
        } break;
        case STMHashTypeSHA512: {
            length = CC_SHA512_DIGEST_LENGTH;
            func = CC_SHA512;
        } break;
    }

    uint8_t buffer[length];
    func(str, (CC_LONG)strlen(str), buffer);

    return [self _stm_stringFromBytes:buffer length:length];
}

- (NSString *)stm_hmacWithType:(STMHashType)type useKey:(NSString *)key {
    const char *keyData = key.UTF8String;
    const char *strData = self.UTF8String;

    int length = 0;
    CCHmacAlgorithm algorithm;
    switch (type) {
        case STMHashTypeMD5: {
            length = CC_MD5_DIGEST_LENGTH;
            algorithm = kCCHmacAlgMD5;
        } break;
        case STMHashTypeSHA1: {
            length = CC_SHA1_DIGEST_LENGTH;
            algorithm = kCCHmacAlgSHA1;
        } break;
        case STMHashTypeSHA256: {
            length = CC_SHA256_DIGEST_LENGTH;
            algorithm = kCCHmacAlgSHA256;
        } break;
        case STMHashTypeSHA512: {
            length = CC_SHA512_DIGEST_LENGTH;
            algorithm = kCCHmacAlgSHA512;
        } break;
    }

    uint8_t buffer[length];
    CCHmac(algorithm, keyData, strlen(keyData), strData, strlen(strData), buffer);

    return [self _stm_stringFromBytes:buffer length:length];
}

- (NSString *)stm_fileHashWithType:(STMHashType)type {
    switch (type) {
        case STMHashTypeMD5: {
            return [self _stm_fileMD5Hash];
        } break;
        case STMHashTypeSHA1: {
            return [self _stm_fileSHA1Hash];
        } break;
        case STMHashTypeSHA256: {
            return [self _stm_fileSHA256Hash];
        } break;
        case STMHashTypeSHA512: {
            return [self _stm_fileSHA512Hash];
        } break;
    }
}

#pragma mark - Private

- (NSString *)_stm_fileMD5Hash {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fileHandle == nil) {
        return nil;
    }
    
    CC_MD5_CTX hashCtx;
    CC_MD5_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fileHandle readDataOfLength:kSTMFileHashDefaultChunkSizeForReadingData];
            CC_MD5_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fileHandle closeFile];
    
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &hashCtx);
    
    return [self _stm_stringFromBytes:buffer length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)_stm_fileSHA1Hash {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fileHandle == nil) {
        return nil;
    }
    
    CC_SHA1_CTX hashCtx;
    CC_SHA1_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fileHandle readDataOfLength:kSTMFileHashDefaultChunkSizeForReadingData];
            CC_SHA1_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fileHandle closeFile];
    
    uint8_t buffer[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_Final(buffer, &hashCtx);
    
    return [self _stm_stringFromBytes:buffer length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)_stm_fileSHA256Hash {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fileHandle == nil) {
        return nil;
    }
    
    CC_SHA256_CTX hashCtx;
    CC_SHA256_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fileHandle readDataOfLength:kSTMFileHashDefaultChunkSizeForReadingData];
            CC_SHA256_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fileHandle closeFile];
    
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &hashCtx);
    
    return [self _stm_stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)_stm_fileSHA512Hash {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:self];
    if (fileHandle == nil) {
        return nil;
    }
    
    CC_SHA512_CTX hashCtx;
    CC_SHA512_Init(&hashCtx);
    
    while (YES) {
        @autoreleasepool {
            NSData *data = [fileHandle readDataOfLength:kSTMFileHashDefaultChunkSizeForReadingData];
            CC_SHA512_Update(&hashCtx, data.bytes, (CC_LONG)data.length);
            if (data.length == 0) {
                break;
            }
        }
    }
    [fileHandle closeFile];
    
    uint8_t buffer[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512_Final(buffer, &hashCtx);
    
    return [self _stm_stringFromBytes:buffer length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)_stm_stringFromBytes:(uint8_t *)bytes length:(int)length {
    NSMutableString *strM = [NSMutableString stringWithCapacity:length * 2];
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    return [strM copy];
}

@end
