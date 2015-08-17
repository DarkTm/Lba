//
//  UIResponder+Category.m
//  Projects
//
//  Created by lt on 15/8/17.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "UIResponder+Category.h"


#import <objc/runtime.h>

static char *WYFirstResponderKey = "WYFirstResponderKey";


static BOOL hasAlreadyCachedKeyboard;
static __weak id currentFirstResponder;

@interface UIResponder (KeyboardCache_Private)
+(void) __cacheKeyboard;
@end

@implementation UIResponder (Category)


- (id)currentFirstResponder {
    [UIApplication.sharedApplication sendAction:@selector(findFirstResponder:)
                                             to:nil from:self forEvent:nil];
    id obj = objc_getAssociatedObject(self, WYFirstResponderKey);
    objc_setAssociatedObject(self, WYFirstResponderKey, nil, OBJC_ASSOCIATION_ASSIGN);
    return obj;
}

- (void)setCurrentFirstResponder:(id)responder {
    objc_setAssociatedObject(self, WYFirstResponderKey, responder,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (void)findFirstResponder:(id)sender {
    [sender setCurrentFirstResponder:self];
}


+(void) cacheKeyboard {
    [[self class] cacheKeyboard:NO];
}

+(void) cacheKeyboard:(BOOL)onNextRunloop {
    if (! hasAlreadyCachedKeyboard)
    {
        hasAlreadyCachedKeyboard = YES;
        if (onNextRunloop)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0), dispatch_get_main_queue(), ^(void){ [[self class] __cacheKeyboard]; });
        else
            [[self class] __cacheKeyboard];
    }
}

+(void) __cacheKeyboard {
    UITextField *field = [UITextField new];
    [[[[UIApplication sharedApplication] windows] lastObject] addSubview:field];
    [field becomeFirstResponder];
    [field resignFirstResponder];
    [field removeFromSuperview];
}

@end
