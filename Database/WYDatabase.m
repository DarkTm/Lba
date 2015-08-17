//
//  WYDatabase.m
//  WYCategory
//
//  Created by tom on 13-12-5.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import "WYDatabase.h"

@interface WYDatabase()

/**
 *  执行sql
 *
 *  @param aSql update delete insert sql
 *
 *  @return 操作是否正常
 */
-(BOOL)executeWithSql:(NSString *)aSql;

/**
 *  数据转换
 *
 *  @param pChar char类型字符串
 *
 *  @return NSString类型字符串
 */
-(NSString *)converCharToString:(char *)pChar;

/**
 *  查询结果
 *
 *  @param aSql   sql
 *  @param aClass 类名 (表名)
 *
 *  @return 查询结果数组
 */
-(NSMutableArray *)searchWithSql:(NSString *)aSql withClass:(Class)aClass;

/**
 *  数据库中是否存在该表
 *
 *  @param aTableName 表名
 *
 *  @return 表名是否存在
 */
-(BOOL)isTableExists:(NSString *)aTableName;

/**
 *  根据查询sql，分离出列名
 *
 *  @param aSql sql
 *
 *  @return 列名数组
 */
-(NSArray *)getSearchCloumnWithSql:(NSString *)aSql;

@end

const float WYDatabaseCloseRetryDuration = 10.0;

@implementation WYDatabase

@synthesize db = _db;

+(instancetype)shareInstance{
    
    static WYDatabase *database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path =   [[NSString getFolderWithType:NSCachesDirectory] stringByAppendingPathComponent:@"db.sqlite"];
        database = [[self alloc] initWithPath:path];
        if([database open])
            NSLog(@"数据库打开成功：%@",path);
    });
    
    return database;
}

+(instancetype)openDatabaseWitPath:(NSString*)aPath{
    
    WYDatabase *db = [[self alloc] initWithPath:aPath];
    
    if([db open])   return db;
    
    return nil;
}

+(instancetype)databaseWithPath:(NSString*)aPath{
    return [[self alloc] initWithPath:aPath];
}

-(instancetype)initWithPath:(NSString*)aPath{
    
    self = [super init];
    
    if(self){
    
        _isTransaction = NO;
        _dbPath = [aPath copy];
    }
    
    return self;
}

-(BOOL)open{
    
    if(_db) return YES;
    
    int err = sqlite3_open([_dbPath UTF8String], &_db);
    
    if(err != SQLITE_OK){

        NSLog(@"【Error】 open db ! err code = %d",err);
        
        return NO;
    }
    
    return YES;
}

-(BOOL)close{

    int  rc;
    BOOL retry;
    BOOL closeStat = YES;
    int numberOfRetries = 10;
    
    do {
        retry   = NO;
        
        rc      = sqlite3_close(_db);
        
        if (SQLITE_BUSY == rc || SQLITE_LOCKED == rc) {
            
            numberOfRetries--;
            
            retry = YES;
            
            usleep(WYDatabaseCloseRetryDuration);
            
            if (!numberOfRetries) {
                
                NSLog(@"【Error】 Database busy, unable to close");
                
                return NO;
            }
            
            if(closeStat){
                
                sqlite3_stmt *pStmt;
                
                closeStat = NO;
                
                while ((pStmt = sqlite3_next_stmt(_db, 0x00)) !=0) {
                    
                    NSLog(@"Closing leaked statement");
                    
                    sqlite3_finalize(pStmt);
                }
            
            }

        }
        else if (SQLITE_OK != rc) {
            
            NSLog(@"【Error】 closing!: %d", rc);
            
        }
    }
    while (retry);
    
    _db = nil;
    return YES;
}

/**
 *  解析表字段
 *
 *  @param aTableName 表名
 *
 *  @return 表的所有字段
 */
- (NSArray *)tableColums:(NSString *)aTableName {
    NSString *sql = [NSString stringWithFormat:@"select sql from sqlite_master where type=\"table\" and name=\"%@\";",aTableName];
    
    
    NSArray *sArray = nil;
    
    const char *err;
    sqlite3_stmt *pStmt;
    
    
    if(SQLITE_OK != sqlite3_prepare_v2(_db, [sql UTF8String], -1, &pStmt, &err)){
        
        NSLog(@"【Error】 with sql : %@,%s",sql,err);
        return nil;
    }
    
    NSString *createSql = nil;
    
    while (SQLITE_ROW == sqlite3_step(pStmt)) {
        
        char *s = (char *)sqlite3_column_text(pStmt, 0);
        NSString *value = [self converCharToString:s];
        
        createSql = value;
        break;
    }
    sqlite3_finalize(pStmt);
    
    NSRange range1 = [createSql rangeOfString:@"("];
    NSRange range2 = [createSql rangeOfString:@")"];
    NSString *string = [createSql substringWithRange:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    string = [string stringByReplacingOccurrencesOfString:@"text" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    sArray = [string componentsSeparatedByString:@","];

    
    return sArray;
}

/**
 *  增加列
 *
 *  @param aSet   列名
 *  @param sTable 表名
 */
- (void) addCloumn:(NSSet *)aSet wTable:(NSString *)sTable{
    [aSet enumerateObjectsUsingBlock:^(NSString *obj, BOOL *stop) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ text;",sTable,obj];
        [self executeWithSql:sql];
    }];
}

#pragma  mark - 用对象来创建数据表 -

-(BOOL)createTableWithObj:(id)aObj{

    NSMutableArray *sArray = [aObj getAttributeList];
    
    if ([self isTableExists:NSStringFromClass(aObj)]) {
        NSArray *array = [self tableColums:NSStringFromClass(aObj)];
        NSMutableSet *set1 = [NSMutableSet setWithArray:sArray];
        NSMutableSet *set2 = [NSMutableSet setWithArray:array];
        [set1 minusSet:set2];
        if (set1.count) {
            //增加列
            [self addCloumn:set1 wTable:NSStringFromClass(aObj)];
        }
        return YES;
    }
    
    NSMutableString *aSql = [NSMutableString stringWithFormat:@"create table if not exists %@ (",NSStringFromClass([aObj class])];
    
    NSMutableString *subString = [NSMutableString string];
    
    int i = 0;
    for (NSString *colum in sArray) {
        if (i == 0) {
            i = 1;
        }
        else {
            [subString appendString:@","];
        }

        [subString appendString:colum];
        
        [subString appendString:@" text"];
    }
    
    [aSql appendString:subString];
    
    [aSql appendString:@");"];
    
    return [self executeWithSql:aSql];
}

-(BOOL)createTableWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

-(BOOL)insertWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

-(BOOL)insertWithObjValue:(NSArray *)aValue tableName:(Class)className{

    if(aValue == nil || aValue.count == 0) {
    
        NSLog(@"【Error】");
        return NO;
    }
       
    NSString *tableName = NSStringFromClass([className class]);
    
    for (id value in aValue) {
        
        NSDictionary *mDic = nil;
        
        if([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]){
        
            mDic = value;
            
        }else{
        
            mDic = [value dictFromObject];
        }
        
        NSMutableString *aSql = [NSMutableString stringWithFormat:@"insert into  %@ (",tableName];
        
        NSMutableString *subString = [NSMutableString string];
        
        for (NSString *colum in [mDic allKeys]) {
            
            [subString appendString:colum];
            
            [subString appendString:@","];
        }
        
        subString = (NSMutableString *)[subString substringToIndex:subString.length - 1];
        
        [aSql appendString:subString];
        
        
        subString = [NSMutableString stringWithFormat:@") values ("];
        
        for (NSString *colum in [mDic allValues]) {
            
            [subString appendFormat:@"\'%@\'",colum];
            
            [subString appendString:@","];
        }
        
        subString = (NSMutableString *)[subString substringToIndex:subString.length - 1];
        
        [aSql appendString:subString];
        
        [aSql appendString:@");"];
        
        if([self executeWithSql:aSql]) continue;
        
        return NO;
    }
    
    return YES;
}

- (BOOL)insertWithObjValue:(NSArray *)aValue tableName:(Class)className withKey:(NSString *)sKey{
    
    if(aValue == nil || aValue.count == 0) {
        
        NSLog(@"【Error】");
        return NO;
    }
    
    NSString *tableName = NSStringFromClass([className class]);
    
    for (id value in aValue) {
        
        NSDictionary *mDic = nil;
        
        if([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]){
            
            mDic = value;
            
        }else{
            
            mDic = [value dictFromObject];
        }

        NSString *ts = [NSString stringWithFormat:@"select %@ from %@ where %@ = '%@';",sKey,tableName,sKey,mDic[sKey]];
        if ([self queryWithSql:ts columnIndex:0]) {
            NSLog(@"有该条记录");
            continue;
        }
        [self insertWithObjValue:[NSArray arrayWithObject:value] tableName:className];
    }
    
    return YES;
}

-(BOOL)deleteWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

-(BOOL)updateWithSql:(NSString *)aSql{

    return [self executeWithSql:aSql];
}

#pragma  mark - 查询数据 -

-(NSMutableArray *)queryWithSql:(NSString *)aSql{
        
    NSAssert(aSql != nil && aSql.length != 0, @"【Error】 ");
    
    return [self searchWithSql:aSql withClass:nil];

}

-(NSMutableArray *)queryObjWithClass:(Class)aClass{

    return [self queryObjWithClass:aClass condition:nil];
}

-(NSMutableArray *)queryObjWithClass:(Class)aClass withSql:(NSString *)aSql{

    NSAssert(aClass != nil && aSql != nil && aSql.length != 0, [NSString stringWithFormat:@"queryObjWithClass : class can't nil"]);
    
    return [self searchWithSql:aSql withClass:aClass];
}

-(NSMutableArray *)queryObjWithClass:(Class)aClass condition:(NSDictionary *)aCondition{

    NSAssert(aClass != nil, [NSString stringWithFormat:@"queryObjWithClass : class can't nil"]);
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"select * from %@ ",NSStringFromClass(aClass)];
    
    NSArray *keys = [aCondition allKeys];
    for (int i = 0; i < keys.count;i++){
    
        NSString *key = keys[i];
        if(i == 0){
        
            [sql appendFormat:@"where %@ = '%@'",key,aCondition[key]];
        }else{
            
            [sql appendFormat:@" and %@ = '%@'",key,aCondition[key]];
        }
        
    }
    [sql appendString:@";"];
    
    return [self searchWithSql:sql withClass:aClass];
}

-(NSString *)queryWithSql:(NSString *)aSql columnIndex:(NSInteger)aIndex{
    
    const char *err;
    sqlite3_stmt *pStmt;
    
    NSString *result = nil;
    
    if(SQLITE_OK != sqlite3_prepare_v2(_db, [aSql UTF8String], -1, &pStmt, &err)){
        
        NSLog(@"【Error】 with sql : %@",aSql);
        return nil;
    }
    
    NSLog(@"%@",aSql);
    
    while (SQLITE_ROW == sqlite3_step(pStmt)) {
        
        char *s = (char *)sqlite3_column_text(pStmt, (int)aIndex);
        
        result = [self converCharToString:s];
        
        break;
    }
    
    sqlite3_finalize(pStmt);
    
    return result;
}

//DEPRECATED Dubai
-(NSData*)queryBlobWithKey:(NSString *)aKey columnIndex:(NSInteger)aIndex{

    NSData* data = nil;
    NSString* sqliteQuery = [NSString stringWithFormat:@"select value from 'values' where key = '%@'", aKey];
    sqlite3_stmt* statement;
    
    if( sqlite3_prepare_v2(_db, [sqliteQuery UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
        if( sqlite3_step(statement) == SQLITE_ROW )
        {
            int length = sqlite3_column_bytes(statement, 0);
            data       = [NSData dataWithBytes:sqlite3_column_blob(statement, 0) length:length];
        }
    }
    
    // Finalize and close database.
    sqlite3_finalize(statement);
    
    return data;
}

-(void)insertWithValue:(NSData *)aData withKey:(NSString *)aKey{

    const char* sqliteQuery = "insert into 'values' ('value', 'key') VALUES (?, ?)";
    sqlite3_stmt* statement;
    
    if( sqlite3_prepare_v2(_db, sqliteQuery, -1, &statement, NULL) == SQLITE_OK )
    {
        sqlite3_bind_blob(statement, 1, [aData bytes], (int)[aData length], SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [aKey UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_step(statement);
        NSLog(@"Success with sql : insert into 'values' ('value', 'key')");
    }else{
        NSLog(@"【error】 insert into 'values':  %s", sqlite3_errmsg(_db) );
    }
    
    // Finalize and close database.
    sqlite3_finalize(statement);
}

#pragma  mark - Transaction -

- (BOOL)beginTransaction{

    if(_isTransaction)
    {
        NSAssert(0, @"please commit pre transaction");
        return NO;
    }
    return _isTransaction = [self executeWithSql:@"begin exclusive transaction"];
}

- (BOOL)commit{

    if(_isTransaction)
    {
        NSAssert(0, @"please commit pre transaction");
        return NO;
    }
    
    return _isTransaction = [self executeWithSql:@"commit transaction"];
}

- (BOOL)rollback{
    
    if(_isTransaction)
    {
        NSAssert(0, @"please commit pre transaction");
        return NO;
    }

    return _isTransaction = [self executeWithSql:@"rollback transaction"];
}

#pragma  mark - other -

- (sqlite_int64)lastInsertRowId{
    
    return  sqlite3_last_insert_rowid(_db);
}

#pragma  mark - private method -

-(NSMutableArray *)searchWithSql:(NSString *)aSql withClass:(Class)aClass{
    
    NSMutableArray *sArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    const char *err;
    sqlite3_stmt *pStmt;
    
    BOOL bObj = (aClass == nil ? NO : YES);
    
    if(SQLITE_OK != sqlite3_prepare_v2(_db, [aSql UTF8String], -1, &pStmt, &err)){
        
        NSLog(@"【Error】 with sql : %@,%s",aSql,err);
        return nil;
    }
    
    NSMutableArray *sAttribyte = [[NSMutableArray alloc] initWithCapacity:10];
    
    Class obj = aClass;
    
    if(bObj){
        
        sAttribyte = [obj getAttributeList];
    } else if ([aSql rangeOfString:@"*"].location == NSNotFound){
        
        NSArray *sA = [self getSearchCloumnWithSql:aSql];
        if(sA){
            sAttribyte = [[NSMutableArray alloc] initWithArray:sA];
        }
    }
    
    if (!sAttribyte.count) {
        NSLog(@"【Error】 with no cloumns : %@,%@",aSql,aClass);
        return sArray;
    }
    
    NSLog(@"%@",aSql);

    while (SQLITE_ROW == sqlite3_step(pStmt)) {
        
        NSMutableDictionary *aDic = [[NSMutableDictionary alloc] initWithCapacity:10];
        
        for (int i = 0; i < [sAttribyte count]; i++) {
            
            char *s = (char *)sqlite3_column_text(pStmt, i);
            
            [aDic setValue:[self converCharToString:s] forKey:sAttribyte[i]];
        }
        
        //转换成对象
        if(bObj){
            
            [sArray addObject:[[obj alloc] initWithReflectData:aDic]];
        }else{
            
            [sArray addObject:aDic];
        }
    }
    sqlite3_finalize(pStmt);
    return sArray;
}

int sqlite3CallBack( void * para, int n_column, char ** column_value, char ** column_name ){

    char *sss = (char *)para;
    NSLog(@"sqlite3CallBack [%s][%d][%s][%s]",sss,n_column,*column_value,*column_name);
    return 0;
}

-(BOOL)executeWithSql:(NSString *)aSql{

    if(aSql == nil || aSql.length == 0 || [aSql rangeOfString:@"select"].location != NSNotFound){
    
        NSLog(@"bad sql : %@",aSql);
        return NO;
    }
    
    char *err;
    
    int rc = sqlite3_exec(_db, [aSql UTF8String], sqlite3CallBack, (__bridge void *)(aSql), &err);
    
    if(err){
    
        NSLog(@"【Error】:%s with sql : %@",err,aSql);
        return NO;
    }
    if(rc == SQLITE_OK){
        
        NSLog(@"Success with sql : %@",aSql);
    }
    return YES;
    
}

-(NSArray *)getSearchCloumnWithSql:(NSString *)aSql{

    NSString *sCloumn = nil;
    NSString *sql = [aSql copy];
    sql = [sql stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSRange rangeFrom = [sql rangeOfString:@"from" options:NSCaseInsensitiveSearch];
    
    @try {
        
        NSRange subRange = NSMakeRange(6, rangeFrom.location - 6);
        sCloumn = [sql substringWithRange:subRange];
        
        return [sCloumn componentsSeparatedByString:@","];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
        return nil;
    }
    @finally {
        
    }
}

-(NSString *)converCharToString:(char *)pChar{

    return pChar == NULL ? @"" : [NSString stringWithUTF8String:pChar];
}

-(BOOL)isTableExists:(NSString *)aTableName{

    NSString *tableName = [NSString stringWithFormat:@"select count(*) from sqlite_master where type='table' and name = '%@'",aTableName];
    
    NSString *rsult = [self queryWithSql:tableName columnIndex:0];
    
    return (rsult == nil || rsult.length == 0 || [rsult integerValue] == 0) ? NO : YES;
}



@end