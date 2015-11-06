//
//  WYURLProtocol.m
//  Projects
//
//  Created by lt on 15/11/6.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "WYURLProtocol.h"


NSString *const WYURLProtocolConst       = @"WYURLProtocolConst";
NSString *const WYURLProtocolNotifyConst = @"WYURLProtocolNotifyConst";

@interface WYURLProtocol ()
<
NSURLConnectionDelegate,
NSURLConnectionDataDelegate
>
@property (nonatomic, strong) NSURLResponse *rsp;
@property (nonatomic, strong) NSMutableData *rcvData;

@end

@implementation WYURLProtocol

+ (void)startNetMonitor {
    [NSURLProtocol registerClass:[WYURLProtocol class]];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 给需要检测的请求，添加检测
    // 不需要的直接返回return NO;
    if (0) {
        return NO;
    }
    if ([NSURLProtocol propertyForKey:WYURLProtocolConst inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *req = [request mutableCopy];
    if ([NSURLProtocol propertyForKey:WYURLProtocolConst inRequest:req]) {
        
    }
    else {
        [NSURLProtocol setProperty:@(YES) forKey:WYURLProtocolConst inRequest:req];
    }
    return [req copy];
}

- (void)startLoading {
    static NSOperationQueue *opq = nil;
    if (!opq) {
        opq = [NSOperationQueue new];
        opq.maxConcurrentOperationCount = 3;
    }

    if (![self rcvData]) {
        self.rcvData = [NSMutableData data];
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSURLRequest *request = [self.request copy];
    [NSURLConnection connectionWithRequest:request delegate:self];
#pragma clang diagnostic pop
    
}

- (void)stopLoading {
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[self client] URLProtocol:self didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.rsp = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
    [self.rcvData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
 
    [[self client] URLProtocolDidFinishLoading:self];
    [self finish];
}

- (void)finish {
    if (self.rcvData.length) {
        if ([self.rsp.MIMEType isEqualToString:@"application/json"]) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:WYURLProtocolNotifyConst
             object:[NSJSONSerialization JSONObjectWithData:self.rcvData options:NSJSONReadingAllowFragments error:nil]
             userInfo:nil];
        }
        else {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:WYURLProtocolNotifyConst
             object:[[NSString alloc] initWithData:self.rcvData encoding:NSUTF8StringEncoding]
             userInfo:nil];
        }
    }
}

@end
