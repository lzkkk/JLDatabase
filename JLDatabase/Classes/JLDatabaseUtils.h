//
//  PCDatabaseUtils.h
//  PokerClub
//
//  Created by QF on 16/1/4.
//  Copyright © 2016年 Lip. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLDatabaseUtils : NSObject

+ (NSString*)columnTypeWithClass:(Class)clazz
                            dict:(NSMutableDictionary *)dict
                            name:(NSString*)name;

+ (NSMutableDictionary*)checkTypeForValues:(NSMutableDictionary*)valuesDict
                                     class:(Class)clazz;

+ (NSDictionary *)propertiesForClass:(Class)cls;

#pragma mark - SQL 语句生成
+ (NSString*)sqlCreateTable:(Class)clazz
                  tableName:(NSString *)tablename;

+ (NSString *)sqlInsertOrReplaceClazz:(Class)clz
                            tableName:(NSString *)tablename
                                param:(NSDictionary *)param
                                  obj:(id)obj;

+ (NSString *)sqlInsertClazz:(Class)clz
                   tableName:(NSString *)tablename
                       param:(NSDictionary *)param
                         obj:(id)obj;

+ (NSString *)sqlConditionClazz:(Class)clz
                          param:(NSDictionary *)param;

+ (NSString *)sqlDeleteClazz:(Class)clazz
                   tableName:(NSString *)tablename
                       where:(NSString *)condition;

+ (NSString *)sqlUpdateClazz:(Class)clazz
                   tableName:(NSString *)tablename
                       param:(NSDictionary *)param
                       where:(NSString *)condition;

+ (NSString *)sqlQueryClazz:(Class)clazz
                  tableName:(NSString *)tablename
                      where:(NSString *)condition;

+ (NSString *)sqlQueryCountClazz:(Class)clazz
                       tableName:(NSString *)tablename
                           where:(NSString *)condition;
@end
