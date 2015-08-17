//
//  NSDate+Category.h
//  Projects
//
//  Created by lt on 15/8/17.
//  Copyright © 2015年 ikefou.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

- (NSString*) formatterWithString:(NSString*)dateFormat;

- (NSDate *) dateByAddingDays: (NSInteger) iTime;
@end
