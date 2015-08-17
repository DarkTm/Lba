//
//  UIView+Corner.m
//  star
//
//  Created by lt on 15/3/11.
//  Copyright (c) 2015年 zxmeng. All rights reserved.
//

#import "UIView+Corner.h"

@implementation UIView (Corner)

- (void) cornerRadius {
    self.layer.cornerRadius = 4.0f;
}

- (void)boarders {
    [self boarderWithColor:[UIColor lightTextColor]];
}

- (void)boarderWithColor:(UIColor *)color {
    [self boarderWithColor:color wWidth:1.0f];
}

- (void)boarderWithColor:(UIColor *)color wWidth:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}


@end
