//
//  JLTestEntiy.h
//  JLDatabase_Example
//
//  Created by LeePing on 2018/9/28.
//  Copyright © 2018年 lzkkk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLDBManagerDelegate.h"

@interface JLTestEntity : NSObject<JLDBManagerDelegate>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) BOOL newbee;
@property (nonatomic, strong) NSString *ignore;
@property (nonatomic, strong) id blob;


+ (NSArray *)queryAllData;

+ (BOOL)insertTestEntity:(JLTestEntity *)entity;

+ (BOOL)updateTestEntity:(JLTestEntity *)entity;

+ (BOOL)deleteTestEntityByEmail:(NSString *)email name:(NSString *)name;

@end
