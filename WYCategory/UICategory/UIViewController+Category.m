//
//  UIViewController+Category.m
//  HCC
//
//  Created by lt on 15/3/8.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

- (void)configureLeftBtn:(NSString *)ch en:(NSString *)en {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(-5, 2, 40, 40)];

    [btn setImage:[UIImage imageNamed:@"HCC_friend-sh_03"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(on_btn_back:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    UILabel *llen = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 4, CGRectGetWidth(v.frame) - CGRectGetMaxX(btn.frame), 15)];
    llen.font = [UIFont systemFontOfSize:12.0];
    llen.backgroundColor = [UIColor clearColor];
    llen.textColor = [UIColor whiteColor];
    llen.text = en;
    [v addSubview:llen];
    
    UILabel *llch = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 2 + CGRectGetMaxY(llen.frame), CGRectGetWidth(v.frame) - CGRectGetMaxX(btn.frame), 16)];
    llch.font = [UIFont systemFontOfSize:15.0];
    llch.backgroundColor = [UIColor clearColor];
    llch.textColor = [UIColor whiteColor];
    llch.text = ch;
    [v addSubview:llch];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:v];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)on_btn_back:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

+ (UIViewController *)getViewControllerWId:(NSString *)idt {
    return [self getViewControllerWsName:@"Main" wid:idt];
}

+ (UIViewController *)getViewControllerWsName:(NSString *)sName wid:(NSString *)idt {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sName bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:idt];
    return vc;
}


@end
