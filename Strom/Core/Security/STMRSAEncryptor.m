//
//  STMRSAEncryptor.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/2.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "STMRSAEncryptor.h"
#import <Security/Security.h>
#import "NSString+STM.h"

// 公钥/私钥标签
#define kSTMPublicKeyTag  "com.douking.rsa.publickey"
#define kSTMPrivateKeyTag "com.douking.rsa.privatekey"

static const uint8_t publicKeyIdentifier[]  = kSTMPublicKeyTag;
static const uint8_t privateKeyIdentifier[] = kSTMPrivateKeyTag;

@implementation STMRSAEncryptor {
  SecKeyRef _publicKey;
  SecKeyRef _privateKey;
  NSData *_publicTag;        // 公钥标签
  NSData *_privateTag;       // 私钥标签
}

- (void)dealloc {
  if (_publicKey) { CFRelease(_publicKey); _publicKey = NULL; }
  if (_privateKey) { CFRelease(_privateKey); _privateKey = NULL; }
}

- (instancetype)init {
  if (self = [super init]) {
    _publicTag = [NSData dataWithBytes:publicKeyIdentifier length:sizeof(publicKeyIdentifier)];
    _privateTag = [NSData dataWithBytes:privateKeyIdentifier length:sizeof(privateKeyIdentifier)];
  }
  return self;
}

- (void)generateKeyPair:(STMRSASecretKeySize)keySize {
  OSStatus sanityCheck = noErr;
  _publicKey = NULL;
  _privateKey = NULL;

  // 删除当前密钥对
  [self _deleteAsymmetricKeys];

  // 容器字典
  NSMutableDictionary *privateKeyAttr = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *publicKeyAttr = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *keyPairAttr = [[NSMutableDictionary alloc] init];

  // 设置密钥对的顶级字典
  [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
  [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(__bridge id)kSecAttrKeySizeInBits];

  // 设置私钥字典
  [privateKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
  [privateKeyAttr setObject:_privateTag forKey:(__bridge id)kSecAttrApplicationTag];

  // 设置公钥字典
  [publicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecAttrIsPermanent];
  [publicKeyAttr setObject:_publicTag forKey:(__bridge id)kSecAttrApplicationTag];

  // 设置顶级字典属性
  [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
  [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];

  // SecKeyGeneratePair 返回密钥对引用
  sanityCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &_publicKey, &_privateKey);
  NSAssert((sanityCheck == noErr && _publicKey != NULL && _privateKey != NULL), @"生成密钥对失败");
}

- (void)loadPublicKeyFromFilePath:(NSString *)path {
  NSData *data = [NSData dataWithContentsOfFile:path];
  [self loadPublicKeyFromData:data];
}

- (void)loadPublicKeyFromData:(NSData *)data {
  _publicKey = [self _publicKeyRefrenceFromData:data];
}

- (void)loadPrivateKeyFromFilePath:(NSString *)path password:(NSString *)password {
  NSData *data = [NSData dataWithContentsOfFile:path];
  [self loadPrivateKeyFromData:data password:password];
}

- (void)loadPrivateKeyFromData:(NSData *)data password:(NSString *)password {
  _privateKey = [self _privateKeyRefrenceFromData:data password:password];
}

- (NSString *)rsaDecryptString:(NSString *)encryptString {
  NSData *data = [encryptString stm_base64DecodeData];
  NSData *decryptData = [self rsaDecryptData:data];
  NSString *resultStr = [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
  return resultStr;
}

- (NSData *)rsaDecryptData:(NSData *)encryptData {
  SecKeyRef key = _privateKey;
  size_t cipherLen = [encryptData length];
  void *cipher = malloc(cipherLen);
  [encryptData getBytes:cipher length:cipherLen];
  size_t plainLen = SecKeyGetBlockSize(key) - 12;
  void *plain = malloc(plainLen);
  OSStatus status = SecKeyDecrypt(key, kSecPaddingPKCS1, cipher, cipherLen, plain, &plainLen);
  if (status != noErr) {
    free(plain);
    free(cipher);
    return nil;
  }
  NSData *decryptedData = [NSData dataWithBytes:(const void *)plain length:plainLen];
  free(plain);
  free(cipher);
  return decryptedData;
}

- (NSString *)rsaEncryptString:(NSString *)originString {
  NSData *data = [originString dataUsingEncoding:NSUTF8StringEncoding];
  NSData *encryptData = [self rsaEncryptData:data];
  NSString *base64EncryptedString = [encryptData base64EncodedStringWithOptions:0];
  return base64EncryptedString;
}

- (NSData *)rsaEncryptData:(NSData *)originData {
  SecKeyRef key = _publicKey;
  size_t cipherBufferSize = SecKeyGetBlockSize(key);
  uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
  size_t blockSize = cipherBufferSize - 11;// 分段加密
  size_t blockCount = (size_t)ceil([originData length] / (double)blockSize);
  NSMutableData *encryptedData = [NSMutableData data] ;
  for (int i = 0; i < blockCount; i++) {
    size_t bufferSize = MIN(blockSize, ([originData length] - i * blockSize));
    NSData *buffer = [originData subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
    OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes], [buffer length], cipherBuffer, &cipherBufferSize);
    if (status == noErr){
      NSData *encryptedBytes = [NSData dataWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
      [encryptedData appendData:encryptedBytes];
    } else {
      if (cipherBuffer) {
        free(cipherBuffer);
      }
      return nil;
    }
  }
  if (cipherBuffer) {
    free(cipherBuffer);
  }
  return encryptedData;
}

#pragma mark - Private Methods -

- (void)_deleteAsymmetricKeys {
  OSStatus sanityCheck = noErr;
  NSMutableDictionary *queryPublicKey = [[NSMutableDictionary alloc] init];
  NSMutableDictionary *queryPrivateKey = [[NSMutableDictionary alloc] init];

  // 设置公钥查询字典
  [queryPublicKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
  [queryPublicKey setObject:_publicTag forKey:(__bridge id)kSecAttrApplicationTag];
  [queryPublicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

  // 设置私钥查询字典
  [queryPrivateKey setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
  [queryPrivateKey setObject:_privateTag forKey:(__bridge id)kSecAttrApplicationTag];
  [queryPrivateKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];

  // 删除私钥
  sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPrivateKey);
  NSAssert1((sanityCheck == noErr || sanityCheck == errSecItemNotFound), @"删除私钥错误，OSStatus == %d", sanityCheck);

  // 删除公钥
  sanityCheck = SecItemDelete((__bridge CFDictionaryRef)queryPublicKey);
  NSAssert1((sanityCheck == noErr || sanityCheck == errSecItemNotFound), @"删除公钥错误，OSStatus == %d", sanityCheck);

  if (_publicKey) CFRelease(_publicKey);
  if (_privateKey) CFRelease(_privateKey);
}

- (SecKeyRef)_publicKeyRefrenceFromData:(NSData *)pubData {
  SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)pubData);
  SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
  SecTrustRef myTrust;
  OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
  SecTrustResultType trustResult;
  if (status == noErr) {
    status = SecTrustEvaluate(myTrust, &trustResult);
  }
  SecKeyRef securityKey = SecTrustCopyPublicKey(myTrust);
  CFRelease(myCertificate);
  CFRelease(myPolicy);
  CFRelease(myTrust);
  return securityKey;
}

- (SecKeyRef)_privateKeyRefrenceFromData:(NSData *)priData password:(NSString *)password {
  SecKeyRef privateKeyRef = NULL;
  NSMutableDictionary *options = [NSMutableDictionary dictionary];
  [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
  CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
  OSStatus securityError = SecPKCS12Import((__bridge CFDataRef)priData, (__bridge CFDictionaryRef)options, &items);
  if (securityError == noErr && CFArrayGetCount(items) > 0) {
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
    securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
    if (securityError != noErr) {
      privateKeyRef = NULL;
    }
  }
  CFRelease(items);
  return privateKeyRef;
}

@end
