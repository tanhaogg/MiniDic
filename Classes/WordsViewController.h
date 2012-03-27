//
//  WordsViewController.h
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomViewControllerProtocol.h"
#import "MKServiceManager.h"
#import "CutomerTextView.h"

@interface WordsViewController : NSViewController<CustomViewControllerProtocol,
MKServiceManagerDelegate,NSTextFieldDelegate> {
	@public
	IBOutlet NSSearchField *searchField;
	IBOutlet NSTextView *toTextView;
	
	NSMutableArray *translates;   //存储所有已经翻译过的
	NSInteger displayIndex;       //在undo或redo的时候指向translates的编号
}

- (IBAction)translateBegin:(NSButton *)sender;
- (IBAction)talkClick:(NSButton *)sender;
- (IBAction)addNewWord:(NSButton *)sender;

- (void)undoAction;
- (void)redoAction;
@end
