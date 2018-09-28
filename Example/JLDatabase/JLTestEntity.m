//
//  JLTestEntiy.m
//  JLDatabase_Example
//
//  Created by LeePing on 2018/9/28.
//  Copyright © 2018年 lzkkk. All rights reserved.
//

#import "JLTestEntity.h"
#import "JLDatabase.h"

@implementation JLTestEntity


+ (NSArray *)queryAllData {
    return [[JLDatabaseManager defaultManager].database queryTableFromClazz:[JLTestEntity class] where:nil];
}

+ (BOOL)insertTestEntity:(JLTestEntity *)entity{
    return [[JLDatabaseManager defaultManager].database insertTableParameFromArray:@[entity] clazz:[JLTestEntity class] update:YES];
}

+ (BOOL)updateTestEntity:(JLTestEntity *)entity {
    return [[JLDatabaseManager defaultManager].database updateTableParameFromObj:entity where:[NSString stringWithFormat:@"WHERE email=%@ and  name =%@", entity.email, entity.name]];
}

+ (BOOL)deleteTestEntityByEmail:(NSString *)email name:(NSString *)name {
    return [[JLDatabaseManager defaultManager].database deleteTableParameFromClazz:[JLTestEntity class] where:[NSString stringWithFormat:@"WHERE email=%@ and name=%@", email, name]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"email: %@ \n name= %@ \n age: %zi \n newBee= %zi \n blob=%@ \n ignore=%@", self.email, self.name, self.age, self.newbee, self.blob, self.ignore];
}

#pragma mark JLDBManageDelegate
//NOT NULL， UNIQUE etc
+ (NSDictionary *)columnExtras{
    return @{@"email":@"NOT NULL",
             @"name":@"NOT NULL"
             };
}

//is blob in db
+ (BOOL)isBlobColumn:(NSString *)name {
    return [name isEqualToString:@"blob"];
}

// ignore key not in column
+ (BOOL)isIgnoreColumn:(NSString *)name {
    return [name isEqualToString:@"ignore"];
}

// primary keys
+ (NSArray *)columnPrimaryKey {
    return @[@"email", @"name"];
}


@end
