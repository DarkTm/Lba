//
//  TimerViewController.m
//  Projects
//
//  Created by Magnet on 15/6/22.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController () {
    NSTimer *timer;
}

@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dLog(@"1");
    // M1
//    [self performSelector:@selector(nslog) withObject:nil afterDelay:20];
    
    // M2
//    timer = [NSTimer scheduledTimerWithTimeInterval:116 target:self selector:@selector(nslog) userInfo:nil repeats:NO];

    
//    dispatch_async_repeated(3, dispatch_get_main_queue(), ^(BOOL *stop) {
//        dLog(@"");
//    });
    [[WYDelayGCD shareDelayGCD] startWithDelay:4 task:^{
        iLog();
    }];
    
    NSLog(@"2");
    
}
- (void)nslog {
    NSLog(@"%s",__func__);
}
//M1 && M2

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
//    // M2
//    if ([timer isValid]) {
//        [timer invalidate];
//    }
//    // M1
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[WYDelayGCD shareDelayGCD] cancel];
}


- (void)dealloc {
    // M2
//    timer = nil;
    NSLog(@"%s",__func__);
}
@end
