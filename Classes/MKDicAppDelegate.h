//
//  MKDicAppDelegate.h
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainViewController;
@interface MKDicAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	MainViewController *mainViewController;
}

@property (assign) IBOutlet NSWindow *window;

@end
