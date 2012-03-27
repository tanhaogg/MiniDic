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
	
	NSArray *viewControllerArray;
	NSViewController<CustomViewControllerProtocol> *currentViewController;
}

- (IBAction)segmentClick:(NSSegmentedControl *)sender;
- (IBAction)fontChangeClick:(NSSegmentedControl *)sender;

- (IBAction)undoClick:(NSSegmentedControl *)sender;
@end
