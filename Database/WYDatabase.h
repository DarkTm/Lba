//
//  WYDatabase.h
//  WYCategory
//
//  Created by tom on 13-12-5.
//  Copyright (c) 2013年 qiaquan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

#import "WYCategory.h"

@interface WYDatabase : NSObject
{
    sqlite3 *_db;
    NSString *_dbPath;
    BOOL _isTransaction;
}

//+(instancetype)shareInstance;

@property (nonatomic, assign) sqlite3* db;

/**
 *  实例化并打开数据库
 *
 *  @param aPath 数据库的绝对路径
 *
 *  @return 数据库实例
 */
+(instancetype)openDatabaseWitPath:(NSString*)aPath;

/**
 *  实例化数据库
 *
 *  @param aPath 数据库的绝对路径
 *
 *  @return 数据库实例
 */
+(instancetype)databaseWithPath:(NSString*)aPath;

/**
 *  实例化数据库
 *
 *  @param aPath 数据库的绝对路径
 *
 *  @return 数据库实例
 */
-(instancetype)initWithPath:(NSString*)aPath;

/**
 *  打开数据库
 *
 *  @return 打开是否成功
 */
-(BOOL)open;

/**
 *  关闭数据库
 *
 *  @return 关闭是否成功
 */
-(BOOL)close;

/**
 *  创建表
 *
 *  @param aObj 数据model
 *
 *  @return 表创建是否成功
 */
-(BOOL)createTableWithObj:(id)aObj;

/**
 *  创建表
 *
 *  @param aSql sql
 *
 *  @return 表创建是否成功
 */
-(BOOL)createTableWithSql:(NSString *)aSql;

/**
 *  插入数据
 *
 *  @param aSql 插入sql
 *
 *  @return 插入是否成功
 */
-(BOOL)insertWithSql:(NSString *)aSql;

/**
 *  插入数据
 *
 *  @param aValue    model 类型 数组
 *  @param className model 类名
 *
 *  @return 是否插入成功
 */
-(BOOL)insertWithObjValue:(NSArray *)aValue tableName:(Class)className;

/**
 *  插入数据，sKey 的值不相同
 *
 *  @param aValue    待插入数据数组
 *  @param className 表名
 *  @param sKey      key
 *
 *  @return 是否插入成功
 */
- (BOOL)insertWithObjValue:(NSArray *)aValue tableName:(Class)className withKey:(NSString *)sKey;

/**
 *  删除
 *
 *  @param aSql 删除sql
 *
 *  @return 删除是否成功
 */
-(BOOL)deleteWithSql:(NSString *)aSql;

/**
 *  更新
 *
 *  @param aSql 更新sql
 *
 *  @return 更新是否成功
 */
-(BOOL)updateWithSql:(NSString *)aSql;

/**
 *  查询
 *
 *  @param aSql 查询sql
 *
 *  @return 结果数组
 */
-(NSMutableArray *)queryWithSql:(NSString *)aSql;

/**
 *  查询
 *
 *  @param aClass 类名 （表名）
 *
 *  @return 结果数组
 */
-(NSMutableArray *)queryObjWithClass:(Class)aClass;

/**
 *  查询
 *
 *  @param aClass 类名 （表名） 可nil
 *  @param aSql   查询sql
 *
 *  @return 结果数组
 */
-(NSMutableArray *)queryObjWithClass:(Class)aClass withSql:(NSString *)aSql;

/**
 *  查询
 *
 *  @param aClass     类名 （表名）
 *  @param aCondition 条件 {'key':'value','key2':'value2'}    select * from tablename where key = value and key2 = value2
 *
 *  @return 结果数组
 */
-(NSMutableArray *)queryObjWithClass:(Class)aClass condition:(NSDictionary *)aCondition;

/**
 *  查询指定列结果
 *
 *  @param aSql   查询sql
 *  @param aIndex 指定列
 *
 *  @return 返回查询结果
 */
-(NSString *)queryWithSql:(NSString *)aSql columnIndex:(NSInteger)aIndex;

/**
 *  插入 data数据  DEPRECATED
 *
 *  @param aData data大数据
 *  @param aKey  字段名
 */
-(void)insertWithValue:(NSData *)aData withKey:(NSString *)aKey;

/**
 *  获取指定列数据 DEPRECATED
 *
 *  @param aKey   字段名
 *  @param aIndex 列名index 可nil
 *
 *  @return data数据
 */
-(NSData*)queryBlobWithKey:(NSString *)aKey columnIndex:(NSInteger)aIndex;

/**
 *  获取数据库中最后一行
 *
 *  @return 返回最后一行
 */
-(sqlite_int64)lastInsertRowId;

/**
 *  事务开启
 *
 *  @return 事务开启是否成功
 */
-(BOOL)beginTransaction;

/**
 *  提交事务
 *
 *  @return 提交事务是否成功
 */
-(BOOL)commit;

/**
 *  事务回滚
 *
 *  @return 事务回滚是否成功
 */
-(BOOL)rollback;

@end