//
//  LandscapeVideo.m
//  Projects
//
//  Created by lt on 15/7/16.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import "LandscapeVideoController.h"
#import "LandscapeVideoView.h"
#import <UIImage+GIF.h>

@implementation LandscapeVideoController


- (void)awakeFromNib {
    
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

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
    [self.ivGif removeFromSuperview];
//    self.ivGif.image = [UIImage sd_animatedGIFNamed:@"test"];
    
}

- (IBAction)actionChange:(id)sender {
    [self.player rotation];
}

@end
