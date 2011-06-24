//
//  MainViewController.h
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomViewControllerProtocol.h"

@interface MainViewController : NSViewController {
	IBOutlet NSSegmentedControl *segmentedControl;
	IBOutlet NSSegmentedControl *undoSegmentControl;
	
	NSArray *viewControllerArray;                                            //存储所有的viewController
	NSViewController<CustomViewControllerProtocol> *currentViewController;   //当前活跃的viewController
}

- (IBAction)segmentClick:(NSSegmentedControl *)sender;      //功能选择
- (IBAction)fontChangeClick:(NSSegmentedControl *)sender;   //字体修改
- (IBAction)undoClick:(NSSegmentedControl *)sender;         //undo或者redo操作
@end
