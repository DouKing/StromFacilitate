//
//  STMConfiguration.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "STMConfiguration.h"

NSString * const STMDocumentPath() {
  return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

NSString * const STMAppVersion() {
  return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

NSString * const STMSystemVersion() {
  return [[UIDevice currentDevice] systemVersion];
}

BOOL STMSystemVersionEqualTo(NSString *version) {
  return [STMSystemVersion() compare:version options:NSNumericSearch] == NSOrderedSame;
}

BOOL STMSystemVersionGreaterThan(NSString *version) {
  return [STMSystemVersion() compare:version options:NSNumericSearch] == NSOrderedDescending;
}

BOOL STMSystemVersionGreaterThanOrEqualTo(NSString *version) {
  return [STMSystemVersion() compare:version options:NSNumericSearch] != NSOrderedAscending;
}

BOOL STMSystemVersionLessThan(NSString *version) {
  return [STMSystemVersion() compare:version options:NSNumericSearch] == NSOrderedAscending;
}

BOOL STMSystemVersionLessThanOrEqualTo(NSString *version) {
  return [STMSystemVersion() compare:version options:NSNumericSearch] != NSOrderedDescending;
}

BOOL STMSystemVersionIOS7Later() {
  return STMSystemVersionGreaterThanOrEqualTo(@"7.0");
}

BOOL STMSystemVersionIOS8Later() {
  return STMSystemVersionGreaterThanOrEqualTo(@"8.0");
}

BOOL STMSystemVersionIOS9Later() {
  return STMSystemVersionGreaterThanOrEqualTo(@"9.0");
  
}

@implementation STMConfiguration
@end
