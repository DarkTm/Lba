//
//  WebJSController.m
//  Projects
//
//  Created by lt on 15/9/2.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "WebJSController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WebJSController ()
<
UIWebViewDelegate
>
@end

@implementation WebJSController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    dLog(@"%@",[self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]);
    NSURL *localURL= [NSURL URLWithString:@"http://activities.mangoplus.cn/test/default/index"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:localURL]];
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"ShareToTimeline"] = ^() {
        
        NSLog(@"Begin Log");
        NSArray *args = [JSContext currentArguments];
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal);
        }
        
        JSValue *this = [JSContext currentThis];
        NSLog(@"-------End Log-------");
        
    };
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        dLog(@"%@",exception);
    };
    
    [self performSelectorOnMainThread:@selector(sl) withObject:nil waitUntilDone:NO];
}

- (void)sl {
    sleep(2);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    sleep(1);
}

//- (BOOL)webView:(nonnull UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    dLog(@"%@",request);
//    return YES;
//}

@end
