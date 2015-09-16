//
//  UIButton+TouchUpInside.m
//  Projects
//
//  Created by lt on 15/9/11.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "UIButton+TouchUpInside.h"
#import <objc/runtime.h>
#import "UIView+EventID.h"

@implementation UIButton (TouchUpInside)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

/*
 1、点击事件
 2、点击按钮后，成功或失败事件
 */
- (void)sendAction:(SEL)action to:( id)target forEvent:(UIEvent *)event
{
    UIControlState state = self.state;
    UIControlEvents events = self.allControlEvents;
    if (state == UIControlStateHighlighted && (events & UIControlEventTouchUpInside)) {
        if (self.eventID.length) {
            // 做事件处理
            
        }
        else {
            
        }
    }
}


- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    fLog();
}
@end
