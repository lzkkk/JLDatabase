#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LIPDatabase.h"
#import "LIPDatabaseInterface.h"
#import "LIPDatabaseManager.h"
#import "LIPDatabaseUtils.h"
#import "LIPDBManagerDelegate.h"
#import "LIPFMDatabase.h"
#import "LIPFMDatabaseUtils.h"
#import "LIPJsonParseUtils.h"

FOUNDATION_EXPORT double LIPDatabaseVersionNumber;
FOUNDATION_EXPORT const unsigned char LIPDatabaseVersionString[];

