//
//  ViewController.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "ViewController.h"
#import "NSString+STM.h"
#import "NSData+STM.h"
#import "UINavigationBar+STM.h"

static NSString * const kTableViewCellId = @"kTableViewCellId";

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
  return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Example";
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewCellId];
  STMLogObj(STMDocumentPath());
  [self example];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.navigationController.navigationBar.stm_hideBottomLine = YES;
}

- (void)example {
  [self example1];
  [self example2];
  [self example3];
  [self example4];
  [self example5];
  [self example6];
  [self example7];
}

- (void)example1 {
  NSMutableDictionary *dic = [@{
                                @"key1" : @"value1",
                                @"key2" : @"value2"
                                } mutableCopy];
  dic[@"a"] = @"1";
  dic[@"b"] = nil;
  dic[@"key1"] = nil;
  STMLogMethod();
  STMLogObj(dic);
}

- (void)example2 {
  NSMutableArray *array = [NSMutableArray array];
  [array addObject:@"A"];
  [array addObject:@"B"];
  [array addObject:@"C"];
  NSString *str = nil;
  [array addObject:str];
  STMLogMethod();
  STMLogObj(array);
}

- (void)example3 {
  NSDictionary *dic = @{@"k1" : @"v1"};
  STMLogMethod();
  STMLogObj(dic);
  dic = [dic stm_dictionaryByAppendingDictionary:@{@"key2" : @"value2"}];
  STMLogObj(dic);
}

- (void)example4 {
  NSString *obj1 = @"123";
  NSString *obj2 = @"456";
  NSDictionary *dic = @{@"key1" : obj1,
                        @"key2" : obj2};
  STMLogMethod();
  STMLogObj(dic);
}

- (void)example5 {
  NSString *obj1 = @"abc";
  NSString *obj2 = @"efg";
  NSString *obj3 = nil;
  NSString *obj4 = @"qwe";
  NSString *obj5 = @"asd";
  NSString *k5 = nil;
  NSDictionary *dic = @{@"k1" : obj1,
                        @"k2" : obj2,
                        @"k3" : obj3,
                        @"k4" : obj4,
                        k5 : obj5};
  STMLogMethod();
  STMLogObj(dic);
}

- (void)example6 {
  NSNumber *obj = nil;
  NSArray *arr = @[@1, @2, @3, @4, obj, @6];
  STMLogMethod();
  STMLogObj(arr);
}

- (void)example7 {
  // c0396401f0dcc443cfc7a460cab05d8ab2d366df458a913c40742c619b4a0795
  NSString *str = @"c0396401f0dcc443cfc7a460cab05d8ab2d366df458a913c40742c619b4a0795";
  STMLog(@"str: %@", str);
  NSData *data = [str stm_hexStringToData];
  STMLog(@"data: %@", data);
  NSString *str2 = [data stm_hexString];
  STMLog(@"str2: %@", str2);
  // <c0396401 f0dcc443 cfc7a460 cab05d8a b2d366df 458a913c 40742c61 9b4a0795>
}

TODO("测试TODO")
- (void)push {
  
}

@end
