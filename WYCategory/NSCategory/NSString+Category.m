//
//  NSString+Category.m
//  WYNSCategory
//
//  Created by 3TI on 13-11-30.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "NSString+Category.h"
#import "NSData+Category.h"

#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation NSString (Category)
+ (NSString *)stringWithDate:(NSDate *)sDate formate:(NSString *)sFormate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:sFormate];
    NSString *rsult = [NSString stringWithFormat:@"%@", [formatter stringFromDate:sDate]];
    return rsult;
}
@end

#pragma mark - md5 -

@implementation NSString(md5)

- (NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

@end

#pragma mark - base64 -
@implementation NSString (base64)

- (NSData *)base64DecodedData{
    return [NSData dataWithBase64EncodedString:self];
}

- (NSString *)base64EncodedString{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

- (NSString *)base64DecodedString{
    return [NSString stringWithBase64EncodedString:self];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)string{
    NSData *data = [NSData dataWithBase64EncodedString:string];
    if (data)
    {
        return [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedStringWithWrapWidth:wrapWidth];
}

@end

#pragma mark - folder path -

@implementation NSString (path)

+(NSString *)getFolderWithType:(NSSearchPathDirectory)type{
    
    return [NSSearchPathForDirectoriesInDomains(type, NSUserDomainMask, YES) objectAtIndex:0];
}

@end


#pragma mark - json -

@implementation NSString (json)

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if ([object isKindOfClass:[NSNumber class]]) {
        
        const char * pObjCType = [object objCType];
        if (strcmp(pObjCType, @encode(BOOL)) == 0) {
            value = [object boolValue] ? @"1" : @"0";
        }
        else {
            value = object;
        }
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }else if([object isKindOfClass:[NSObject class]]){
        value = [NSString jsonStringWithCustom:object];
    }
    return value;
}

+(NSString *)jsonStringWithCustom:(id)object {
    NSString *value = nil;
    if (!object) {
        return value;
    }
    BOOL hasProperty = NO;
    
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    
    // get protocol property
    if (class_conformsToProtocol(class_getSuperclass([object class]), objc_getProtocol("DataPoolProtocol"))) {
        
        unsigned protocolPropertyCount = 0;
        objc_property_t *protocolProperties = protocol_copyPropertyList(objc_getProtocol("DataPoolProtocol"), &protocolPropertyCount);
        hasProperty = protocolPropertyCount > 0 ? YES : NO;
        
        for (int i = 0; i < protocolPropertyCount; i++) {
            objc_property_t property = protocolProperties[i];
            char *readonly = property_copyAttributeValue(property, "R");
            if (readonly)
            {
                free(readonly);
                continue;
            }
            
            NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
            id valueObj = [object valueForKey:propName];
            
            if (valueObj) {
                NSString *value = [NSString jsonStringWithObject:valueObj];
                if (value) {
                    [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",propName,value]];
                }
            }
        }
        free(protocolProperties);
    }
    
    // get class property
    unsigned propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList([object class], &propertyCount);
    hasProperty = (hasProperty || propertyCount > 0) ? YES : NO;
    
    for (int i = 0; i < propertyCount; i++) {
        objc_property_t property = properties[i];
        
        char *readonly = property_copyAttributeValue(property, "R");
        if (readonly)
        {
            free(readonly);
            continue;
        }
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id valueObj = [object valueForKey:propName];
        
        if (valueObj) {
            NSString *value = [NSString jsonStringWithObject:valueObj];
            if (value) {
                [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",propName,value]];
            }
        }
    }
    free(properties);
    
    if (hasProperty) {
        
        [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
        [reString appendString:@"}"];
        return reString;
    }
    
    return object;
}

@end


@implementation NSString (empty)

+ (BOOL)isEmptyOrNil:(NSString *)aS
{
    return (aS == nil || [aS isKindOfClass:[NSNull class]] || [[aS stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [aS length] == 0 );
}

@end