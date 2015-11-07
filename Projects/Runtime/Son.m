//
//  RTTst.m
//  Projects
//
//  Created by lt on 15/9/7.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "Son.h"
#import <objc/runtime.h>
#import <objc/objc-class.h>
#import <objc/message.h>
#import "ForwardingTarget.h"
#import "Number.h"

@interface Son()

@property (strong) NSMutableArray *myDataArray;

@property (nonatomic, strong) NSString *myString;

@property (nonatomic, strong) ForwardingTarget *target;
@end

@implementation Son

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
      _myString = @"";
        [self halo:@"1" ws2:@"2"];
        [self halo2:@"1" ws2:@"2" i:1];
        [[Father new] fuck:nil];
        
        
//        NSNumber *myNumber = @(123);
        NSArray *myArray = @[@"1",@"2",@"4",@123];
    }
    _target = [ForwardingTarget new];
    [Number new];
//    class_addMethod(self.class, @selector(dynamicMethodIMP), (IMP)dynamicMethodIMP, NULL);
    [self performSelector:@selector(dynamicMethod) withObject:nil];


    return self;
}

+ (BOOL)resolveClassMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    
    return [super resolveClassMethod:sel];
}

id dynamicMethodIMP(id self, SEL _cmd)
{
    NSLog(@"蜗牛也疯狂");
    return @"1";

}

+ (BOOL)resolveInstanceMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
//    class_addMethod(self.class, sel, (IMP)dynamicMethodIMP, "v@:");
    
    BOOL rslt = [super resolveInstanceMethod:sel];
    
//    rslt = YES;
    return rslt; // 1
}

- (id)forwardingTargetForSelector:(SEL)aSelector __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0) {
    id rslt = [super forwardingTargetForSelector:aSelector];
//    rslt = self.target;
    return rslt; // 2
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector  {
    id rslt = [super methodSignatureForSelector:aSelector];
//    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes:"v@:"];
//    rslt = sig;
    return rslt; // 3
}

- (void)forwardInvocation:(NSInvocation *)anInvocation  {
    [self.target forwardInvocation:anInvocation];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    [super doesNotRecognizeSelector:aSelector]; // crash
    
}

- (void)halo:(NSString *)sa ws2:(NSString *)s2 {
    Method me = class_getInstanceMethod(self.class, _cmd);
    const char *ret = method_getTypeEncoding(me);
//    dLog(@"%s",ret);
//    dLog(@"%@",NSStringFromSelector(_cmd));

}

- (NSString *)halo2:(NSString *)sa ws2:(NSString *)s2 i:(int)s{

    Method me = class_getInstanceMethod(self.class, _cmd);
    const char *ret = method_getTypeEncoding(me);
//    dLog(@"%s",ret);
//    dLog(@"%@",NSStringFromSelector(_cmd));
    return nil;
}

@end
