//
//  PathAnimationController.m
//  Projects
//
//  Created by lt on 15/9/15.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "PathAnimationController.h"
#import "PathAnimationView.h"
#import "UIView+Category.h"
#import <FBShimmeringView.h>

@implementation PathAnimationController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.containerView.backgroundColor = [UIColor darkGrayColor];
    PathAnimationView *p  = [PathAnimationView new];
    
    p.x = 100.0f;
    p.y = 100.0f;
    p.w = 80.0f;
    p.h = 80.0f;
    [self.containerView addSubview:p];
    [p startAllAnimations:nil];
    
    if ([p isDescendantOfView:self.containerView]) {
        fLog();
    }
    else {
        fLog()
    }

    if ([p isDescendantOfView:self.view]) {
        fLog();
    }
    else {
        fLog()
    }

    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 20)];
    lbl.text = @"他家里SD卡放假受得了副科级水电费";
    lbl.textColor = [UIColor redColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lbl];
    
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    UIColor *maskedColor = [UIColor colorWithWhite:1.0 alpha:1];
    UIColor *unmaskedColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    maskLayer.colors = @[(__bridge id)maskedColor.CGColor, (__bridge id)unmaskedColor.CGColor, (__bridge id)maskedColor.CGColor];
    maskLayer.locations = @[@(0),
                            @(0.5),
                            @(1.0 )];
//    maskLayer.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:1].CGColor;
    maskLayer.frame = CGRectInset(lbl.bounds, 100, 0);
    maskLayer.opacity = 0.8;
    maskLayer.startPoint = CGPointMake(0, 0);
    maskLayer.endPoint = CGPointMake(1, 1);
    lbl.layer.mask = maskLayer;
    
//    FBShimmeringView *view = [[FBShimmeringView alloc] initWithFrame:CGRectMake(000, 100, 300, 20)];
//    view.contentView = lbl;
//    view.shimmering = 1;
//    view.shimmeringSpeed = 10;
////    view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////        view.shimmering = 0;
//    });
    
}

@end
