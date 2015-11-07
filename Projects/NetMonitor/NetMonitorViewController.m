//
//  NetMonitorViewController.m
//  Projects
//
//  Created by lt on 15/11/6.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "NetMonitorViewController.h"
#import "WYURLProtocol.h"

@interface NetMonitorViewController ()
<
NSURLConnectionDataDelegate,
NSURLConnectionDelegate
>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation NetMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [WYURLProtocol startNetMonitor];
    [[NSNotificationCenter defaultCenter] addObserverForName:WYURLProtocolNotifyConst object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        id obj = note.object;
        [self.webView loadHTMLString:[obj debugDescription] baseURL:nil];
    }];
//    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 280, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-64-280)];
//    [self.view addSubview:webView];
//    
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://image.baidu.com/"]]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]];
        [NSURLConnection connectionWithRequest:request delegate:self];
#pragma clang diagnostic pop
        
    });
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
