//
//  LandscapeVideoView.m
//  Projects
//
//  Created by lt on 15/7/16.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import "LandscapeVideoView.h"
@import AVFoundation;
#import <POP.h>

@interface LandscapeVideoView ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, weak  ) UIView        *vParent;
@property (nonatomic, assign) CGRect        orgRect;

@end

@implementation LandscapeVideoView

- (CGFloat)curPlayTime {
    return self.playerLayer.player.currentItem.currentTime.value;
}

- (instancetype)initWithFrame:(CGRect)frame wURL:(NSURL *)url {
    self = [super initWithFrame:frame];
    
    self.url = url;

    if (self) {
        [self setup];
    }
    
    return self;
}


- (void)setUrl:(NSURL *)url {
    _url = url;
    [self setup];
}

- (void)setAutorotation:(BOOL)autorotation {
    _autorotation = autorotation;
}

- (void)rotation {
    
    [self rotationWithAngle:M_PI_2];
}

- (void)play {
    [self.playerLayer.player play];
}

- (void)stop {
    [self.playerLayer.player pause];
}

- (void)pause {
    [self.playerLayer.player pause];
}


#pragma mark - Private

// 计算旋转角度
- (CGFloat)calcAngle {
/*
  // 计算当前view的旋转角度 M_PI_2
    CGAffineTransform transform = self.transform;
    CGFloat curAngle = atan2(transform.b, transform.a);
*/
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    switch (orientation) {
        case UIDeviceOrientationUnknown: {
            
            break;
        }
        case UIDeviceOrientationPortrait: {
            //0
            return 0;
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown: {
            return M_PI;
            break;
        }
        case UIDeviceOrientationLandscapeLeft: {
            return M_PI_2;
            break;
        }
        case UIDeviceOrientationLandscapeRight: {
            return -M_PI_2;
            break;
        }
        case UIDeviceOrientationFaceUp: {
            
            break;
        }
        case UIDeviceOrientationFaceDown: {
            
            break;
        }
        default: {
            break;
        }
    }
    
    return 0;
}

- (void)autoRotation {
    CGFloat angle = [self calcAngle];
    if (angle == 0.0f) {
        return;
    }
    [self rotationWithAngle:angle];
}

- (void)rotationWithAngle:(CGFloat)angle {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect frame  = CGRectMake(0, 0, size.height, size.width);
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = frame;
        self.center = [UIApplication sharedApplication].keyWindow.center;
        self.transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (void)awakeFromNib {
    
}

- (void)setup {
    
    self.backgroundColor = [UIColor blackColor];
    if (!self.url) {
        dLog(@"url not empty");
        return;
    }
    if (!self.playerLayer) {
        AVPlayer *player = [AVPlayer playerWithURL:self.url];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        self.playerLayer  = [AVPlayerLayer playerLayerWithPlayer:player];
        self.playerLayer.frame = self.bounds;
        [self.layer insertSublayer:self.playerLayer atIndex:UINT_MAX];
        // 设置 videoGravity 类型，撑满全屏或...

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerLayer.player.currentItem];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyOrientation:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    self.playerLayer.frame = self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        self.vParent = newSuperview;
        self.orgRect = self.frame;
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    if (self.isLoop) {
        AVPlayerItem *p = [notification object];
        [p seekToTime:kCMTimeZero];
    }
}

- (void)notifyOrientation:(NSNotification *)notify {

    if (self.autorotation) {
        [self autoRotation];
    }
}

@end
