//
//  PCDatabaseUtils.m
//  PokerClub
//
//  Created by QF on 16/1/4.
//  Copyright © 2016年 Lip. All rights reserved.
//

#import "LIPDatabaseUtils.h"
#import "LIPDBManagerDelegate.h"
#import <objc/runtime.h>

@implementation LIPDatabaseUtils

static const char *getPropertyType(objc_property_t property){
    const char *attributes = property_getAttributes(property);
    //printf("attributes=%s\n", attributes);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

#pragma mark - Get properties for a class
+ (NSDictionary *)propertiesForClass:(Class)cls
{
    if (cls == NULL) {
        return nil;
    }
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(cls, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

//获取属性类型对应的SQL字段类型
+ (NSString*)columnTypeWithClass:(Class)clazz
                            dict:(NSMutableDictionary *)dict
                            name:(NSString*)name{
    //    1.NULL：空值。
    //    2.INTEGER：带符号的整型，具体取决有存入数字的范围大小。
    //    3.REAL：浮点数字，存储为8-byte IEEE浮点数。
    //    4.TEXT：字符串文本。
    //    5.BLOB：二进制对象
    NSString* type = [dict objectForKey:name];
    if ([[type lowercaseString] isEqualToString:@"i"]||[[type lowercaseString] isEqualToString:@"l"]
        ||[[type lowercaseString] isEqualToString:@"q"]||[[type lowercaseString] isEqualToString:@"c"]||[[type lowercaseString] isEqualToString:@"b"]) {
        return @"INTEGER";
    }else if ([[type lowercaseString] isEqualToString:@"f"]||[[type lowercaseString] isEqualToString:@"d"]
              ||[type isEqualToString:@"NSNumber"]){
        return @"REAL";
    }else if([type isEqualToString:@"NSString"]){
        return @"TEXT";
    }else{
        if ([clazz conformsToProtocol:@protocol(LIPDBManagerDelegate)]) {
            BOOL isBlob = [clazz isBlobColumn:name];
            if (isBlob) {
                return @"BLOB";
            }
            BOOL isIgnore = [clazz isIgnoreColumn:name];
            if (isIgnore) {
                return nil;
            }
        }
        return nil;
    }
    
}

+ (NSMutableDictionary*)checkTypeForValues:(NSMutableDictionary*)valuesDict
                                     class:(Class)clazz
{
    NSMutableDictionary *pdict = [[LIPDatabaseUtils propertiesForClass:clazz] mutableCopy];
    NSMutableDictionary* dict = [NSMutableDictionary new];
    for (NSString *name in [valuesDict allKeys]) {
        NSString *column = [self columnTypeWithClass:clazz dict:pdict name:name];
        if (column) {
            if ([column isEqualToString:@"BLOB"]) {
                NSMutableData* data = [[NSMutableData alloc] init];
                NSKeyedArchiver* archer = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                [archer encodeObject:[valuesDict objectForKey:name] forKey:name];
                [archer finishEncoding];
                [dict setValue:data forKey:name];
            }
            else{
                [dict setValue:[valuesDict objectForKey:name] forKey:name];
            }
        }
    }
    return dict;
}

#pragma mark - 生成SQL语句
+ (NSString*)sqlCreateTable:(Class)clazz
                  tableName:(NSString *)tablename{

    NSMutableDictionary* propertyDict = [[LIPDatabaseUtils propertiesForClass:clazz] mutableCopy];
    if(![propertyDict count]){//没有列 返回
        return nil;
    }
    NSDictionary *columsExtras = nil;
    if ([clazz conformsToProtocol:@protocol(LIPDBManagerDelegate)]) {
        columsExtras = [clazz columnExtras];
    }
    NSArray *primaryKeys = nil;
    if ([clazz conformsToProtocol:@protocol(LIPDBManagerDelegate)] && [clazz respondsToSelector:@selector(columnPrimaryKey)]) {
        primaryKeys = [clazz columnPrimaryKey];
    }
    
    NSMutableString *sqlQuery = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", tablename];
    NSString *extra = nil;
    
    NSMutableString *primaryKeyStr = [[NSMutableString alloc] init];
    if ([primaryKeys count]) {
        [primaryKeyStr appendFormat:@"PRIMARY KEY ("];
        for (NSString *key in primaryKeys) {
            [primaryKeyStr appendFormat:@"%@,",key];
        }
        primaryKeyStr = [NSMutableString stringWithString:[primaryKeyStr substringToIndex:[primaryKeyStr length] - 1]];
        [primaryKeyStr appendString:@")"];
    }
    for (NSString *property in [propertyDict allKeys]) {
        if (columsExtras) {
            extra = [columsExtras objectForKey:property];
        }
        NSString *coumnType = [LIPDatabaseUtils columnTypeWithClass:clazz dict:propertyDict name:property];
        if (coumnType) {
            if (extra) {
                [sqlQuery appendFormat:@"%@ %@ %@,",property,coumnType,extra];
            }else
                [sqlQuery appendFormat:@"%@ %@,",property,coumnType];
        }
    }
    
    if ([primaryKeyStr length]) {
        [sqlQuery appendFormat:@"%@);",primaryKeyStr];
    } else{
        sqlQuery = [NSMutableString stringWithString:[sqlQuery substringToIndex:[sqlQuery length] - 1]];
        [sqlQuery appendString:@");"];
    }
    return sqlQuery;
    
}

//===========================增加或替换=========================//
+ (NSString *)sqlInsertOrReplaceClazz:(Class)clz
                            tableName:(NSString *)tablename
                                param:(NSDictionary *)param
                                  obj:(id)obj
{
    
    NSString *tabname = tablename ?: NSStringFromClass(clz);
    if (!obj) {
        return nil;
    }
    NSMutableString *paramStr = [[NSMutableString alloc] initWithString:@"("];
    NSMutableString *valueStr =[[NSMutableString alloc] initWithString:@"("];
    for (NSString *name in [param allKeys]) {
        [paramStr appendFormat:@"%@,",name];
        [valueStr appendFormat:@"?,"];
    }
    paramStr = [NSMutableString stringWithString:[paramStr substringToIndex:[paramStr length] -1]];
    [paramStr appendFormat:@")"];
    valueStr = [NSMutableString stringWithString:[valueStr substringToIndex:[valueStr length] -1]];
    [valueStr appendFormat:@")"];
    NSString *sqlQuery = nil;
    sqlQuery = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ %@ Values%@",tabname,paramStr,valueStr];
    return sqlQuery;
}

+ (NSString *)sqlInsertClazz:(Class)clz
                   tableName:(NSString *)tablename
                       param:(NSDictionary *)param
                         obj:(id)obj{
    NSString *tabname = tablename ?: NSStringFromClass(clz);
    if (!obj) {
        return nil;
    }
    NSMutableString *paramStr = [[NSMutableString alloc] initWithString:@"("];
    NSMutableString *valueStr =[[NSMutableString alloc] initWithString:@"("];
    for (NSString *name in [param allKeys]) {
        [paramStr appendFormat:@"%@,",name];
        [valueStr appendFormat:@"?,"];
    }
    paramStr = [NSMutableString stringWithString:[paramStr substringToIndex:[paramStr length] -1]];
    [paramStr appendFormat:@")"];
    valueStr = [NSMutableString stringWithString:[valueStr substringToIndex:[valueStr length] -1]];
    [valueStr appendFormat:@")"];
    NSString *sqlQuery = [NSString stringWithFormat:@"INSERT INTO %@ %@ Values%@",tabname,paramStr,valueStr];
    return sqlQuery;
    
}

+ (NSString *)sqlConditionClazz:(Class)clz
                          param:(NSDictionary *)param{
    
    NSMutableString *condition = [[NSMutableString alloc] init];
    
    if ([clz conformsToProtocol:@protocol(LIPDBManagerDelegate)]) {
        
        NSArray *array = [clz columnPrimaryKey];
        if ([array count]) {
            [condition appendString:@"WHERE "];
            for (NSString *primaryKey in array) {
                if (![[param allKeys] containsObject:primaryKey]) {
                    condition = nil;
                    break;
                } else{
                    if (!param[primaryKey]) {
                        condition = nil;
                        break;
                    }
                    [condition appendFormat:@"%@=%@ and ",primaryKey,param[primaryKey]];
                }
            }
        }
        return condition;
    }
    return nil;
}

//===========================删除=========================//
+ (NSString *)sqlDeleteClazz:(Class)clazz
                   tableName:(NSString *)tablename
                       where:(NSString *)condition
{
    NSString *tabname = tablename ? : NSStringFromClass(clazz);
    NSString *sqlQuery;
    if (!condition) {
        sqlQuery = [NSString stringWithFormat:@"DELETE FROM %@",tabname];
    }
    else {
       sqlQuery = [NSString stringWithFormat:@"DELETE FROM %@ %@",tabname,condition];
    }
    
    return sqlQuery;
}

//===========================修改=========================//
+ (NSString *)sqlUpdateClazz:(Class)clazz
                   tableName:(NSString *)tablename
                       param:(NSDictionary *)param
                       where:(NSString *)condition
{
    
    NSString *tabname = tablename ?: NSStringFromClass(clazz);
    if (![param count]) {
        return nil;
    }
    NSMutableString *paramStr = [[NSMutableString alloc] init];
    for (NSString *name in [param allKeys]) {
        [paramStr appendFormat:@"%@=?,",name];
    }
    paramStr = [NSMutableString stringWithString:[paramStr substringToIndex:[paramStr length] -1]];
    NSString *sqlQuery = [NSString stringWithFormat:@"UPDATE %@ SET %@ %@",tabname,paramStr,condition];
    return sqlQuery;
    
}

//===========================查找=========================//
+ (NSString *)sqlQueryClazz:(Class)clazz
                  tableName:(NSString *)tablename
                      where:(NSString *)condition{
    
    NSString *tabname = tablename ?: NSStringFromClass(clazz);
    if (!condition) {
        return [NSString stringWithFormat:@"SELECT * FROM %@",tabname];
    }
    return [NSString stringWithFormat:@"SELECT * FROM %@ %@",tabname,condition];
    
}

+ (NSString *)sqlQueryCountClazz:(Class)clazz
                       tableName:(NSString *)tablename
                           where:(NSString *)condition{
    NSString *tabname = tablename ?: NSStringFromClass(clazz);
    if (!condition) {
        return [NSString stringWithFormat:@"SELECT count(*) FROM %@",tabname];
    }
    return [NSString stringWithFormat:@"SELECT count(*) FROM %@ %@",tabname,condition];
}

@end
