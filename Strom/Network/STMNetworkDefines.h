//
//  STMNetworkDefines.h
//  StromFacilitate
//
//  Created by DouKing on 2019/1/30.
//  Copyright © 2019 DouKing. All rights reserved.
//

#ifndef STMNetworkDefines_h
#define STMNetworkDefines_h

NS_ASSUME_NONNULL_BEGIN

@class STMHTTPRequest;

typedef NS_ENUM(NSInteger, STMHTTPRequestMethod) {
  STMHTTPRequestMethodGET,
  STMHTTPRequestMethodPOST,
  STMHTTPRequestMethodHEAD,
  STMHTTPRequestMethodPUT,
  STMHTTPRequestMethodDELETE,
};

@protocol STMHTTPRequestDelegate <NSObject>

@optional
- (void)httpRequest:(STMHTTPRequest *)httpRequest isInProgress:(NSProgress *)progress;
- (void)httpRequest:(STMHTTPRequest *)httpRequest didFailureWithError:(NSError *)error;
- (void)httpRequestDidSuccess:(STMHTTPRequest *)httpRequest;

@end


@protocol STMMultipartFormData

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * _Nullable __autoreleasing *)error;

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * _Nullable __autoreleasing *)error;

- (void)appendPartWithInputStream:(nullable NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType;

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType;

- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name;

- (void)appendPartWithHeaders:(nullable NSDictionary <NSString *, NSString *> *)headers
                         body:(NSData *)body;

- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay;

@end

NS_ASSUME_NONNULL_END
#endif /* STMNetworkDefines_h */
