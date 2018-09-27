//
//  PCFMDatabase.h
//  LipDataBaseDemo
//
//  Created by QF on 15/11/16.
//  Copyright © 2015年 Lip.W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseQueue.h"
#import "LIPDatabaseInterface.h"


@interface LIPFMDatabase : NSObject <LIPDatabaseInterface>

- (instancetype)initWithDbName:(NSString *)name;

@property(nonatomic, readwrite, strong) FMDatabaseQueue *db;

@end
