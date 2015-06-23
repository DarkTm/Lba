//
//  WYDelayManager.h
//  Projects
//
//  Created by lt on 6/23/15.
//  Copyright (c) 2015 ikefou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WYDelayTask)(void);


@protocol WYDelayProtol <NSObject>

@required

- (void)startWithDelay:(NSTimeInterval)delay task:(WYDelayTask)task;

- (void)cancel;


@optional

- (void)startWithDelay:(NSTimeInterval)delay rpt:(BOOL)bRepeat inteval:(NSTimeInterval)inteval task:(WYDelayTask)task;

@end

@interface WYDelayManager : NSObject

@end



/**
 *  NSTimer 实现延迟执行任务
 */
@interface WYDelayTimer : NSObject <WYDelayProtol>

+ (instancetype)shareDelayTimer;

@end

@interface WYDelayGCD : NSObject <WYDelayProtol>

+ (instancetype)shareDelayGCD;

@end