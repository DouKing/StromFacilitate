//
//  TextFieldViewController.m
//  StromFacilitate
//
//  Created by iosci on 2017/6/30.
//  Copyright © 2017年 DouKing. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController ()

@end

@implementation TextFieldViewController

- (void)dealloc {
  NSLog(@"%s", __func__);
//  [self->testPerson stm_removeObserver:self forKeyPath:@"age"];
//  [self->testPerson stm_removeObserver:self forKeyPath:@"age"];
//  [self->testPerson stm_removeObserver:self forKeyPath:@"age"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
  if ([keyPath isEqualToString:@"age"]) {
    NSLog(@"person age change: %@", change);
  }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [self.view endEditing:YES];
}

@end
