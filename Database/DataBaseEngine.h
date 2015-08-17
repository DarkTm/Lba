//
//  DataBaseEngine.h
//  EZ
//
//  Created by lt on 14-7-29.
//  Copyright (c) 2014年 lt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseEngine : NSObject

+ (void)articleInsert:(NSArray *)sArray;

+ (void)articleUpdateRead:(NSString *)sId;

+ (NSMutableArray *)articleQueryWithStart:(NSString *)start;
@end
