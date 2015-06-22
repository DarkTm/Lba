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


static void dispatch_async_repeated_internal(dispatch_time_t firstPopTime, double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    __block BOOL shouldStop = NO;
    dispatch_time_t nextPopTime = dispatch_time(firstPopTime, (int64_t)(intervalInSeconds * NSEC_PER_SEC));
    dispatch_after(nextPopTime, queue, ^{
        work(&shouldStop);
        if(!shouldStop)
        {
            dispatch_async_repeated_internal(nextPopTime, intervalInSeconds, queue, work);
        }
    });
}

void dispatch_async_repeated(double intervalInSeconds, dispatch_queue_t queue, void(^work)(BOOL *stop))
{
    dispatch_time_t firstPopTime = dispatch_time(DISPATCH_TIME_NOW, intervalInSeconds * NSEC_PER_SEC);
    dispatch_async_repeated_internal(firstPopTime, intervalInSeconds, queue, work);
}

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
    dispatch_queue_t  queue = dispatch_queue_create("com.firm.app.timer", 0);

    dispatch_source_t timer1 = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer1, DISPATCH_TIME_NOW, 7 * NSEC_PER_SEC, 4 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer1, ^{
        dLog(@"1");
    });
    dispatch_resume(timer1);
    
    NSLog(@"2");
    
}
- (void)nslog {
    NSLog(@"%s",__func__);
}
//M1 && M2
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
    // M2
    if ([timer isValid]) {
        [timer invalidate];
    }
    // M1
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}
*/

- (void)dealloc {
    // M2
//    timer = nil;
    NSLog(@"%s",__func__);
}
@end
