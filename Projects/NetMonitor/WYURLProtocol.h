//
//  WYURLProtocol.h
//  Projects
//
//  Created by lt on 15/11/6.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const WYURLProtocolNotifyConst;

@interface WYURLProtocol : NSURLProtocol
+ (void)startNetMonitor;
@end
