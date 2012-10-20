#import <Foundation/Foundation.h>
#define DBNAME @"sr4gmterm.sqlite"
#define DBPATH @"sr4gmtermdata.sqlite"
#define DBFLAG @"dbflag"

@interface SqliteDB : NSObject
- (void) initializeDatabaseIfNeeded;
+ (NSString*) getDatabasePath;
@end
