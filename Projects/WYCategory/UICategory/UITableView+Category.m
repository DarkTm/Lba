//
//  UITableView+Category.m
//  Projects
//
//  Created by lt on 15/8/17.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import "UITableView+Category.h"
#import "UIView+Corner.h"

@implementation UITableView (Category)

- (void)scrollToView:(UIView *)v
{
    if ( v && [self haveSubview:v] )
    {
        while ( v && ![[v class] isSubclassOfClass:[self class]]) {
            v = v.superview;
        }
        
        if ( v )
        {
            UITableViewCell *cell = (UITableViewCell*)v;
            
            [self scrollToRowAtIndexPath:[self indexPathForRowAtPoint:cell.center] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

@end
