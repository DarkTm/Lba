//
//  DataBaseEngine.m
//  EZ
//
//  Created by lt on 14-7-29.
//  Copyright (c) 2014年 lt. All rights reserved.
//

#import "DataBaseEngine.h"
#import "WYDatabase.h"

@interface DataBaseEngine ()

@end

@implementation DataBaseEngine
+ (void)articleInsert:(NSArray *)sArray {
    
    if (!sArray.count) return;
    
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    [db createTableWithObj:[ArticleListObject class]];
    if (sArray.count) {
        for (ArticleListObject *object in sArray) {
            if (object.create_time.length >= 10) {
                object.create_time = [object.create_time substringToIndex:10];
            }
        }
        [db insertWithObjValue:sArray tableName:[ArticleListObject class] withKey:@"_id"];
    }
    [db close];
}

+ (void)articleUpdateRead:(NSString *)sId {
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    [db updateWithSql:[NSString stringWithFormat:@"update ArticleListObject set isRead = 1 where _id = '%@';",sId]];
    [db close];
}


+ (NSMutableArray *)articleQueryWithStart:(NSString *)start{
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    NSString *sql = [NSString stringWithFormat:@"select * from ArticleListObject where create_time = '%@';",start];
    NSMutableArray *rsult = [db queryObjWithClass:[ArticleListObject class] withSql:sql];
    [db close];
    return rsult;
 }

/*
+ (NSMutableArray *)notifyQueryWithStart:(NSInteger)start{
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    NSString *sql = [NSString stringWithFormat:@"select * from Notify;"];
    NSMutableArray *rsult = [db queryObjWithClass:[Notify class] withSql:sql ];
    [db close];
    return rsult;
}

+ (void)notifySetRead:(NSString *)_id {
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    [db updateWithSql:[NSString stringWithFormat:@"update Notify set isRead = 1 where _id = '%@';",_id]];
    [db close];
}

+ (NSMutableArray *)notifyFilter:(NSArray *)sArray {
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    NSString *sql = [NSString stringWithFormat:@"select * from Notify;"];
    NSMutableArray *rsult = [db queryObjWithClass:[Notify class] withSql:sql ];
    [db close];
    
    for (Notify *n in sArray) {
        for (Notify *m in rsult) {
            if ([m.isRead integerValue] == 1 && [m._id isEqualToString:m._id]) {
                n.isRead = @"1";
                break;
            }
        }
    }
    
    return [NSMutableArray arrayWithArray:sArray];
}

+ (void)lessionInsert:(NSArray *)sArray{
    
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];

    [db createTableWithObj:[Lession class]];
//    [db deleteWithSql:@"delete from Lession;"]; Modify by lt 2014-08-14
    
    for (int i = 0; i < sArray.count; i++) {
        Lession *ll = sArray[i];
        if(ll.res && ll.res.count){
            
            NSMutableArray *mA = [NSMutableArray array];
            for (Video *vi in ll.res) {
                NSDictionary *js = [vi dictFromObject];
                NSString *s = [js JSONString];
                [mA addObject:s];
            }
            ll.resString = [mA JSONString];
        }
    }
    [db insertWithObjValue:sArray tableName:[Lession class] withKey:@"_id"];
    [db close];
}
+ (NSMutableArray *)lessionQueryWithStart:(NSInteger)start{
    
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
//    NSString *sql = [NSString stringWithFormat:@"select * from Lession limit %d offset %d;",start + 20, start];
    NSString *sql = [NSString stringWithFormat:@"select * from Lession;"];
    NSMutableArray *rsult = [db queryObjWithClass:[Lession class] withSql:sql ];
    [db close];
    
    for (int i = 0; i < rsult.count; i++) {
        Lession *ll = rsult[i];
        if(ll.resString && ll.resString.length){
            NSArray *sA = [ll.resString objectFromJSONString];
            NSMutableArray *mA = [NSMutableArray array];
            for (NSString *dic in sA) {
                NSDictionary *sdic = [dic objectFromJSONString];
                Video *v = [[Video alloc] initWithReflectData:sdic];
                [mA addObject:v];
            }
            ll.res = mA;
        }
    }
    
    return rsult;
}

+ (void)lessionDeleteAll {
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    [db deleteWithSql:@"delete from Lession"];
    [db close];
}

+ (NSMutableArray *)lessionQueryWithStart{
    
    WYDatabase *db = [WYDatabase openDatabaseWitPath:[NSString databasePath]];
    NSString *sql = [NSString stringWithFormat:@"select * from Lession;"];
    NSMutableArray *rsult = [db queryObjWithClass:[Lession class] withSql:sql ];
    [db close];
    
    for (int i = 0; i < rsult.count; i++) {
        Lession *ll = rsult[i];
        if(ll.resString && ll.resString.length){
            NSArray *sA = [ll.resString objectFromJSONString];
            NSMutableArray *mA = [NSMutableArray array];
            for (NSString *dic in sA) {
                NSDictionary *sdic = [dic objectFromJSONString];
                Video *v = [[Video alloc] initWithReflectData:sdic];
                [mA addObject:v];
            }
            ll.res = mA;
        }
    }
    
    return rsult;
}
*/
@end
