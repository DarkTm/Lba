//
//  UIViewController+SelectRow.m
//  Projects
//
//  Created by lt on 15/9/14.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "UIViewController+Umeng.h"
#import <objc/runtime.h>
#import "BaseController.h"
#import <UIKit/UITableView.h>
@implementation UIViewController (Umeng)

/*
static void MySetFrame(id self, SEL _cmd, CGRect frame);
static void (*SetFrameIMP)(id self, SEL _cmd, CGRect frame);


static void MySetFrame(id self, SEL _cmd, CGRect frame) {
    // do custom work
    SetFrameIMP(self, _cmd, frame);
}

typedef IMP *IMPPointer;

BOOL class_swizzleMethodAndStore(Class class, SEL original, IMP replacement, IMPPointer store) {
    IMP imp = NULL;
    Method method = class_getInstanceMethod(class, original);
    if (method) {
        const char *type = method_getTypeEncoding(method);
        imp = class_replaceMethod(class, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) { *store = imp; }
    return (imp != NULL);
}

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMPPointer)store {
    return class_swizzleMethodAndStore(self, original, replacement, store);
}
*/


- (NSString *)eventID {
    return (NSString *)(objc_getAssociatedObject(self, @selector(eventID)));
}

- (void)setEventID:(NSString *)eventID {
    objc_setAssociatedObject(self, @selector(eventID), eventID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        该段代码是用来hook didSelectRowAtIndexPath 方法的  不要删。。。
//        还需要做子类是否响应改delegate！！！！！！！
        Protocol *pt = objc_getProtocol("UITableViewDelegate");
        SEL sel = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
        SEL newSel = NSSelectorFromString(@"replace_tableView:didSelectRowAtIndexPath:");
        
        int numClasses = objc_getClassList(NULL, 0);
        Class* list = (Class*)malloc(sizeof(Class) * numClasses);
        objc_getClassList(list, numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class cls = list[i];
            if (!class_getSuperclass(cls)) {
                continue;
            }
            // 保证 响应该协议、响应该方法、是user类（子类）（保证系统类方法不被hook）
            if ([cls isSubclassOfClass:[BaseController class]]) {
                while (cls && ![NSStringFromClass(cls) isEqualToString:NSStringFromClass([BaseController class])]) {
                    if (class_conformsToProtocol(list[i], pt) &&
                        class_getInstanceMethod(list[i], sel) ) {
                        [list[i] swizzleSelector:sel withSel:newSel];
                        break;
                    }
                    cls = class_getSuperclass(cls);
                }
            }
        }
        free(list);
        [UIViewController swizzleSelector:@selector(viewWillAppear:) withSel:@selector(replace_viewWillAppear:)];
        [UIViewController swizzleSelector:@selector(viewWillDisappear:) withSel:@selector(replace_viewWillDisappear:)];
    });
}

- (void)replace_viewWillDisappear:(BOOL)animate {
    if (self.eventID.length) {
    }
    [self replace_viewWillDisappear:animate];
}

- (void)replace_viewWillAppear:(BOOL)animate {
    if (self.eventID.length) {
    }
    [self replace_viewWillAppear:animate];
}

- (void)replace_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.eventID.length) {
        dLog(@"%@",cell.eventID);
    }
    [self replace_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

+ (void)swizzleSelector:(SEL)origSelector
               withSel:(SEL)newSel {
    Class cls = [self class];
    NSLog(@"%@",cls);
    Method origMethod = class_getInstanceMethod(cls, origSelector);
    Method newMethod = class_getInstanceMethod(cls, newSel);    
    if (newMethod && origMethod) {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

@end
