//
//  UIViewController+SelectRow.m
//  Projects
//
//  Created by lt on 15/9/14.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "UIViewController+SelectRow.h"
#import <objc/runtime.h>
#import "BaseController.h"
#import <UIKit/UITableView.h>
@implementation UIViewController (SelectRow)

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

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Protocol *pt = objc_getProtocol("UITableViewDelegate");
        SEL sel = NSSelectorFromString(@"tableView:didSelectRowAtIndexPath:");
        SEL newSel = NSSelectorFromString(@"replace_tableView:didSelectRowAtIndexPath:");
        int numClasses = objc_getClassList(NULL, 0);
        Class* list = (Class*)malloc(sizeof(Class) * numClasses);
        objc_getClassList(list, numClasses);
        for (int i = 0; i < numClasses; i++) {
            // 保证 响应该协议、响应该方法、是user类（保证系统类方法不被hook）
            if (class_conformsToProtocol(list[i], pt) &&
                class_getInstanceMethod(list[i], sel) &&
                [list[i] isSubclassOfClass:[BaseController class]]) {
                [list[i] swizzleSelector:sel withSel:newSel];
            }
        }
        
        Class cls = NSClassFromString(@"UIViewController");
        [cls swizzleSelector:@selector(viewWillAppear:) withSel:@selector(replace_viewWillAppear:)];
        [cls swizzleSelector:@selector(viewWillDisappear:) withSel:@selector(replace_viewWillDisappear:)];
        
        free(list);
    });
}

- (void)replace_viewWillDisappear:(BOOL)animate {
    fLog();
    [self replace_viewWillDisappear:animate];
}

- (void)replace_viewWillAppear:(BOOL)animate {
//    fLog();
    NSLog(@"%@,%@",self.class,NSStringFromSelector(_cmd));
    // 做一个配置文件。 把class 和  xxxpage 关联
    [self replace_viewWillAppear:animate];
}

- (void)replace_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    dLog(@"%@",cell.eventID);
    
    [self performSelector:@selector(replace_tableView:didSelectRowAtIndexPath:) withObject:tableView withObject:indexPath];
}

+ (IMP)swizzleSelector:(SEL)origSelector
               withSel:(SEL)newSel {
    Class cls = [self class];

    // orgin 原始imp
    Method origMethod = class_getInstanceMethod(cls, origSelector);
    
    // new  新的imp
    Method newMethod = class_getInstanceMethod(cls, newSel);
    
    if (newMethod && origMethod) {
        method_exchangeImplementations(origMethod, newMethod);
    }
    return NULL;
}

@end
