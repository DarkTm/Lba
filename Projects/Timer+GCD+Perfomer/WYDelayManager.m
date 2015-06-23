//
//  WYDelayManager.m
//  Projects
//
//  Created by lt on 6/23/15.
//  Copyright (c) 2015 ikefou.com. All rights reserved.
//

#import "WYDelayManager.h"

@implementation WYDelayManager

@end


@interface WYDelayTimer()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) WYDelayTask taskBlock;
@end

@implementation WYDelayTimer

+ (instancetype)shareDelayTimer {
    static WYDelayTimer* sharedelay = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedelay = [[[self class] alloc] init];
    });
    return sharedelay;
}

- (void)startWithDelay:(NSTimeInterval)delay task:(WYDelayTask)task{
    [self startWithDelay:delay rpt:NO inteval:0 task:task];
}

- (void)startWithDelay:(NSTimeInterval)delay rpt:(BOOL)bRepeat inteval:(NSTimeInterval)inteval task:(WYDelayTask)task{
    self.timer= [NSTimer scheduledTimerWithTimeInterval:delay
             
                                             target:self
             
                                               selector:@selector(task)
             
                                               userInfo:@{@"repeat":@(bRepeat)}
             
                                            repeats:YES];
    self.taskBlock = task;
}

- (void)task {
    if (self.taskBlock) {
        self.taskBlock();
    }
    NSDictionary *userInfo = self.timer.userInfo;

    if (![userInfo[@"repeat"] boolValue]) {
        [self clear];
    }
}

- (void)cancel {
    [self clear];
}


- (void)clear {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }    
}
@end



@interface WYDelayGCD()
@property (nonatomic, assign) BOOL bEnd;
@property (nonatomic, assign) WYDelayTask taskBlock;
@property (nonatomic, strong) dispatch_source_t timer;
@end


@implementation WYDelayGCD

+ (instancetype)shareDelayGCD {
    static WYDelayGCD* sharedelay = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedelay = [[[self class] alloc] init];
    });
    return sharedelay;
}

- (void)startWithDelay:(NSTimeInterval)delay task:(WYDelayTask)task{
    self.bEnd = NO;
    self.taskBlock = task;
    __block int timeout = delay;
    NSThread *currentThread = [NSThread currentThread];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.timer, ^{
        
        if (self.bEnd) {
            [self class];
        }
        else {
            
            if(timeout <= 0){ //倒计时结束，关闭
                [self performSelector:@selector(task) onThread:currentThread withObject:nil waitUntilDone:NO];
            }
            else {
                timeout--;
            }
        }
    });
    dispatch_resume(_timer);
}

- (void)task {
    if (self.taskBlock) {
        self.taskBlock();
    }
    [self clear];
}

- (void)cancel {
    [self clear];
}

- (void)clear {
    self.bEnd = YES;
    self.taskBlock = NULL;
    self.timer = nil;
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}


@end