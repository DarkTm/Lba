//
//  BaseController.m
//  Projects
//
//  Created by lt on 15/9/14.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()
<
UITableViewDataSource,
UITableViewDelegate
>
@end

@implementation BaseController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
