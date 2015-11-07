//
//  Father.m
//  Projects
//
//  Created by lt on 15/9/7.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "Father.h"
#import <objc/runtime.h>

@implementation Father

- (instancetype)init
{
    self = [super init];
    if (self) {
        @autoreleasepool {
            NSLog(@"tangwei");
        }
    }
    return self;
}

- (void)fuck:(NSString *)s {
    Method me = class_getInstanceMethod(self.class, _cmd);
    const char *ret = method_getTypeEncoding(me);
//    dLog(@"%s",ret);
//    dLog(@"%@",NSStringFromSelector(_cmd));
}

//
//+ (BOOL)resolveInstanceMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
//    //    class_addMethod(self.class, sel, (IMP)dynamicMethodIMP, "v@:");
//    
//    BOOL rslt = [super resolveInstanceMethod:sel];
//    
//    rslt = YES;
//    return rslt; // 1
//}
//
//- (id)forwardingTargetForSelector:(SEL)aSelector __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
//    id rslt = [super forwardingTargetForSelector:aSelector];
//    //    rslt = self.target;
//    return rslt; // 2
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE("") {
//    id rslt = [super methodSignatureForSelector:aSelector];
//    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    rslt = sig;
//    return rslt; // 3
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE("") {
//    [super forwardInvocation:anInvocation];
//}
//
//- (void)doesNotRecognizeSelector:(SEL)aSelector {
//    [super doesNotRecognizeSelector:aSelector]; // crash
//    
//}

@end
