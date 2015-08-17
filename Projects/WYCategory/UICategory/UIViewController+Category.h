//
//  UIViewController+Category.h
//  HCC
//
//  Created by lt on 15/3/8.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

// 左边返回按钮，配上图片，类似android效果
- (void)configureLeftBtn:(NSString *)ch en:(NSString *)en;


// 默认 Main.storyboard
+ (UIViewController *)getViewControllerWId:(NSString *)idt;

+ (UIViewController *)getViewControllerWsName:(NSString*)sName wid:(NSString*) idt;


+ (UIViewController *)topViewController:(UIViewController *)rootViewController;
@end
