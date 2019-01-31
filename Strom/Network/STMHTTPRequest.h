//
//  STMHTTPRequest.h
//  StromFacilitate
//
//  Created by DouKing on 2019/1/30.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMNetworkDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface STMHTTPRequest : NSObject

@property (nullable, nonatomic, weak) id<STMHTTPRequestDelegate> delegate;
@property (nonatomic, assign) NSInteger tag;
@property (readonly, nonatomic, strong) NSURLSession *session;
@property (nullable, nonatomic, strong, readonly) NSURLSessionDataTask *currentDataTask;
@property (nullable, nonatomic, strong, readonly) NSDictionary *responseObject;

- (void)start;
- (void)stop;

//{ subclass override
- (BOOL)autoStopWhenDealloc;
- (NSString *)baseURL;
- (NSString *)requestPath;
- (nullable NSDictionary *)requestParameters;
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaders;
- (STMHTTPRequestMethod)requestMethod;
- (void (^ _Nullable)(id<STMMultipartFormData> formData))constructingBodyBlock;
//}

@end

NS_ASSUME_NONNULL_END
