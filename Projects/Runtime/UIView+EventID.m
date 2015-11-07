//
//  UIView+EventID.m
//  Projects
//
//  Created by lt on 15/9/14.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "UIView+EventID.h"
#import <objc/runtime.h>
@implementation UIView (EventID)

- (NSString *)eventID {
    return (NSString *)(objc_getAssociatedObject(self, @selector(eventID)));
}

- (void)setEventID:(NSString *)eventID {
    // nil 过滤
    objc_setAssociatedObject(self, @selector(eventID), eventID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
