//
//  WordNoteDao.m
//  MKDic
//
//  Created by 谭 颢 on 11-6-20.
//  Copyright 2011 天府学院. All rights reserved.
//

#import "WordNoteDao.h"
@interface WordNoteDao()
- (BOOL)tableExists;
- (NSString *)dataFilePath;
@end

static WordNoteDao *wordNoteDao=nil;

@implementation WordNoteDao

+ (id)shareDao{
	if (wordNoteDao==nil) {
		wordNoteDao=[[WordNoteDao alloc] init];
	}
	return wordNoteDao;
}

+ (void)end{
	if (wordNoteDao!=nil) {
		[wordNoteDao release];
		wordNoteDao=nil;
	}
}

- (id)init{
	self=[super init];
	if (self) {
		//打开数据库
		if (sqlite3_open([[self dataFilePath] UTF8String], &database)!=SQLITE_OK) {
			sqlite3_close(database);
			NSAssert(0,@"Faild to open database");
		}
		//建表
		if (![self tableExists]) {
			[self createTable];
		}
	}
	return self;
}

- (void)dealloc{
	sqlite3_close(database);
	[super dealloc];
}

#pragma mark -
#pragma mark CustomerFunc

- (NSString *)dataFilePath{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory=[paths objectAtIndex:0];
	NSString *miniDirectory=[documentDirectory stringByAppendingPathComponent:@"MiniDic_Data"];
	NSLog(@"%@",miniDirectory);
	if (![[NSFileManager defaultManager] isWritableFileAtPath:miniDirectory]) {
		NSError *error;
		BOOL createDir=[[NSFileManager defaultManager] createDirectoryAtPath:miniDirectory
								                 withIntermediateDirectories:YES
												                  attributes:nil
																	   error:&error];
		NSAssert(createDir,@"Create directory error:%@",error);
	}
	return [miniDirectory stringByAppendingPathComponent:kFileName];
}

//判断表是否存在
- (BOOL)tableExists{
	int number=0;
	NSString *query=kSelectExists;
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			number=sqlite3_column_int(statement, 0);
		}
	}
	NSLog(@"%d",number);
	
	return number==0?NO:YES;
}

- (BOOL)createTable{
	char *errorMsg;
	NSString *createSQL=kCreateSql;
	if (sqlite3_exec(database, [createSQL UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK) {
		sqlite3_close(database);
		NSAssert(0,@"Error creating table:%s",errorMsg);
		return NO;
	}
	return YES;
}

- (NSArray *)selectAll{
	NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
	NSString *query=kSelectAllSql;
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK) {
		while (sqlite3_step(statement)==SQLITE_ROW) {
			char *word=(char *)sqlite3_column_text(statement, 0);
			char *translate=(char *)sqlite3_column_text(statement, 1);
			int level=sqlite3_column_int(statement, 2);
			
			WordNote *wordNote=[[WordNote alloc] init];
			wordNote.word=[NSString stringWithUTF8String:word];
			wordNote.translate=[NSString stringWithUTF8String:translate];
			wordNote.level=level;
			[resultArray addObject:wordNote];
			[wordNote release];
		}
		sqlite3_finalize(statement);
	}
	return resultArray;
}

- (BOOL)insertWordNote:(WordNote *)aWordNote{
	char *errorMsg;
	char *update=kInsertObjSql;
	sqlite3_stmt *stmt;
	if (sqlite3_prepare(database, update, -1, &stmt, nil)==SQLITE_OK) {
		__strong const char *word=[aWordNote.word UTF8String];
		__strong const char *translate=[aWordNote.translate UTF8String];
		int level=aWordNote.level;
		
		sqlite3_bind_text(stmt, 1, word, -1, NULL);
		sqlite3_bind_text(stmt, 2, translate, -1, NULL);
		sqlite3_bind_int(stmt, 3, level);
	}
	if (sqlite3_step(stmt)!=SQLITE_DONE) {
		NSAssert(0,@"Error updating table:%s",errorMsg);
		sqlite3_finalize(stmt);
		return NO;
	}
	sqlite3_finalize(stmt);
	return YES;
}

- (BOOL)deleteWordNote:(NSString *)aWord{
	char *errorMsg;
	NSString *deleteString=[NSString stringWithFormat:@"%@ '%@';",kDeleteObjSql,aWord];
	__strong const char *deleteSql=[deleteString UTF8String];
	sqlite3_stmt *stmt;
	if (sqlite3_prepare(database, deleteSql, -1, &stmt, nil)==SQLITE_OK){
		if (sqlite3_step(stmt)!=SQLITE_DONE){
			NSAssert(0,@"Error delete table:%s",errorMsg);
			sqlite3_finalize(stmt);
			return NO;
		}
		sqlite3_finalize(stmt);
		return YES;
	}
	sqlite3_finalize(stmt);
	return NO;
}

@end
