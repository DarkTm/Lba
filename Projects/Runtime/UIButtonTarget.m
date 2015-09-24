//
//  UIButtonEventID.m
//  MagnetPF
//
//  Created by lt on 15/9/18.
//  Copyright © 2015年 dengjinxiang. All rights reserved.
//

#import "UIButtonTarget.h"

@implementation UIButtonTarget

+ (NSObject *)buttonEventID:(UIButton *)button {
   UIButtonTarget *be = [[UIButtonTarget alloc] init];
    [be buttonEventID:button];
    return be;
}

- (void)buttonEventID:(UIButton *)eventID {
    UIControlEvents event = eventID.allControlEvents;
    [eventID addTarget:self action:@selector(actionEventID:) forControlEvents:event];
}

- (void)actionEventID:(UIButton *)btn {
    if (btn.eventID.length) {
        
    }
}

- (void)dealloc {
    fLog();
}

@end
