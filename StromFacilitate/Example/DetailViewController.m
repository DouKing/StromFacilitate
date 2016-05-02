//
//  DetailViewController.m
//  StromFacilitate
//
//  Created by WuYikai on 16/5/1.
//  Copyright © 2016年 secoo. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
  self.navigationItem.leftBarButtonItem = back;
}

- (void)back {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
