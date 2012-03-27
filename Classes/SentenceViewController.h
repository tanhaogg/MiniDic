//
//  SentenceViewController.h
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomViewControllerProtocol.h"
#import "CutomerTextView.h"
#import "MKServiceManager.h"

@interface SentenceViewController : NSViewController<CustomViewControllerProtocol,
MKServiceManagerDelegate,CustomerTextViewDelegate> {
	@public
	IBOutlet NSPopUpButton *fromPopUpButton;
	IBOutlet NSPopUpButton *toPopUpButton;
	
	IBOutlet CutomerTextView *fromTextView;
	IBOutlet NSTextView *toTextView;
	
	NSString *fromLanguage;
	NSString *toLanguage;
	
	NSMutableArray *translates;   //存储所有已经翻译过的
	NSInteger displayIndex;       //在undo或redo的时候指向translates的编号
}

- (IBAction)buttonChange:(NSPopUpButton *)sender;
- (IBAction)translateBegin:(NSButton *)sender;
- (IBAction)changeClick:(NSButton *)sender;
- (IBAction)talkClick:(NSButton *)sender;

@end
