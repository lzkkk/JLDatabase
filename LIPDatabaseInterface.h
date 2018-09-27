//
//  PCDatabaseInterface.h
//  LipDataBaseDemo
//
//  Created by QF on 15/11/16.
//  Copyright © 2015年 Lip.W. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LIPDatabaseInterface <NSObject>

- (void)closeDB;

- (BOOL)updateDatabse:(NSString *)name;

//创建表
- (BOOL)createTableWithClazz:(Class)clz;

- (BOOL)createTableWithTableName:(NSString *)tablename
                           clazz:(Class)clz;

- (BOOL)tableExsistWithClazz:(Class)clz;

- (BOOL)tableExsistWithTableName:(NSString *)tablename
                           clazz:(Class)clz;
//删除表
- (BOOL)dropTableSqlClazz:(Class)clz;

- (BOOL)dropTableWithTableName:(NSString *)tablename;

//插入数据
- (BOOL)insertTableSql:(NSString *)sql;

- (BOOL)insertTableSql:(NSString *)sql clazz:(Class)clz;

- (BOOL)insertTableSql:(NSString *)sql tableName:(NSString *)tablename clazz:(Class)clz;

- (NSUInteger)insertTableParameFromArray:(NSArray *)array
                                   clazz:(Class)clz
                                  update:(BOOL)update;

- (NSUInteger)insertTableParameFromArray:(NSArray *)array
                                   clazz:(Class)clz
                               tableName:(NSString *)tablename
                                  update:(BOOL)update;
//删除数据
- (BOOL)deleteSql:(NSString *)sql;

- (BOOL)deleteSql:(NSString *)sql clazz:(Class)clz;

- (BOOL)deleteSql:(NSString *)sql tableName:(NSString *)tablename clazz:(Class)clz;

- (BOOL)deleteTableParameFromClazz:(Class)clz where:(nullable NSString *)condition;

- (BOOL)deleteTableParameFromClazz:(Class)clz tableName:(NSString *)tablename where:(NSString *)condition;

//修改数据
- (BOOL)updateSql:(NSString *)sql;
- (BOOL)updateSql:(NSString *)sql clazz:(Class)clz;
- (BOOL)updateSql:(NSString *)sql tableName:(NSString *)tablename clazz:(Class)clz;
- (BOOL)updateTableParameFromObj:(id)obj where:(nullable NSString *)condition;
- (BOOL)updateTableParameFromObj:(id)obj tableName:(NSString *)tablename where:(NSString *)condition;

//查询数据
- (NSArray *)queryTableSql:(NSString *)sql
                     clazz:(nullable Class)clz;

- (NSArray *)queryTableFromClazz:(Class)clz
                           where:(nullable NSString *)condition;

- (NSArray *)queryTableFromClazz:(Class)clz
                       tableName:(NSString *)tablename
                           where:(NSString *)condition;

- (NSInteger)queryCountTableSql:(NSString *)sql;

- (NSInteger)queryCountTableFromClazz:(Class)clz
                                where:(nullable NSString *)condition;

- (NSInteger)queryCountTableFromClazz:(Class)clz
                            tableName:(NSString *)tablename
                                where:(NSString *)condition;
@end
NS_ASSUME_NONNULL_END
