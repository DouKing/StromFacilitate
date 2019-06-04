//
//  ViewController.m
//  StromFacilitate
//
//  Created by WuYikai on 16/4/1.
//  Copyright © 2016年 DouKing. All rights reserved.
//

#import "ViewController.h"
#import "Strom-header.h"

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

  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  button.frame = CGRectMake(0, 0, 22, 22);
  button.backgroundColor = [self.navigationController.navigationBar tintColor];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
  [button stm_addEventHandlerForControlEvents:UIControlEventTouchUpInside :^(id  _Nonnull sender) {
    STMLog(@"handle tap button 1");
  }];
  [button stm_addEventHandlerForControlEvents:UIControlEventTouchUpInside :^(id  _Nonnull sender) {
    STMLog(@"handle tap button 2");
  }];
  [button stm_addEventHandlerForControlEvents:UIControlEventTouchDown :^(id  _Nonnull sender) {
    STMLog(@"handle touch down");
  }];

  STMLogObj(STMDocumentPath());
  [self example];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.navigationController.navigationBar.stm_hideBottomLine = YES;
}

- (void)example {
    [self example:@"stm_dictionaryByAppendingDictionary:" :^{
        NSDictionary *dic = @{@"k1" : @"v1"};
        STMLogObj(dic);
        dic = [dic stm_dictionaryByAppendingDictionary:@{@"key2" : @"value2"}];
        STMLogObj(dic);
    }];
}

TODO("测试TODO")
- (void)example:(NSString *)name :(void (^)())block {
    if (!block) { return; }
    STMLogObj(name);
    block();
}

@end
