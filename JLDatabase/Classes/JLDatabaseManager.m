//
//  PCDatabaseManager.m
//  LipDataBaseDemo
//
//  Created by QF on 15/11/16.
//  Copyright © 2015年 Lip.W. All rights reserved.
//

#import "JLDatabaseManager.h"
#import "JLFMDatabase.h"

@class JLDatabaseManager;
static JLDatabaseManager *defaultManager = nil;

@interface JLDatabaseManager()
@property (nonatomic, readwrite, strong) id <JLDatabaseInterface> database;
@end

@implementation JLDatabaseManager 

+ (instancetype)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[JLDatabaseManager alloc] init];
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
- (id<JLDatabaseInterface>)createDatabase:(NSString *)name{
    if (!_database) {
        _database = [[JLFMDatabase alloc] initWithDbName:name];
    }
    return _database;
}
@end
