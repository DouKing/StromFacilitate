//
//  TextFieldViewController.m
//  StromFacilitate
//
//  Created by iosci on 2017/6/30.
//  Copyright © 2017年 secoo. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()

@end

@implementation TextFieldViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [self.view endEditing:YES];
}

@end
