//
//  DocumentReader.m
//  SR4GMManageTerminal
//
//  Created by corestrike on 2012/10/05.
//
//

#import "DocumentReader.h"
#import "FMDatabase.h"
#import "SqliteDB.h"
#import "FileReader.h"
#import "Node.h"

@implementation DocumentReader
+ (void)insertInitialData
{
    NSString* dbPath = [SqliteDB getDatabasePath];
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];

    if(![db open]) {
        return;
    }
    [db setShouldCacheStatements:YES];

    FMResultSet *tableExistRS = [db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='reference';"];
    if (NO == [tableExistRS next]) {
        [db beginTransaction];
        BOOL tableCreated = [db executeUpdate:@"CREATE VIRTUAL TABLE reference USING fts4(category INTEGER, word TEXT, jword TEXT, jwordread TEXT, page TEXT, jpage TEXT);"];
        if (tableCreated == NO) {
            NSLog(@"*** Failed: %d (%@)", [db lastErrorCode], [db lastErrorMessage]);
            return;
        }else{
            NSLog(@"OK, Virtual Table created.");
        }
        [db commit];
    }

//    Mecab* mecab = [[Mecab new] autorelease];
    FMResultSet *existRecords = [db executeQuery:@"SELECT * FROM reference WHERE rowid = 1;"];
    if (NO == [existRecords next]) {
        [db beginTransaction];
        FileReader *txtFileReader = [[FileReader alloc] initWithFilePath:[[NSBundle mainBundle] pathForResource:@"sr4data_utf8" ofType:@"txt"]];
        __block int readLines = 0;
        [txtFileReader enumerateLinesUsingBlock:^(NSString *aNewLine, BOOL *stop) {
            if(readLines < 1){
                readLines++;
                return;
            }
            if (readLines >= 1370) {
                FMResultSet *result = [db executeQuery:@"SELECT count(*) from reference;"];
                if ([result next]) {
                    NSLog(@"Result: imported %d records", [result intForColumnIndex:0]);
                }else{
                    NSLog(@"Result: finished importing, but has no data.");
                }
                *stop = YES;
            }
            @autoreleasepool {
                NSArray *arr = [aNewLine componentsSeparatedByString:@"|"];
                NSNumber *category = [NSNumber numberWithInt:[[arr objectAtIndex:0] intValue]];
                NSString *word = [arr objectAtIndex:1];
                NSString *jword = [arr objectAtIndex:2];
                NSString *jwordread = [arr objectAtIndex:3];
                NSString *page = [arr objectAtIndex:4];
                NSString *jpage = [arr objectAtIndex:5];
//                NSLog(@"%@", [self parseJapaneseWord:mecab :jword]);
//                NSLog(@"%@, %@, %@, %@, %@", category, word, jword, page, jpage);
                [db executeUpdate:@"INSERT INTO reference(category, word, jword, jwordread, page, jpage) VALUES(?, ?, ?, ?, ?, ?);", category, word, jword, jwordread, page, jpage];
                if (readLines % 100 == 0) {
                    NSLog(@"Reaches line: %d", readLines);
                }                
            }
            readLines++;
        }];
        [db commit];
        [db close];
    }else{
        FMResultSet *numberOfRecords = [db executeQuery:@"SELECT count(*) FROM reference;"];
        NSLog(@"Already has %d records.", [numberOfRecords intForColumnIndex:0]);
        [db close];
    }
}

+ (NSString*)parseJapaneseWord:(Mecab *)mecab :(NSString *)str
{
    NSArray *arr = [mecab parseToNodeWithString:str];
    NSMutableString* returnStr = [NSMutableString stringWithString:str];
    [returnStr appendString:@" ["];
    for(Node* node in arr){
        [returnStr appendString:node.surface];
        [returnStr appendString:@" "];
    }
    [returnStr appendString:@"]"];
    return returnStr;
}
@end
