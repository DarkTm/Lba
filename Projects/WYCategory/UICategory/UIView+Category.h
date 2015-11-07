//
//  UIView+Corner.h
//  star
//
//  Created by lt on 15/3/11.
//  Copyright (c) 2015年 zxmeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WYQuickTipType) {
    WYQuickTipTypeLoading,
    WYQuickTipTypeSuccess,
    WYQuickTipTypeFailed,
    WYQuickTipTypePrompt,
    WYQuickTipTypeMax
};


@interface UIView (Category)

- (BOOL)haveSubview:(UIView*)subView;

@property (nonatomic, assign ) float x;
@property (nonatomic, assign ) float y;
@property (nonatomic, assign ) float w;
@property (nonatomic, assign ) float h;

- (void) showQuickTip:(WYQuickTipType)tipType msg:(NSString*)msg;
- (void) showQuickTip:(WYQuickTipType)tipType msg:(NSString*)msg autoHide:(BOOL)autoHide;
- (void) showQuickTip:(WYQuickTipType)tipType msg:(NSString*)msg delay:(CGFloat)delay callback:(void (^)())callback;
- (void) hideQuickTip;


- (void)maskViewWithImage:(UIImage *)image;

- (void)unmask;

@end

@interface UIView (Corner)

- (void)cornerRadius;

- (void)cornerWithRadius:(CGFloat)radius;

- (void)boarders;

- (void)boarderWithColor:(UIColor *)color;

- (void)boarderWithColor:(UIColor *)color wWidth:(CGFloat)width;

@end
