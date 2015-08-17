//
//  UIResponder+Category.h
//  Projects
//
//  Created by lt on 15/8/17.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Category)

- (id)currentFirstResponder;

+(void) cacheKeyboard;
+(void) cacheKeyboard:(BOOL)onNextRunloop;


@end
