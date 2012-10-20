#import "SqliteDB.h"

@implementation SqliteDB
- (void) initializeDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* err;
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    NSString* flagPath = [documentsDir stringByAppendingPathComponent:DBFLAG];
    
    if(![fileManager fileExistsAtPath:flagPath]) {
        NSString* dbpath = [SqliteDB getDatabasePath];
        NSString* templateDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBNAME];
        
        // remove database file
        if([fileManager fileExistsAtPath:dbpath] == YES) {
            [fileManager removeItemAtPath:dbpath error:NULL];
        }
        
        // copy database file
        if (![fileManager copyItemAtPath:templateDBPath toPath:dbpath error:&err]) {
            [err localizedDescription];
            return;
        }
        
        // dbflag file create
        [fileManager createFileAtPath:flagPath contents:nil attributes:nil];
    }    
}

+ (NSString*) getDatabasePath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:DBPATH];
}
@end
