//
//  PCFMDatabase.h
//  LipDataBaseDemo
//
//  Created by QF on 15/11/16.
//  Copyright © 2015年 Lip.W. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JLDatabaseInterface.h"

@class FMDatabaseQueue;

@interface JLFMDatabase : NSObject <JLDatabaseInterface>

- (instancetype)initWithDbName:(NSString *)name;

@property(nonatomic, readwrite, strong) FMDatabaseQueue *db;

@end
