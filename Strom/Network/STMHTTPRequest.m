//
//  STMHTTPRequest.m
//  StromFacilitate
//
//  Created by DouKing on 2019/1/30.
//  Copyright © 2019 DouKing. All rights reserved.
//

#import "STMHTTPRequest.h"
#import "STMProxy.h"
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation AFHTTPSessionManager (STMHTTPRequest)

+ (instancetype)sharedManager {
  static AFHTTPSessionManager *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [AFHTTPSessionManager manager];
    [_sharedInstance _configure];
  });
  return _sharedInstance;
}

- (void)_configure {
  self.responseSerializer.acceptableContentTypes =
  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", nil];
}

@end

@interface STMHTTPMultipartFormDataProxy : STMProxy<STMMultipartFormData>
@end

#pragma mark -

@interface STMHTTPRequest ()

@property (nullable, nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation STMHTTPRequest

- (void)dealloc {
    #if DEBUG
    NSLog(@"%s", __FUNCTION__);
    #endif
    if ([self autoStopWhenDealloc]) {
        [self stop];
    }
}

- (instancetype)init {
    if (self = [super init]) {
        _httpSessionManager = [AFHTTPSessionManager sharedManager];
    }
    return self;
}

#pragma mark - Public

- (void)start {
    NSURL *baseURL = [NSURL URLWithString:self.baseURL ?: @""];
    NSURL *URL = [NSURL URLWithString:self.requestPath ?: @"" relativeToURL:baseURL];
    if (!URL) {
        return;
    }

    __weak typeof(self) __weak_self__ = self;
    void (^downloadProgress)(NSProgress *) = ^(NSProgress *downloadProgress) {
        __strong typeof(__weak_self__) self = __weak_self__;
        if ([self.delegate respondsToSelector:@selector(httpRequest:isInProgress:)]) {
            [self.delegate httpRequest:self isInProgress:downloadProgress];
        }
    };

    void (^success)(NSURLSessionDataTask *task, id) = ^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        __strong typeof(__weak_self__) self = __weak_self__;
        if (![responseObject isKindOfClass:NSDictionary.class]) {
            if ([self.delegate respondsToSelector:@selector(httpRequest:didFailureWithError:)]) {
                [self.delegate httpRequest:self didFailureWithError:[NSError errorWithDomain:@"接口返回数据格式不正确" code:0 userInfo:nil]];
            }
            return;
        }
        _responseObject = responseObject;
        if ([self.delegate respondsToSelector:@selector(httpRequestDidSuccess:)]) {
            [self.delegate httpRequestDidSuccess:self];
        }
    };

    void (^headSuccess)(NSURLSessionDataTask *task) = ^(NSURLSessionDataTask *task) {
        __strong typeof(__weak_self__) self = __weak_self__;
        if ([self.delegate respondsToSelector:@selector(httpRequestDidSuccess:)]) {
            [self.delegate httpRequestDidSuccess:self];
        }
    };

    void (^failure)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        __strong typeof(__weak_self__) self = __weak_self__;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if ([self.delegate respondsToSelector:@selector(httpRequest:didFailureWithError:)]) {
            [self.delegate httpRequest:self didFailureWithError:error];
        }
    };

    [self stop];
    NSString *URLString = URL.absoluteString;
    NSDictionary *parameters = self.requestParameters;
    switch (self.requestMethod) {
        case STMHTTPRequestMethodGET: {
             _currentDataTask = [self.httpSessionManager GET:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
        } break;
        case STMHTTPRequestMethodPOST: {
            void (^constructingBodyBlock)(id<STMMultipartFormData> formData) = self.constructingBodyBlock;
            if (constructingBodyBlock) {
                _currentDataTask = [self.httpSessionManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    STMHTTPMultipartFormDataProxy *proxy = [STMHTTPMultipartFormDataProxy proxyWithTarget:formData];
                    constructingBodyBlock(proxy);
                } progress:downloadProgress success:success failure:failure];
            } else {
                _currentDataTask = [self.httpSessionManager POST:URLString parameters:parameters progress:downloadProgress success:success failure:failure];
            }
        } break;
        case STMHTTPRequestMethodPUT: {
            _currentDataTask = [self.httpSessionManager PUT:URLString parameters:parameters success:success failure:failure];
        } break;
        case STMHTTPRequestMethodHEAD: {
            _currentDataTask = [self.httpSessionManager HEAD:URLString parameters:parameters success:headSuccess failure:failure];
        } break;
        case STMHTTPRequestMethodDELETE: {
            _currentDataTask = [self.httpSessionManager DELETE:URLString parameters:parameters success:success failure:failure];
        } break;
    }
}

- (void)stop {
    [self.currentDataTask cancel];
}

#pragma mark - subclass override

- (BOOL)autoStopWhenDealloc {
    return YES;
}

- (NSString *)baseURL {
    return nil;
}

- (NSString *)requestPath {
    return nil;
}

- (nullable NSDictionary *)requestParameters {
    return nil;
}

- (STMHTTPRequestMethod)requestMethod {
    return STMHTTPRequestMethodGET;
}

- (void (^ _Nullable)(id<STMMultipartFormData> formData))constructingBodyBlock {
    return nil;
}

#pragma mark - setter & getter

- (NSURLSession *)session {
    return self.httpSessionManager.session;
}

@end

#pragma mark -

@implementation STMHTTPMultipartFormDataProxy

- (void)forwardInvocation:(NSInvocation *)invocation {
    [super forwardInvocation:invocation];
}

@end

