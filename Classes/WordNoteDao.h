//
//  WordNoteDao.h
//  MKDic
//
//  Created by 谭 颢 on 11-6-20.
//  Copyright 2011 天府学院. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "WordNote.h"
//#import "/usr/include/sqlite3.h"
#import "sqlite3.h"

#define kFileName      @"data.sqlite3"

#define kSelectExists  @"select count(*) from sqlite_master where type='table' and name='WORDS';"
#define kCreateSql     @"CREATE TABLE IF NOT EXISTS WORDS(WORD TEXT PRIMARY KEY,TRANSLATION TEXT,STUDYLEVEL INTEGER);"
#define kSelectAllSql  @"SELECT * FROM WORDS"
#define kInsertObjSql  "INSERT OR REPLACE INTO WORDS (WORD,TRANSLATION,STUDYLEVEL) VALUES (?,?,?);"
#define kDeleteObjSql  @"Delete From WORDS where WORD="

@interface WordNoteDao : NSObject {
	sqlite3 *database;
}
+ (id)shareDao;
+ (void)end;

- (BOOL)createTable;
- (NSArray *)selectAll;
- (BOOL)insertWordNote:(WordNote *)aWordNote;
- (BOOL)deleteWordNote:(NSString *)aWord;

@end
