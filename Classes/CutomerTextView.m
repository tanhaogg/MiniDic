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


//此方法主要想获取用户敲回车之后的事件(这样写可能也不是很科学)
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

//这个地方用了很笨的办法，修改了右键后弹出的功能选项（求高手指引在在右键菜单中如何添加一个新的menuItem）
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
