//
//  LandscapeVideoView.h
//  Projects
//
//  Created by lt on 15/7/16.
//  Copyright (c) 2015年 ikefou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LandscapeVideoView : UIView

@property (nonatomic, copy            ) NSURL   *url;
@property (nonatomic, assign, readonly) CGFloat curPlayTime;
@property (nonatomic, assign          ) BOOL    autorotation;
@property (nonatomic, assign          ) BOOL    isLoop;

- (void)play;
- (void)stop;
- (void)pause;

/**
 *  旋转m_pi_2
 */
- (void)rotation;

@end
