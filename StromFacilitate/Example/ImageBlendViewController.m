//
//  ImageBlendViewController.m
//  StromFacilitate
//
//  Created by iosci on 2017/3/8.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "ImageBlendViewController.h"
#import "UIImage+STM.h"

@interface ImageBlendViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;

@end

@implementation ImageBlendViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIImage *image1 = [UIImage imageNamed:@"img_star"];
  self.imageView1.image = image1;
  UIImage *image2 = [image1 stm_imageWithTintColor:[UIColor orangeColor]];
  self.imageView2.image = image2;
  UIImage *image3 = [image1 stm_imageWithGradientTintColor:[UIColor orangeColor]];
  self.imageView3.image = image3;
}


@end
