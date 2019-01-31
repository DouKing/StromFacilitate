
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, STMHashType) {
    STMHashTypeMD5,         //返回 32 个字符
    STMHashTypeSHA1,        //     40
    STMHashTypeSHA256,      //     64
    STMHashTypeSHA512,      //     128
};


@interface NSString (STMHash)

- (nullable NSString *)stm_hashWithType:(STMHashType)type;
- (nullable NSString *)stm_hmacWithType:(STMHashType)type useKey:(NSString *)key;
- (nullable NSString *)stm_fileHashWithType:(STMHashType)type;

@end


NS_ASSUME_NONNULL_END
