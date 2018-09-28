//
//  JsonParseUtils.h
//  Capsule
//
//  Created by rogers on 14-6-11.
//  Copyright (c) 2014年 umeox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLJsonParseUtils : NSObject
/**
 *  获取类属性名 及对应类型
 *
 *  @param cls 自定义类型
 *
 *  @return key 类属性名 value 属性对应类型
 */
+ (NSDictionary *)propertiesForClass:(Class)cls;
+ (id)populateObject:(id)obj fromDictionary:(NSDictionary*)dict;
+ (id)populateObject:(id)obj fromDictionary:(NSDictionary*)dict exclude:(NSArray*)excludeArray;
+ (id)objectWithClass:(Class)cls fromDictionary:(NSDictionary*)dict;
+ (id)decodeObject:(Class)clazz from:(id)object;
+ (NSDictionary*)dictionaryForObject:(id)obj;
+ (NSDictionary*)dictionaryForObject:(id)obj include:(NSArray*)includeArray;
+ (NSMutableDictionary*)mutableDictionaryForObject:(id)obj;
+ (NSMutableDictionary*)mutableDictionaryForObject:(id)obj include:(NSArray*)includeArray;
+ (NSArray*)arrayOfClass:(Class)cls fromArray:(NSArray*)array;
+ (NSMutableArray*)mutableArrayOfClass:(Class)cls fromArray:(NSArray*)array;
+ (NSString *)populateJsonFrom:(Class)clazz fromArray:(NSArray *)array;

@end
