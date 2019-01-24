//
//  NSLayoutConstraint+STM.m
//  StromFacilitate
//
//  Created by DouKing on 2018/7/27.
//  Copyright © 2018 DouKing. All rights reserved.
//

#import "NSLayoutConstraint+STM.h"

@implementation NSLayoutConstraint (STM)

-(void)setPixel:(CGFloat)pixel {
  self.constant = pixel / [UIScreen mainScreen].scale;
}

- (CGFloat)pixel {
  return self.constant * [[UIScreen mainScreen] scale];
}

@end
