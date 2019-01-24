//
//  STMRSAEncryptor.h
//  StromFacilitate
//
//  Created by WuYikai on 16/4/2.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  初始化后，请先加载公钥或私钥，然后调用相应方法加密或解密
 */
@interface STMRSAEncryptor : NSObject

/// 加载公钥
- (void)loadPublicKeyFromFilePath:(NSString *)path;
- (void)loadPublicKeyFromData:(NSData *)data;

/// 加载私钥
- (void)loadPrivateKeyFromFilePath:(NSString *)path password:(NSString *)password;
- (void)loadPrivateKeyFromData:(NSData *)data password:(NSString *)password;

/**
 *  使用公钥加密
 *
 *  @param originString 待加密字符串
 *
 *  @return 加密后字符串
 */
- (NSString *)rsaEncryptString:(NSString *)originString;

/**
 *  使用公钥加密
 *
 *  @param originData 待加密Data
 *
 *  @return 加密后Data
 */
- (NSData *)rsaEncryptData:(NSData *)originData;

/**
 *  使用私钥解密
 *
 *  @param encryptString 待解密的字符串
 *
 *  @return 解密后的字符串
 */
- (NSString *)rsaDecryptString:(NSString *)encryptString;

/**
 *  使用私钥解密
 *
 *  @param encryptData 待解密data
 *
 *  @return 解密后data
 */
- (NSData *)rsaDecryptData:(NSData *)encryptData;

@end


NS_ASSUME_NONNULL_END
