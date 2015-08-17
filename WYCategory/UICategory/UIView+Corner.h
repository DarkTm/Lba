//
//  UIView+Corner.h
//  star
//
//  Created by lt on 15/3/11.
//  Copyright (c) 2015年 zxmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Corner)

- (void)cornerRadius;

- (void)boarders;

- (void)boarderWithColor:(UIColor *)color;

- (void)boarderWithColor:(UIColor *)color wWidth:(CGFloat)width;

@end
