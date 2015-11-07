//
//  UIView+Corner.m
//  star
//
//  Created by lt on 15/3/11.
//  Copyright (c) 2015年 zxmeng. All rights reserved.
//

#import "UIView+Category.h"
#import <MBProgressHUD.h>
#import "UIColor+Category.h"

@implementation UIView (Category)

- (float)x
{
    return self.frame.origin.x;
}

- (float)y
{
    return self.frame.origin.y;
}
- (float)w
{
    return self.frame.size.width;
}
- (float)h
{
    return self.frame.size.height;
}

-(void) setX:(float) newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

-(void) setY:(float) newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

-(void) setW:(float) newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

-(void) setH:(float) newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (BOOL)haveSubview:(UIView*)subView
{
    UIView *v = subView;
    
    while (v)
    {
        if ( self == v )
        {
            return YES;
        }
        
        v = v.superview;
    }
    
    return NO;
}

- (void)showQuickTip:(WYQuickTipType)tipType msg:(NSString *)msg
{
    [self showQuickTip:tipType msg:msg autoHide:YES];
}

- (void)showQuickTip:(WYQuickTipType)tipType msg:(NSString *)msg autoHide:(BOOL)autoHide
{
    [self showQuickTip:tipType msg:msg delay:autoHide?2:0 callback:nil];
}


- (void)showQuickTip:(WYQuickTipType)tipType msg:(NSString*)msg delay:(CGFloat)delay callback:(void (^)())callback
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    
    if ( (tipType==WYQuickTipTypeLoading) && (msg.length==0) )
    {
        msg = NSLocalizedString(@"common_waiting", @"");
    }
    
    if ( !hud )
    {
        hud = [[MBProgressHUD alloc] initWithView:self];
        hud.color = [UIColor colorWithLongHex:0x0000007F];
        [self addSubview:hud];
    }
    
    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = msg;
    
    
    if ( tipType == WYQuickTipTypeLoading )
    {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.frame = CGRectMake(0, 0, 80, 50);
        hud.customView = indicator;
        
        [indicator startAnimating];
    }
    else
    {
        NSArray *icon = @[@"",
                          @"Res/common/icon_success.png",
                          @"Res/common/icon_failed.png",
                          @""
                          ];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
        iv.contentMode = UIViewContentModeCenter;
        iv.image = [UIImage imageNamed:icon[tipType]];
        hud.customView = iv;
    }
    
    [hud show:YES];
    
    if ( delay > 0.0f )
    {
        [hud hide:YES afterDelay:delay];
        
        if ( callback )
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                callback();
            });
        }
    }
    
}

- (void)hideQuickTip
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    });
}

- (void)maskViewWithImage:(UIImage*)image
{
    if (image == nil) {
        return;
    }
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)image.CGImage;
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    maskLayer.contentsCenter = CGRectMake(0.45,0.75,0.1,0.1);
    maskLayer.frame = self.bounds;
    
    self.layer.masksToBounds = YES;
    self.layer.mask = maskLayer;
}

- (void)unmask {
    if (self.layer.mask) {
        self.layer.mask = nil;
    }
}


@end

@implementation UIView (Corner)

- (void) cornerRadius {
    [self cornerWithRadius:4.0f];
}

- (void)cornerWithRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)boarders {
    [self boarderWithColor:[UIColor lightTextColor]];
}

- (void)boarderWithColor:(UIColor *)color {
    [self boarderWithColor:color wWidth:0.5f];
}

- (void)boarderWithColor:(UIColor *)color wWidth:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.borderColor = [color CGColor];
}


@end
