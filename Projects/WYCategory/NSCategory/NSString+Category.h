//
//  NSString+Category.h
//  WYNSCategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
+ (NSString *)stringWithDate:(NSDate *)sDate formate:(NSString *)sFormate;
- (NSString *) URLEncodingUTF8String;//编码
- (NSString *) URLDecodingUTF8String;//解码

@end


@interface NSString(md5)

- (NSString *) md5;
- (NSString *) AES;
@end


@interface NSString(base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end


@interface NSString (path)

+(NSString *)getFolderWithType:(NSSearchPathDirectory)type;

@end


@interface NSString (json)

+ (NSString *) jsonStringWithObject:(id)object;

@end

@interface NSString (empty)
+ (BOOL)isEmptyOrNil:(NSString *)aS;
@end