//
//  WDatabseUtils.h
//  Wherecom
//
//  Created by Umeox_Wherecom on 15/6/11.
//  Copyright (c) 2015年 umeox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "LIPDatabaseUtils.h"

@interface LIPFMDatabaseUtils : LIPDatabaseUtils

//将对象转换成 parames (NSDictionary)
+ (NSDictionary*)dictionaryForObject:(id)obj;
+ (NSDictionary*)dictionaryForObject:(id)obj include:(NSArray*)includeArray;
+ (NSMutableDictionary*)mutableDictionaryForObject:(id)obj;
+ (NSMutableDictionary*)mutableDictionaryForObject:(id)obj include:(NSArray*)includeArray;

//将DB set对象转换成 对应 obj
+ (id)populateObject:(id)obj fromResultSet:(FMResultSet*)set;
+ (id)populateObject:(id)obj fromResultSet:(FMResultSet*)set exclude:(NSArray*)excludeArray;
+ (id)objectWithClass:(Class)cls fromResultSet:(FMResultSet*)set;

@end
