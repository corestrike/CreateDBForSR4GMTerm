//
//  DocumentReader.h
//  SR4GMManageTerminal
//
//  Created by corestrike on 2012/10/05.
//
//

#import <Foundation/Foundation.h>
#import "Mecab.h"

@class Mecab;

@interface DocumentReader : NSObject
+ (void)insertInitialData;
+ (NSString*)parseJapaneseWord:(Mecab*)mecab:(NSString*)str;
@end
