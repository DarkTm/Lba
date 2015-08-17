//
//  NSObject+Reflect.m
//  TestProject
//
//  Created by 3TI on 13-12-1.
//  Copyright (c) 2013年 3TI. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>
#import "NSString+Category.h"

@implementation NSObject (Category)


@end


#pragma mark - reflect -

@implementation NSObject (reflect)

-(NSMutableArray *)getAttributeList{
    
    NSMutableArray *dictReturn = [[NSMutableArray alloc] initWithCapacity:10];
    
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([propertyName hasPrefix:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        [dictReturn addObject:propertyName];
    }
    free(vars);
    return dictReturn;
}


-(id)initWithReflectData:(NSDictionary *)aDic{
        
    unsigned int varCount;
    
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([propertyName hasPrefix:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        
        id value = aDic[propertyName];
        
        if ((![value isEqual:[NSNull class]]) && value) {
            
            if ([value isKindOfClass:[NSArray class]]
                || [value isKindOfClass:[NSDictionary class]]
                || [value isKindOfClass:[NSMutableArray class]]
                || [value isKindOfClass:[NSMutableDictionary class]]) {
                
                object_setIvar(self, var, value);
            }else{
                if ([value isEqual:[NSNull null]]) {
                    value = @"";
                }else if([value isKindOfClass:[NSString class]]){
                    if(!value){
                        value = @"";
                    }else if([value isEqualToString:@"<null>"]){
                        value = @"";
                    }
                }
                
                object_setIvar(self, var, [NSString stringWithFormat:@"%@",value]);
            }
    
        }else{
//            object_setIvar(self, var, [NSNull null]);
        }
    }
    free(vars);
    
    return self;
}

-(NSMutableDictionary *)dictFromObject {
    
    NSMutableDictionary *dictReturn = [[NSMutableDictionary alloc] init];
    
    unsigned int varCount;
    Ivar *vars = class_copyIvarList([self class], &varCount);
    
    for (unsigned int i = 0; i < varCount; i++) {
        Ivar var = vars[i];
        NSString *propertyName = [NSString stringWithFormat:@"%s",ivar_getName(var)];
        if ([propertyName hasPrefix:@"_"]) {
            propertyName =[propertyName substringWithRange:NSMakeRange(1, propertyName.length - 1)];
        }
        [dictReturn setValue:object_getIvar(self, var) forKey:propertyName];
    }
    free(vars);
    
//    NSLog(@"[%@] %s:%@",[self class],__func__, dictReturn);
    
    return dictReturn;
}

@end


#pragma mark - archiver -

@implementation NSObject (archiver)

+(id)unArchiverWithPath:(NSString *)path{
    
    NSAssert(path != nil && path.length != 0, @"path is not nil");
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    id archiverObj = [unArchiver decodeObjectForKey:[path md5]];
    
    [unArchiver finishDecoding];
    
    return archiverObj;
}

+(void)archiverWithObj:(id)obj withPath:(NSString *)path{
    
    if(obj == nil){
        
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        NSLog(@"%@ : because obj is nil , so remove file from %@",[self class],path);
        return;
    }
    
    NSMutableData *d = [NSMutableData data];
    
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:d];
    
    [archiver encodeObject:obj forKey:[path md5]];
    
    [archiver finishEncoding];
    
    [d writeToFile:path atomically:YES];
}

@end
