//
//  StudyViewController.h
//  MKDic
//
//  Created by stm on 11-6-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomViewControllerProtocol.h"

@interface StudyViewController : NSViewController<CustomViewControllerProtocol,
NSTableViewDelegate,NSTableViewDataSource> {
	IBOutlet NSTableView *currentTableView;
	IBOutlet NSTextView *studyTextView;
	NSMutableArray *objArray;
}
@property (nonatomic,retain) NSMutableArray *objArray;

- (IBAction)addLevel:(NSButton *)sender;
- (IBAction)minusLevel:(NSButton *)sender;
- (IBAction)deleteWord:(NSButton *)sender;
- (IBAction)talkClick:(NSButton *)sender;

@end
