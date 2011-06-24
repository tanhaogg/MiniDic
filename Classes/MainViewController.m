//
//  MainViewController.m
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "WordsViewController.h"
#import "SentenceViewController.h"
#import "StudyViewController.h"

@interface MainViewController()
- (void)changeViewWithIndex:(NSInteger)index;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		WordsViewController *wordsViewController=[[WordsViewController alloc] initWithNibName:@"WordsViewController" bundle:nil];
		SentenceViewController *sentenceViewController=[[SentenceViewController alloc] initWithNibName:@"SentenceViewController" bundle:nil];
		StudyViewController *studyViewController=[[StudyViewController alloc] initWithNibName:@"StudyViewController" bundle:nil];
		
		viewControllerArray=[[NSArray alloc] initWithObjects:wordsViewController,sentenceViewController,studyViewController,nil];
		[wordsViewController release];
		[sentenceViewController release];
		[studyViewController release];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationSearchWorld object:nil];
	}
	return self;
}

- (void)receiveNotification:(NSNotification *)aNotification{
	[self changeViewWithIndex:0];
}

- (void)loadView{
	[super loadView];
	
	for(NSViewController *viewController in viewControllerArray){
		[self.view addSubview:viewController.view positioned:NSWindowBelow relativeTo:nil];
	}
	[self changeViewWithIndex:0];
	[segmentedControl setSelectedSegment:0];
}

- (void)dealloc{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[viewControllerArray release];
	[super dealloc];
}

#pragma mark -
#pragma mark CustomFunc

- (void)changeViewWithIndex:(NSInteger)index{
	for (NSViewController *viewController in viewControllerArray) {
		[viewController.view setHidden:YES];
	}
	currentViewController=[viewControllerArray objectAtIndex:index];
	[currentViewController.view setHidden:NO];
	[currentViewController setFirstResponder];
	
	if (index==2) {
		[undoSegmentControl setHidden:YES];
	}else {
		[undoSegmentControl setHidden:NO];
	}

}

- (IBAction)segmentClick:(NSSegmentedControl *)sender{
	[self changeViewWithIndex:[sender selectedSegment]];
}

- (IBAction)fontChangeClick:(NSSegmentedControl *)sender{
	CGFloat size=12.0;
	NSString *name=@"STHeitiSC-Light";
	NSFont *selectFont = [[NSFontManager sharedFontManager] selectedFont];
	if (selectFont!=nil) {
		size=[selectFont pointSize];
		name=[selectFont fontName];
	}
	
	if ([sender selectedSegment]==0) {
		size-=2;
	}else {
		size+=2;
	}
	
	selectFont=[NSFont fontWithName:name size:size];
	[[NSFontManager sharedFontManager] setSelectedFont:selectFont isMultiple:NO];
	
	[currentViewController changeFont:selectFont];
}

- (IBAction)undoClick:(NSSegmentedControl *)sender{
	if ([sender selectedSegment]==0) {
		[currentViewController undoAction];
	}else {
		[currentViewController redoAction];
	}
}

@end
