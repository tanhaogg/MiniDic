//
//  StudyViewController.h
//  MKDic
//
//  Created by stm on 11-6-17.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomViewControllerProtocol.h"
#import "DownLoadData.h"

@interface StudyViewController : NSViewController<CustomViewControllerProtocol,
NSTableViewDelegate,NSTableViewDataSource> {
	IBOutlet NSTableView *currentTableView;
	IBOutlet NSTextView *studyTextView;
	NSMutableArray *objArray;                 //objArray保存所有的woldNote对象
}
@property (nonatomic,retain) NSMutableArray *objArray;

- (IBAction)addLevel:(NSButton *)sender;       //增加熟练度
- (IBAction)minusLevel:(NSButton *)sender;     //减少熟练度
- (IBAction)deleteWord:(NSButton *)sender;     //删除当前单词
- (IBAction)talkClick:(NSButton *)sender;      //talk当前的单词

@end
