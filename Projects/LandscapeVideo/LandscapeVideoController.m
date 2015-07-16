//
//  LandscapeVideo.m
//  Projects
//
//  Created by lt on 15/7/16.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import "LandscapeVideoController.h"
#import "LandscapeVideoView.h"

@implementation LandscapeVideoController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    self.player.url = path;
    self.player.autorotation = YES;
    self.player.isLoop = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.player play];
}
- (IBAction)actionChange:(id)sender {
    [self.player rotation];
}

@end
