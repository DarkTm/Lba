//
//  UIScrollView+Touches.m
//  DuBai
//
//  Created by darktm on 14-3-20.
//  Copyright (c) 2014年 darktm. All rights reserved.
//

#import "UIScrollView+Touches.h"
#import "UIView+Category.h"

@implementation UIScrollView (Category)

- (void)scrollToView:(UIView *)v
{
    UIView *ogirinV = v;
    if ( v && [self haveSubview:v] )
    {
        while ( v && ![[v class] isSubclassOfClass:[self class]]) {
            v = v.superview;
        }
        
        if ( v )
        {
            [self scrollRectToVisible:[self convertRect:ogirinV.bounds fromView:ogirinV] animated:YES];
        }
    }
}

- (void)killScroll
{
    CGPoint offset = self.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
}


@end

@implementation UIScrollView (Touches)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

@end
