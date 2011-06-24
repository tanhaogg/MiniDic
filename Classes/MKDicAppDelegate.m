//
//  MKDicAppDelegate.m
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MKDicAppDelegate.h"
#import "MainViewController.h"
#import "GeneralManager.h"
#import "WordNoteDao.h"

@implementation MKDicAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {	
	mainViewController=[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
	[self.window.contentView addSubview:mainViewController.view];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag{	
	if (!flag) {
		[window makeKeyAndOrderFront:self];
	}
	return YES;
}

- (void)dealloc{
	[mainViewController release];
	[GeneralManager end];
	[WordNoteDao end];
	[super dealloc];
}

@end
