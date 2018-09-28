//
//  WDatabseUtils.m
//  Wherecom
//
//  Created by Umeox_Wherecom on 15/6/11.
//  Copyright (c) 2015年 umeox. All rights reserved.
//

#import "JLFMDatabaseUtils.h"
#import "JLDBManagerDelegate.h"
#import "JLJsonParseUtils.h"
#import <objc/runtime.h>
#import "FMDatabase.h"

@implementation JLFMDatabaseUtils

+ (id)populateObject:(id)obj fromResultSet:(FMResultSet *)set exclude:(NSArray *)excludeArray {
    
    if (obj == nil) {
        return nil;
    }
    Class cls = [obj class];
    NSDictionary* properties = [JLFMDatabaseUtils propertiesForClass:cls];
    for (NSString *key in [properties allKeys]) {
        id value = [self value:key type:[properties objectForKey:key] from:set clz:cls];
        if (value) {
            @try {
                [obj setValue:value forKey:key];
            }
            @catch (NSException *exception) {
                NSLog(@"Exc->name:%@,Reason:%@",exception.name,exception.reason);
                NSLog(@"Set value:%@ for key:%@  class:%@",value,key,NSStringFromClass(obj));
            }
            @finally {
            }
        }
    }
    return obj;
    
}

+ (id)populateObject:(id)obj fromResultSet:(FMResultSet *)set {
    
    obj = [JLFMDatabaseUtils populateObject:obj fromResultSet:set exclude:nil];
    return obj;
    
}

+ (id)objectWithClass:(Class)cls fromResultSet:(FMResultSet *)set {
   
    id obj = [[cls alloc] init];
    [JLFMDatabaseUtils populateObject:obj fromResultSet:set];
    return obj;
    
}

+ (NSMutableDictionary *)mutableDictionaryForObject:(id)obj {
    
    NSDictionary* propertyDict = [JLJsonParseUtils propertiesForClass:[obj class]];
    NSMutableDictionary* objDict = [NSMutableDictionary dictionaryWithDictionary:propertyDict];
    for (NSString* key in propertyDict) {
        id val = [obj valueForKey:key];
        
        [objDict setValue:val forKey:key];
    }
    return objDict;
    
}

+ (NSMutableDictionary *)mutableDictionaryForObject:(id)obj include:(NSArray *)includeArray {
    
    NSDictionary* dict = [JLJsonParseUtils dictionaryForObject:obj include:includeArray];
    return [NSMutableDictionary dictionaryWithDictionary:dict];
    
}

+ (NSDictionary*)dictionaryForObject:(id)obj {
    
    NSMutableDictionary *mutableDict = [JLJsonParseUtils mutableDictionaryForObject:obj];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
    
}

+ (NSDictionary*)dictionaryForObject:(id)obj include:(NSArray*)includeArray {
    
    NSDictionary* propertyDict = [JLJsonParseUtils propertiesForClass:[obj class]];
    NSMutableDictionary* objDict = [NSMutableDictionary dictionaryWithCapacity:includeArray.count];
    for (NSString* key in propertyDict) {
        if (includeArray && [includeArray indexOfObject:key] == NSNotFound) {
            NSLog(@"TDUtils: key %@ is skipped", key);
            continue;
        }
        id val = [obj valueForKey:key];
        [objDict setValue:val forKey:key];
    }
    return objDict;
    
}

+ (id)value:(NSString*)name type:(NSString*)type from:(FMResultSet *)set clz:(Class)clazz{
    
    BOOL isIngore = [clazz isIgnoreColumn:name];
    if (isIngore) {
        return nil;
    }else if ([[type lowercaseString] isEqualToString:@"c"]||[[type lowercaseString] isEqualToString:@"b"]) {
        return [NSNumber numberWithBool:[set boolForColumn:name]];
    }else if ([[type lowercaseString] isEqualToString:@"i"]||[[type lowercaseString] isEqualToString:@"l"]
              ||[[type lowercaseString] isEqualToString:@"q"]) {
        return [NSNumber numberWithLongLong:[set longLongIntForColumn:name]];
    }else if ([[type lowercaseString] isEqualToString:@"f"]||[[type lowercaseString] isEqualToString:@"d"]
              ||[type isEqualToString:@"NSNumber"]){
        return [NSNumber numberWithDouble:[set doubleForColumn:name]];
    }else if([type isEqualToString:@"NSString"]){
        return [set stringForColumn:name];
    }
    else{
        if ([clazz conformsToProtocol:@protocol(JLDBManagerDelegate)]) {
            BOOL isBlob = [clazz isBlobColumn:name];
            if (isBlob) {
                NSData* data = [set dataForColumn:name];
                if (data&&[data isKindOfClass:[NSData class]]) {
                    NSKeyedUnarchiver* unarcher = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                    id obj = [unarcher decodeObjectForKey:name];
                    [unarcher finishDecoding];
                    return obj;
                }
            }
            
        }
        return nil;
    }
    
}

@end
