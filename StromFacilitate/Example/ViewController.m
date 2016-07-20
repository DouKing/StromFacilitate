//
//  ViewController.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

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
  [self example5];
  [self example6];
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
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
  btn.frame = CGRectMake(10, 64, 100, 40);
  btn.backgroundColor = [UIColor yellowColor];
  [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btn];
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

- (void)push {
  DetailViewController *vc = [[DetailViewController alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
