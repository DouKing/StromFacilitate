//
// StromFacilitate
// CornerRadiusViewController.m
// Created by DouKing (https://github.com/DouKing) on 2017/12/28.
// Copyright © 2017年 secoo. All rights reserved.

#import "CornerRadiusViewController.h"
#import "UIView+STM.h"

@interface CornerRadiusViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *v;

@end

@implementation CornerRadiusViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.imageView stm_drawCornerRadius:10];
  [self.v stm_drawCornerRadius:10];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
