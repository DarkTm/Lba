//
//  RuntimeController.m
//  Projects
//
//  Created by lt on 15/9/11.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "RuntimeController.h"
#import <objc/runtime.h>
#import <objc/objc.h>
@interface RuntimeController ()
<
UITableViewDataSource,
UITableViewDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;






@property (nonatomic, weak) NSString *weakString;
@end

@implementation RuntimeController

__weak NSString *string_weak_ = nil;


- (void)viewDidLoad {

    NSString *s = [NSString stringWithFormat:@"sdfsdlj"];
    string_weak_ = s;
    
    @autoreleasepool {
//        NSString *s = @"test string";
//        self.weakString = s;
    }
    dLog(@"%@",string_weak_);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        string_weak_ = @"test";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            string_weak_ = nil;
        });
    });
//    dLog(@"%@",self.weakString);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    dLog(@"%@",self.weakString);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    dLog(@"%@",self.weakString);
    dLog(@"%@",string_weak_);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    dLog(@"%@",self.weakString);
    dLog(@"%@",string_weak_);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    dLog(@"%@",self.weakString);
    dLog(@"%@",string_weak_);
}

- (void)dealloc {
//    dLog(@"%@",self.weakString);
    dLog(@"%@",string_weak_);
}
- (IBAction)actionBtn1:(id)sender {
    UIButton *btn = sender;
    btn.eventID = @"btn1";
    fLog();
}

- (IBAction)actionBtn2:(id)sender {
    UIButton *btn = sender;
    btn.eventID = @"btn2";

    fLog();
}


- (IBAction)actionBtn3:(id)sender {
    UIButton *btn = sender;
    btn.eventID = @"btn3";

    fLog();
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Runtime"];
    cell.eventID = @"Runtime";
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    fLog();
}
@end
