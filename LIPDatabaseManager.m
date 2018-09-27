//
//  PCDatabaseManager.m
//  LipDataBaseDemo
//
//  Created by QF on 15/11/16.
//  Copyright © 2015年 Lip.W. All rights reserved.
//

#import "LIPDatabaseManager.h"
#import "LIPFMDatabase.h"

@class LIPDatabaseManager;
static LIPDatabaseManager *defaultManager = nil;

@interface LIPDatabaseManager()
@property (nonatomic, readwrite, strong) id <LIPDatabaseInterface> database;
@end

@implementation LIPDatabaseManager 

+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[LIPDatabaseManager alloc] init];
    });
    return defaultManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [super allocWithZone:zone];
    });
    return defaultManager;
}

- (id)copy{
    return self;
}

#pragma mark - public 
- (void)linkDatabase:(NSString *)name
{
    _database = nil;
    [self createDatabase:name];
}

#pragma mark - Getter
- (id<LIPDatabaseInterface>)createDatabase:(NSString *)name{
    if (!_database) {
        _database = [[LIPFMDatabase alloc] initWithDbName:name];
    }
    return _database;
}
@end
