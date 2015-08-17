//
//  NotifyController.m
//  Projects
//
//  Created by lt on 15/7/16.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import "NotifyController.h"

@implementation NotifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *a = [ NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        UILocalNotification *newNotification = [[UILocalNotification alloc] init];
        if (newNotification) {
            newNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:10+i];
            newNotification.alertBody = [NSString stringWithFormat:@"alert body %d",i];
            newNotification.timeZone = [NSTimeZone localTimeZone];
            newNotification.hasAction = NO;
            newNotification.soundName = UILocalNotificationDefaultSoundName;
            NSDictionary *userinfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @(i + 1000),          @"eventId",nil];
            newNotification.userInfo = userinfo;
            [a addObject:newNotification];
        }
    }
    
    [[UIApplication sharedApplication] setScheduledLocalNotifications:a];
    
}

@end
