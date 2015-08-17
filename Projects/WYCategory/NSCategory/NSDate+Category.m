//
//  NSDate+Category.m
//  Projects
//
//  Created by lt on 15/8/17.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

- (NSString*) formatterWithString:(NSString*)dateFormat {
    
    
    static NSDateFormatter *formatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !formatter ) {
            formatter = [[NSDateFormatter alloc] init];
        }
    });
    
    [formatter setDateFormat:dateFormat];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}


- (NSDate *) dateByAddingDays: (NSInteger) iTime {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + iTime;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

@end
