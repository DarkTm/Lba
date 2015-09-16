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
    
    
}

@end
