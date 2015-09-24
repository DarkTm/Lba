//
//  AppDelegate.m
//  Projects
//
//  Created by Magnet on 15/6/22.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import "AppDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Son.h"
#import "Watchdog.h"
@import AdSupport;
@interface AppDelegate ()
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) Watchdog *dog;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    dLog(@"%@",launchOptions);
    // Notify 测试
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    else {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];
    }
    
    if (launchOptions) {
        int tag = [launchOptions[@"eventId"] intValue];
        NSArray *notifyArray=[[UIApplication sharedApplication] scheduledLocalNotifications];
        if ([notifyArray count]) {
            for (int i = 0; i < notifyArray.count; i++) {
                UILocalNotification *location = notifyArray[i];
                NSDictionary *userInfo = location.userInfo;
                NSNumber *obj = userInfo[@"eventId"];
                int mytag = [obj intValue];
                if (mytag == tag) {
                    [[UIApplication sharedApplication] cancelLocalNotification:location];
                    break;
                }
            }
        }
    }

    //9536EA9C-7309-41C9-8838-3AC659C07993
    //F1E7A30D-4BAE-494D-919A-613504DD8EE8
    //845F1639-2D31-4A8C-99B7-3EF344DD793F
    //94415B81-AB08-45FA-B9AE-5B2353F080A6
    //6B5FABAA-847F-4ADA-8FDD-37BA37D060E4
    //30067A99-AC80-45DC-83F6-323D6B3D2DD3
    
    dLog(@"%@",[[[ASIdentifierManager alloc] advertisingIdentifier] UUIDString]);
//    Class asi = NSClassFromString(@"ASIdentifierManager");
//    Class a = objc_getClass("NSString");
//    Class asi = objc_getClass("ASIdentifierManager");
//    id instace = [[asi alloc] init];
//    id value = [instace performSelector:@selector(advertisingIdentifier) withObject:nil];
//    dLog(@"%@",value);

//    NSString *s = @"temp string";
//    self.temp = s;
//    NSMutableString *mS = [s mutableCopy];
//    NSString *sT = mS;
////    NSString *copys = [s copy];
//    dLog(@"%@,%@",s,self.temp);
//    dLog(@"%p,%p",s,self.temp);
//    dLog(@"%p,%p",&s,&_temp);
//    
//    
//    NSMutableString *mString = [NSMutableString stringWithString:@"mutable string"];
//    NSMutableString *mString2 = [mString mutableCopy];
//    NSString *string = [mString2 copy];
//    
//    NSMutableArray *mArray = [@[@"1",@"2",@"3"] mutableCopy];
//    NSMutableArray *mArrayCopy = [mArray mutableCopy];
//    NSMutableArray *mArrayStrong = mArrayCopy;
//    mArrayCopy[0]=@"6";
//    NSArray *arrayCopy = [mArray copy];
    

    // 分解umeng数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"umeng" ofType:@"txt"];
    NSData * d = [NSData dataWithContentsOfFile:path];
    NSString * s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    NSArray *a = [s componentsSeparatedByString:@"\r\n"];
    
    
    NSString *du = @",";
    NSMutableString *rslt = [NSMutableString string];
    
    for (NSString *srcs in a) {
        NSString *src = [srcs copy];
        // 清除 末尾 ','
        if ([src hasSuffix:@","]) {
            src = [src substringToIndex:src.length - 1];
        }

        // 清除 末尾 ',0'
        if ([src hasSuffix:@",0"]) {
            src = [src substringToIndex:src.length - 2];
        }
        
        // 清除 末尾 ',1'
        if ([src hasSuffix:@",1"]) {
            src = [src substringToIndex:src.length - 2];
        }
        
        if (src.length < 2) {
            continue;
        }
        
        src = [src stringByReplacingOccurrencesOfString:@"," withString:@",//"];
        
        NSRange range = [src rangeOfString:du];
        if (range.location != NSNotFound) {
            NSString *t1 = [src substringToIndex:range.location];
            t1 = [t1 capitalizedString];
            t1 = [NSString stringWithFormat:@"k%@",t1];
            
            NSString *t2 = [src substringToIndex:range.location];
            t2 = [NSString stringWithFormat:@"@\"%@\"",t2];
            
            
            NSString *t3 = [src substringWithRange:NSMakeRange(range.location + 1, src.length - range.location - 1)];
            [rslt appendString:@"#define "];
            [rslt appendString:t1];
            [rslt appendString:@"   "];
            [rslt appendString:t2];
            [rslt appendString:@"   "];
            [rslt appendString:t3];
            [rslt appendFormat:@"\n"];
        }
    }
    
//    NSString *old = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    NSString *newAgent =  [old stringByAppendingString:@"  MangoPlus"];
//    
//    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
//    [Son new];
//    NSLog(@"%lu",sizeof(8));
//    dLog(@"%f",FLT_MIN);
    
    
    Watchdog *dog = [[Watchdog alloc] initWithThreshold:0.2 handler:^{
        
    }];
    self.dog = dog;
    
    
    
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

@end
