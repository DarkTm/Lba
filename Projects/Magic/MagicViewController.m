//
//  MagicViewController.m
//  Projects
//
//  Created by lt on 16/8/1.
//  Copyright © 2016年 ikefou.com. All rights reserved.
//

#import "MagicViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MagicViewController ()

@end

@implementation MagicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionSound:(id)sender {
    // 无用
    AudioServicesPlaySystemSound(1521);
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
