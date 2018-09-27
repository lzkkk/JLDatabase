//
//  LIPDBManagerDelegate.h
//  PokerClub
//
//  Created by QF on 15/12/8.
//  Copyright © 2015年 Lip. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LIPDBManagerDelegate

//用来确定特殊字段  如（PRIMARY KEY,UNIQUE,NO NULL,AUTOINCREMENT)
@required
+ (NSArray *)requestedColumns;

+ (NSDictionary *)columnExtras;

+ (BOOL)isBlobColumn:(NSString *)name;

+ (BOOL)isIgnoreColumn:(NSString *)name;

@optional
+ (NSArray *)columnPrimaryKey;

@end