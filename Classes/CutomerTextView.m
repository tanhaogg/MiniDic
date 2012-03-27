//
//  CutomerTextView.m
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CutomerTextView.h"


@implementation CutomerTextView
@synthesize delegate;

- (void)insertNewline:(id)sender{
	//[super insertNewline:sender];
	if ([delegate respondsToSelector:@selector(enterClick:)]) {
		[delegate enterClick:sender];
	}
}

- (id)validRequestorForSendType:(NSString *)sendType returnType:(NSString *)returnType{
	id returnObj=[super validRequestorForSendType:sendType returnType:returnType];
	return returnObj;
}

- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem{
	NSMenuItem *menuItem=(NSMenuItem *)anItem;
	if ([[menuItem title] isEqual:@"Search in Spotlight"]) {
		if ([delegate respondsToSelector:@selector(rightMenuItemClick:)]) {
			[menuItem setTitle:@"查询此单词"];
			[menuItem setTarget:self];
			[menuItem setAction:@selector(menuItemClick)];
		}
	}
	return [super validateUserInterfaceItem:anItem];
}

- (void)menuItemClick{
	if ([delegate respondsToSelector:@selector(rightMenuItemClick:)]) {
		NSArray *ranges=[self selectedRanges];
		if ([ranges count]>0) {
			NSValue *rangeVal=(NSValue *)[ranges objectAtIndex:0];
			NSRange range=[rangeVal rangeValue];
			NSString *rangeString=[[self string] substringWithRange:range];
			[delegate rightMenuItemClick:rangeString];
		}
	}
}

@end
