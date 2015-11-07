//
//  Number.m
//  Projects
//
//  Created by lt on 15/9/10.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "Number.h"

@implementation Number

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSNumber *muNum1 = [NSNumber numberWithDouble:12];
        NSNumber *muNum2 = [NSNumber numberWithInteger:12];
        NSLog(@"%s",muNum1.objCType);
        NSLog(@"%s",muNum2.objCType);
    }
    return self;
}

@end
