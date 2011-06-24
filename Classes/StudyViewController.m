//
//  StudyViewController.m
//  MKDic
//
//  Created by stm on 11-6-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StudyViewController.h"
#import "GeneralManager.h"
#import "GDataXMLNode.h"
#import "WordNoteDao.h"

@implementation StudyViewController
@synthesize objArray;

- (IBAction)addLevel:(NSButton *)sender{
	NSInteger selectedRow=[currentTableView selectedRow];
	if (selectedRow<0) {
		return;
	}
	WordNote *wordNode=[objArray objectAtIndex:selectedRow];
	if (wordNode.level<3) {
		wordNode.level++;
		
		[[WordNoteDao shareDao] insertWordNote:wordNode];
		NSIndexSet *rowIndexes=[NSIndexSet indexSetWithIndex:selectedRow];
		NSIndexSet *columnIndexes=[NSIndexSet indexSetWithIndex:1];	
		[currentTableView reloadDataForRowIndexes:rowIndexes columnIndexes:columnIndexes];
	}
}

- (IBAction)minusLevel:(NSButton *)sender{
	NSInteger selectedRow=[currentTableView selectedRow];
	if (selectedRow<0) {
		return;
	}
	WordNote *wordNode=[objArray objectAtIndex:selectedRow];
	if (wordNode.level>0) {
		wordNode.level--;
		
		[[WordNoteDao shareDao] insertWordNote:wordNode];
		NSIndexSet *rowIndexes=[NSIndexSet indexSetWithIndex:selectedRow];
		NSIndexSet *columnIndexes=[NSIndexSet indexSetWithIndex:1];	
		[currentTableView reloadDataForRowIndexes:rowIndexes columnIndexes:columnIndexes];
	}
}

- (IBAction)deleteWord:(NSButton *)sender{
	NSInteger selectedRow=[currentTableView selectedRow];
	if (selectedRow<0) {
		return;
	}
	WordNote *wordNode=[objArray objectAtIndex:selectedRow];
	[[WordNoteDao shareDao] deleteWordNote:wordNode.word];
	[self.objArray removeObjectAtIndex:selectedRow];
	[currentTableView reloadData];
	
	//刷新表格之后取得新的选中项
	selectedRow=[currentTableView selectedRow];
	if (selectedRow<0) {
		return;
	}
	wordNode=[objArray objectAtIndex:selectedRow];
	[studyTextView setString:wordNode.translate];
}

- (IBAction)talkClick:(NSButton *)sender{
	NSInteger selectedRow=[currentTableView selectedRow];
	if (selectedRow<0) {
		return;
	}
	WordNote *wordNode=[objArray objectAtIndex:selectedRow];
	[[GeneralManager shareManager] speakWithText:wordNode.word];
}

#pragma mark -
#pragma mark NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
	return [objArray count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
	
	//NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:12.0], NSFontAttributeName, nil];
    //return [[[NSAttributedString alloc] initWithString:@"Test" attributes:attr] autorelease];
	
	WordNote *wordNode=[objArray objectAtIndex:row];
	if ([[tableView tableColumns] indexOfObject:tableColumn]==0) {
		return wordNode.word;
	}else {
		return [NSNumber numberWithInt:wordNode.level];
	}
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
	WordNote *wordNode=[objArray objectAtIndex:row];
	wordNode.level=[object intValue];
	[[WordNoteDao shareDao] insertWordNote:wordNode];
	
	NSIndexSet *rowIndexes=[NSIndexSet indexSetWithIndex:row];
	NSIndexSet *columnIndexes=[NSIndexSet indexSetWithIndex:1];	
	[tableView reloadDataForRowIndexes:rowIndexes columnIndexes:columnIndexes];
}

#pragma mark -
#pragma mark NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
	WordNote *wordNode=[objArray objectAtIndex:row];
	[studyTextView setString:wordNode.translate];
	return YES;
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView{
	return YES;
}

- (void)tableView:(NSTableView *)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn{
	
	NSString *sortKey=nil;             //按哪个键排序
	BOOL ascending;
	static BOOL wordAscending=YES;     //单词升序
	static BOOL levelAscending=YES;    //熟练升序
	
	
	if ([[tableView tableColumns] indexOfObject:tableColumn]==0) {
		wordAscending=!wordAscending;
		ascending=wordAscending;
		sortKey=@"word";
	}else {
		levelAscending=!levelAscending;
		ascending=levelAscending;
		sortKey=@"level";
	}	
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	[objArray sortUsingDescriptors:sortDescriptors];
	[sortDescriptor release];
	
	[tableView reloadData];
	
	NSInteger selectedRow=[currentTableView selectedRow];
	if (selectedRow>=0) {
		WordNote *wordNode=[objArray objectAtIndex:selectedRow];
		[studyTextView setString:wordNode.translate];
	}
}

#pragma mark -
#pragma mark CustomViewControllerProtocol

- (void)setFirstResponder{
	self.objArray=[[[WordNoteDao shareDao] selectAll] retain];
	[currentTableView reloadData];
	return;
}

- (void)changeFont:(NSFont *)aFont{
	[studyTextView setFont:aFont];
}

- (void)undoAction{
	NULL;
}

- (void)redoAction{
	NULL;
}

#pragma mark -
#pragma mark CustomTextViewDelegate

- (void)rightMenuItemClick:(NSString *)aText{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSearchWorld object:aText userInfo:nil];
}
								
@end
