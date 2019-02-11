//
// StromFacilitate
// NSBundle+STM.m
// Created by DouKing (https://github.com/DouKing) on 2017/11/27.
// Copyright © 2017年 DouKing. All rights reserved.

#import "NSBundle+STM.h"

@implementation NSBundle (STM)

+ (NSBundle *)stm_containerAppMainBundle {
  NSBundle *bundle = [NSBundle mainBundle];
  if ([[bundle.bundleURL pathExtension] isEqualToString:@"appex"]) {
    // Peel off two directory levels - MY_APP.app/PlugIns/MY_APP_EXTENSION.appex
    bundle = [NSBundle bundleWithURL:[[bundle.bundleURL URLByDeletingLastPathComponent] URLByDeletingLastPathComponent]];
  }
  return bundle;
}

@end
