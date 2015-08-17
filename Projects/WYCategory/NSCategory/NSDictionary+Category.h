//
//  NSDictionary+Category.h
//  WYCategory
//
//  Created by 3TI on 14-1-16.
//  Copyright (c) 2014年 qiaquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

@end



@interface NSDictionary (json)

+(NSDictionary *) jsonDictionaryWithObject:(id)object;

@end