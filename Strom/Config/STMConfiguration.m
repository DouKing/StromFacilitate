//
//  STMConfiguration.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "STMConfiguration.h"

NSString * const STMDocumentPath() {
  return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

@implementation STMConfiguration
@end
