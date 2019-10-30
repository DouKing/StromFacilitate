//
//  ImageBlendViewController.m
//  StromFacilitate
//
//  Created by iosci on 2017/3/8.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "ImageBlendViewController.h"
#import "UIImage+STM.h"
#import "UIGestureRecognizer+STM.h"

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

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] stm_initWithHandler:^(__kindof UIGestureRecognizer * _Nonnull sender) {
    STMLog(@"gesture tap 1");
  }];
  [tap stm_addHandler:^(__kindof UIGestureRecognizer * _Nonnull sender) {
    STMLog(@"gesture tap 2");
  }];
  [tap stm_addDeallocExecutor:^(__unsafe_unretained id  _Nonnull owner, NSUInteger identifier) {
    STMLog(@"gesture dealloc");
  }];
  [self.view addGestureRecognizer:tap];

  [self.view stm_addTapGestureRecognizer:^(UITapGestureRecognizer * _Nonnull gestureRecognizer) {
    gestureRecognizer.numberOfTapsRequired = 2;
    //[tap requireGestureRecognizerToFail:gestureRecognizer];
  } actionHandler:^(UITapGestureRecognizer * _Nonnull gestureRecognizer) {
    STMLog(@"双击");
  }];
}


@end
