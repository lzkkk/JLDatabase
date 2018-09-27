//
//  PCDatabaseManager.h
//  LipDataBaseDemo
//
//  Created by QF on 15/11/16.
//  Copyright © 2015年 Lip.W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIPDatabaseInterface.h"


@interface LIPDatabaseManager : NSObject

+ (instancetype)defaultManager;
@property (nonatomic, readonly, strong) id <LIPDatabaseInterface> database;
- (void)linkDatabase:(NSString *)name;

@end
