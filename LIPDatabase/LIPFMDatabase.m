//
//  PCFMDatabase.m
//  LipDataBaseDemo
//
//  Created by QF on 15/11/16.
//  Copyright © 2015年 Lip.W. All rights reserved.
//

#import "LIPFMDatabase.h"
#import "FMDatabase.h"
#import "LIPFMDatabseUtils.h"


@interface LIPFMDatabase ()

@end

@implementation LIPFMDatabase

- (instancetype)initWithDbName:(NSString *)name{
    self = [super init];
    if (self) {
        NSString *dbPath = name;
        if (_db) {
            [_db close];
        }
        _db = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (void)closeDB{
    if (_db) {
        [_db close];
    }
}

- (BOOL)updateDatabse:(NSString *)name{
    return YES;
}

//创建表
- (BOOL)createTableWithClazz:(nonnull Class)clz{
    return [self createTableWithTableName:NSStringFromClass(clz) clazz:clz];
}

- (BOOL)createTableWithTableName:(NSString *)tablename
                           clazz:(Class)clz{
    
    NSString *createSql = [LIPDatabaseUtils sqlCreateTable:clz
                                                 tableName:tablename];
    __block BOOL ret = NO;
    [_db inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:createSql];
    }];
    if (!ret) {
        NSLog(@"create Table %@ Failure!",tablename);
    }
    return ret;
    
}

- (BOOL)tableExsistWithClazz:(Class)clz{
    return [self tableExsistWithTableName:NSStringFromClass(clz) clazz:clz];
}

- (BOOL)tableExsistWithTableName:(NSString *)tablename
                           clazz:(Class)clz{
   return [self createTableWithTableName:tablename
                                   clazz:clz];
}

#pragma mark - dropTable
//删除表
- (BOOL)dropTableSqlClazz:(Class)clz{
    return [self dropTableWithTableName:NSStringFromClass(clz)];
}

- (BOOL)dropTableWithTableName:(NSString *)tablename{
    NSString *dropSql = [NSString stringWithFormat:@"Drop Table IF EXISTS %@",tablename];
    __block BOOL ret = NO;
    
    [_db inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:dropSql];
    }];
    if (!ret) {
        NSLog(@"drop Table %@ failure!",tablename);
    }
    return ret;
}

#pragma mark - insertTable
//插入数据
- (NSUInteger)insertTableParameFromArray:(NSArray *)array
                                   clazz:(Class)clz
                                  update:(BOOL)update{
   return [self insertTableParameFromArray:array clazz:clz tableName:NSStringFromClass(clz) update:update];
}

- (NSUInteger)insertTableParameFromArray:(NSArray *)array
                                   clazz:(Class)clz
                               tableName:(NSString *)tablename
                                  update:(BOOL)update{
    
    if (![self tableExsistWithTableName:tablename clazz:clz]) {
        return NO;
    }
    __block NSUInteger successCount = 0;
    [_db inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (id obj in array) {
            
            NSMutableDictionary *param = [LIPFMDatabseUtils mutableDictionaryForObject:obj];
            param = [LIPDatabaseUtils checkTypeForValues:param class:clz];
            NSMutableArray *arguments = [NSMutableArray new];
            for (NSString *name in [param allKeys]) {
                [arguments addObject:(param[name]?:@"")];
            }
            NSString *sqlQuery = nil;
            if (update) {
                
                NSInteger count = 0;
                NSString *condition = [LIPDatabaseUtils sqlConditionClazz:clz                                   param:param];
                if (!condition || ![condition length]) {
                    sqlQuery = [LIPDatabaseUtils sqlInsertOrReplaceClazz:clz tableName:tablename param:param obj:obj];
                } else{
                    
                    condition = [NSMutableString stringWithString:[condition substringToIndex:[condition length]-4]];
                    NSString *sqlQueryCount = [LIPDatabaseUtils sqlQueryCountClazz:clz tableName:tablename where:condition];
                    FMResultSet *set = [db executeQuery:sqlQueryCount];
                    [set next];
                    count = [set intForColumnIndex:0];
                    [set close];
                    
                    if (count > 0) {
                        sqlQuery = [LIPDatabaseUtils sqlUpdateClazz:clz tableName:tablename param:param where:condition];
                    } else{
                        sqlQuery = [LIPDatabaseUtils sqlInsertClazz:clz tableName:tablename param:param obj:obj];
                    }
                }
                
            
            } else{
                sqlQuery = [LIPDatabaseUtils sqlInsertOrReplaceClazz:clz tableName:tablename param:param obj:obj];
            }
            
            if ([db executeUpdate:sqlQuery withArgumentsInArray:arguments]) {
                successCount ++;
            };
        }
    }];
    return successCount;

}

- (BOOL)insertTableSql:(NSString *)sql{
    __block BOOL ret = NO;
    [_db inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    if (!ret) {
        NSLog(@"%@ failure!",sql);
    }
    return ret;
}

- (BOOL)insertTableSql:(NSString *)sql
                 clazz:(Class)clz{
    return [self insertTableSql:sql tableName:NSStringFromClass(clz) clazz:clz];
}

- (BOOL)insertTableSql:(NSString *)sql
             tableName:(NSString *)tablename
                 clazz:(Class)clz{
    if (![self tableExsistWithTableName:tablename clazz:clz]) {
        return NO;
    }
    if (!sql) {
        NSLog(@"sqlUpdate cant is null");
        return NO;
    }
    __block BOOL ret = NO;
    [_db inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    if (!ret) {
        NSLog(@"%@ failure!",sql);
    }
    return ret;
}

#pragma mark - deleteTable
//删除数据
- (BOOL)deleteTableParameFromClazz:(Class)clz
                             where:(NSString *)condition{
    return [self deleteTableParameFromClazz:clz tableName:NSStringFromClass(clz) where:condition];
}

- (BOOL)deleteTableParameFromClazz:(Class)clz
                         tableName:(NSString *)tablename
                             where:(NSString *)condition{
    if (![self tableExsistWithTableName:tablename clazz:clz]) {
        return NO;
    }
    __block BOOL ret = NO;
    NSString *sqlUpdate = [LIPDatabaseUtils sqlDeleteClazz:clz tableName:tablename where:condition];
    if (!sqlUpdate) {
        ret = NO;
    }
    return [self deleteSql:sqlUpdate];
}


- (BOOL)deleteSql:(NSString *)sql{
    __block BOOL ret = NO;
    if (!sql) {
        NSLog(@"sqlUpdate cant null");
        return NO;
    }
    [_db inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    if (!ret) {
        NSLog(@"%@ failure!",sql);
    }
    return ret;
}

- (BOOL)deleteSql:(NSString *)sql
            clazz:(Class)clz{
    return [self deleteSql:sql tableName:NSStringFromClass(clz) clazz:clz];
}

- (BOOL)deleteSql:(NSString *)sql
        tableName:(NSString *)tablename
            clazz:(Class)clz{
    if (![self tableExsistWithTableName:tablename clazz:clz]) {
        return NO;
    }
    BOOL ret = [self deleteSql:sql];
    return ret;
}

#pragma mark - updateTable
//修改数据
- (BOOL)updateTableParameFromObj:(id)obj
                           where:(NSString *)condition{
    return [self updateTableParameFromObj:obj tableName:NSStringFromClass([obj class]) where:condition];
}

- (BOOL)updateTableParameFromObj:(id)obj
                       tableName:(NSString *)tablename
                           where:(NSString *)condition{
    if (![self tableExsistWithTableName:tablename clazz:[obj class]]){
        return NO;
    }
    NSMutableDictionary *param = [LIPFMDatabseUtils mutableDictionaryForObject:obj];
    param = [LIPDatabaseUtils checkTypeForValues:param class:[obj class]];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    for (NSString *name in [param allKeys]) {
        [arguments addObject:(param[name]?:@"")];
    }
    __block BOOL ret = NO;
    NSString *sqlUpdate = [LIPDatabaseUtils sqlUpdateClazz:[obj class]tableName:tablename param:param where:condition];
    
    if (!sqlUpdate) {
        NSLog(@"sql is null");
        return NO;
    }
    
    [_db inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sqlUpdate withArgumentsInArray:arguments];
        
    }];
    
    if (!ret) {
        NSLog(@"%@ failure!",sqlUpdate);
    }
    return ret;
}

- (BOOL)updateSql:(NSString *)sql{
    if (!sql) {
        NSLog(@"sqlUpdate is null");
    }
    __block BOOL ret = NO;
    [_db inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    if (!ret) {
        NSLog(@"%@ failure!",sql);
    }
    return ret;
}

- (BOOL)updateSql:(NSString *)sql
            clazz:(Class)clz{
    return [self updateSql:sql tableName:NSStringFromClass(clz) clazz:clz];
}

- (BOOL)updateSql:(NSString *)sql
        tableName:(NSString *)tablename
            clazz:(Class)clz{
    if (![self tableExsistWithTableName:tablename clazz:clz]){
        return NO;
    }
    BOOL ret = [self updateSql:sql];
    return ret;
}

#pragma mark queryTable
//查询数据
- (NSMutableArray *)querySql:(NSString *)sql
                       clazz:(Class)clz{

    NSMutableArray *array = [[NSMutableArray alloc] init];
    [_db inDatabase:^(FMDatabase *db) {
        FMResultSet *set = nil;
        set = [db executeQuery:sql];
        while ([set next]) {
            [array addObject:[LIPFMDatabseUtils objectWithClass:clz
                                                  fromResultSet:set]];
        }
        [set close];
    }];
    return array;
}

- (NSInteger)queryCountSql:(NSString *)sql{
    __block NSInteger count = 0;
    [_db inDatabase:^(FMDatabase *db) {
        NSLog(@"%d",[[NSThread currentThread] isMainThread]);
        FMResultSet *set = [db executeQuery:sql];
        [set next];
        count = [set intForColumnIndex:0];
        [set close];
    }];
    return count;
}

- (NSArray *)queryTableFromClazz:(Class)clz
                           where:(NSString *)condition{
    return [self queryTableFromClazz:clz tableName:NSStringFromClass(clz) where:condition];
}

- (NSArray *)queryTableFromClazz:(Class)clz
                       tableName:(NSString *)tablename
                           where:(NSString *)condition{
    
    if (![self tableExsistWithTableName:tablename
                                  clazz:clz]){
        return nil;
    }
    NSString *sqlQuery = [LIPDatabaseUtils sqlQueryClazz:clz
                                               tableName:tablename
                                                   where:condition];

    return [self querySql:sqlQuery clazz:clz];
    
}

- (NSArray *)queryTableSql:(NSString *)sql
                     clazz:(Class)clz{
    return [self querySql:sql clazz:clz];
}

- (NSInteger)queryCountTableSql:(NSString *)sql{
    return [self queryCountSql:sql];
}

- (NSInteger)queryCountTableFromClazz:(Class)clz where:(nullable NSString *)condition{
    return [self queryCountTableFromClazz:clz tableName:NSStringFromClass(clz) where:condition];
}

- (NSInteger)queryCountTableFromClazz:(Class)clz
                            tableName:(NSString *)tablename
                                where:(NSString *)condition{
    if (![self tableExsistWithTableName:tablename clazz:clz]) {
        return 0;
    }
    NSString *sqlQuery = [LIPDatabaseUtils sqlQueryCountClazz:clz tableName:tablename where:condition];
    NSInteger count = [self queryCountSql:sqlQuery];
    return count;
}
@end
