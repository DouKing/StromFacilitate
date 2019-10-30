//
// StromFacilitate
// CornerRadiusViewController.m
// Created by DouKing (https://github.com/DouKing) on 2017/12/28.
// Copyright © 2017年 DouKing. All rights reserved.

#import "CornerRadiusViewController.h"
#import "UIView+STM.h"

@interface CornerRadiusViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *v;

@property (nullable, nonatomic, strong) UIImageView *cornerImageView1;
@property (nullable, nonatomic, strong) UIImageView *cornerImageView2;

@end

@implementation CornerRadiusViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.imageView addSubview:self.cornerImageView1];
  [self.v addSubview:self.cornerImageView2];
  self.cornerImageView1.image = [self.imageView stm_drawCornerRadii:CGSizeMake(10, 10)];
  self.cornerImageView2.image = [self.v stm_drawCornerRadii:CGSizeMake(10, 10) fillColor:self.view.backgroundColor];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.cornerImageView1.frame = self.imageView.bounds;
  self.cornerImageView2.frame = self.v.bounds;
}

- (UIImageView *)cornerImageView1 {
    if (!_cornerImageView1) {
        _cornerImageView1 = [[UIImageView alloc] init];
    }
    return _cornerImageView1;
}

- (UIImageView *)cornerImageView2 {
    if (!_cornerImageView2) {
        _cornerImageView2 = [[UIImageView alloc] init];
    }
    return _cornerImageView2;
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
