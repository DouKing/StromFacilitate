//
//  NSDictionary+STM.h
//  WYPersionalIdentity
//
//  Created by WuYikai on 16/3/30.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSDictionary<KeyType, ObjectType> (STM)

- (nullable NSDictionary *)stm_dictionaryBySettingObject:(ObjectType)anObject forKey:(KeyType<NSCopying>)aKey;
- (nullable NSDictionary *)stm_dictionaryByRemovingObjectForKey:(KeyType<NSCopying>)aKey;
- (nullable NSDictionary *)stm_dictionaryByAppendingDictionary:(NSDictionary<KeyType, ObjectType> *)dictionary;

@end


NS_ASSUME_NONNULL_END
