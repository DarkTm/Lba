//
//  ForwardingTarget.m
//  Projects
//
//  Created by lt on 15/9/9.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "ForwardingTarget.h"
#import <objc/runtime.h>

@implementation ForwardingTarget

void sayhello(id self, SEL _cmd) {
    NSLog(@"%s",__func__);
}

+ (BOOL)resolveClassMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    
    return [super resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    class_addMethod(self.class, sel, (IMP)sayhello, "v@:");
    
    BOOL rslt = [super resolveInstanceMethod:sel];
    
    rslt = YES;
    return rslt; // 1
}


- (id)forwardingTargetForSelector:(SEL)aSelector __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    id rslt = [super forwardingTargetForSelector:aSelector];
    return rslt; // 2
}
- (void)forwardInvocation:(NSInvocation *)anInvocation  {
    [super forwardInvocation:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector  {
    id rslt = [super methodSignatureForSelector:aSelector];
    return rslt; // 3
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector];
    
}

@end
