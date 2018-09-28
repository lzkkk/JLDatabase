# JLDatabase

[![CI Status](https://img.shields.io/travis/lzkkk/JLDatabase.svg?style=flat)](https://travis-ci.org/lzkkk/JLDatabase)
[![Version](https://img.shields.io/cocoapods/v/JLDatabase.svg?style=flat)](https://cocoapods.org/pods/JLDatabase)
[![License](https://img.shields.io/cocoapods/l/JLDatabase.svg?style=flat)](https://cocoapods.org/pods/JLDatabase)
[![Platform](https://img.shields.io/cocoapods/p/JLDatabase.svg?style=flat)](https://cocoapods.org/pods/JLDatabase)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JLDatabase is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JLDatabase'

```

## LinkDB

example:

```objc
NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];

NSString *name = [path stringByAppendingPathComponent:@"test.db"];
    
[[JLDatabaseManager defaultManager] linkDatabase:name];
```

## create table

conforms to protocol JLDBManagerDelegate, and implement method:

```
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
```

## application

```
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
```

use it is so easy!

## Author

lzkkk, jlgoodlucky@gmail.com

## License

JLDatabase is available under the MIT license. See the LICENSE file for more info.

