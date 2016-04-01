//
//  ViewController.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Example";
  
  self.view.backgroundColor = [UIColor stm_colorWithRGBValue:0xFFFFFF];
  STMLogObj(STMDocumentPath());
  
  [self example1];
  [self example2];
  [self example3];
  [self example4];
}

- (void)example1 {
  NSMutableDictionary *dic = [@{
                                @"key1" : @"value1",
                                @"key2" : @"value2"
                                } mutableCopy];
  dic[@"a"] = @"1";
  dic[@"b"] = nil;
  dic[@"key1"] = nil;
  STMLogObj(dic);
}

- (void)example2 {
  NSMutableArray *array = [NSMutableArray array];
  [array addObject:@"A"];
  [array addObject:@"B"];
  [array addObject:@"C"];
  NSString *str = nil;
  [array addObject:str];
  STMLogObj(array);
}

- (void)example3 {
  
}

- (void)example4 {
  
}

@end
