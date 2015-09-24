//
//  Watchdog.m
//  
//
//  Created by lt on 15/9/24.
//
//

#import "Watchdog.h"
#import <mach/mach_time.h>
#include <execinfo.h>
@import CFNetwork;

@interface Watchdog ()

@property (nonatomic, assign) CGFloat threshold;
@property (nonatomic, assign) CFRunLoopObserverRef observer;
@property (nonatomic, assign) UInt64 startTime;

@end


@implementation Watchdog

+ (instancetype)instance {
    return [[self alloc] initWithThreshold:0.2];
}

- (instancetype)initWithThreshold:(CGFloat) threshold {
    self = [super init];
    
    _threshold = threshold;
    _startTime = 0;
    
    _observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
            case kCFRunLoopBeforeTimers:
            case kCFRunLoopAfterWaiting:
            case kCFRunLoopBeforeSources: {
                if (self.startTime == 0) {
                    self.startTime = mach_absolute_time();
                }
                break;
            }
            case kCFRunLoopBeforeWaiting:
            case kCFRunLoopExit: {
                NSTimeInterval elapsed = mach_absolute_time() - self.startTime;
                NSTimeInterval duration = MachTimeToSecs(elapsed);
                if (duration > _threshold) {
                    NSLog(@"%.f",duration);
                    NSLog(@"%@",[NSThread callStackSymbols]);
                }
                else {
                    
                }
                self.startTime = 0;
                break;
            }
            case kCFRunLoopAllActivities:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    return self;
}


double MachTimeToSecs(uint64_t time)
{
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    return (double)time * (double)timebase.numer /
    (double)timebase.denom /1e9;
}

- (void)dealloc {
    fLog();
    CFRunLoopObserverInvalidate(self.observer);
}

@end
