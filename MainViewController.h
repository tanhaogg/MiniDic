//
//  MainViewController.h
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WordsViewController;
@class SentenceViewController;
@interface MainViewController : NSViewController {
	IBOutlet NSButton *changeButton;
	
	WordsViewController *wordsViewController;
	SentenceViewController *sentenceViewController;
}

- (IBAction)changeClick:(NSButton *)sender;

@end
