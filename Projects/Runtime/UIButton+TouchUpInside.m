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
#import "UIButtonTarget.h"


@implementation UIButton (TouchUpInside)

- (void)setEventID:(NSString *)eventID {
    [super setEventID:eventID];
    if ([self isKindOfClass:[UIButton class]]) {
        self.eventTarge = [UIButtonTarget buttonEventID:self];
    }
}

- (void)setEventTarge:(NSObject *)eventTarge {
    objc_setAssociatedObject(self, @selector(eventTarge), eventTarge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject *)eventTarge {
    return objc_getAssociatedObject(self, @selector(eventTarge));
}

@end
