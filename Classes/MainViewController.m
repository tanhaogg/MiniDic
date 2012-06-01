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

- (IBAction)supportClick:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.tanhao.me"]];
}

#pragma mark -
#pragma mark Service

- (NSString *)getStringWith:(NSPasteboard *)pboard
                   userData:(NSString *)data // typed as what we handle
                      error:(NSString **)error
{
    NSString *pboardString;
	NSString *newString;
	NSArray *types;
    
	types = [pboard types];
	
	// if there's a problem with the data passed to this method
	if(![types containsObject:NSStringPboardType] ||
       !(pboardString = [pboard stringForType:NSStringPboardType]))
	{
		*error = NSLocalizedString(@"Error: Pasteboard doesn't contain a string.",
                                   @"Pasteboard couldn't give a string.");
		// if there's a problem then it'll be sure to tell us!
		return NSLocalizedString(@"Error: Pasteboard doesn't contain a string.",
                                 @"Pasteboard couldn't give a string.");
	}
    
	// here is where our capitalizing code goes
	newString = [pboardString capitalizedString]; // it's that easy!
    
	// the next block checks to see if there was an error while capitalizing
	if(!newString)
	{
		*error = NSLocalizedString(@"Error: Couldn't capitalize string $@.",
                                   @"Couldn't perform service operation.");
		// again, it lets us know of any trouble
		return NSLocalizedString(@"Error: Couldn't capitalize string $@.",
                                 @"Couldn't perform service operation.");
	}
    
	// the next bit tells the system what it's returning
	types = [NSArray arrayWithObject:NSStringPboardType];
    
	[pboard declareTypes:types
	               owner:nil];
	
	// and then this sets the string to our capitalized version
	[pboard setString:newString
	          forType:NSStringPboardType];
    
	return newString;
}

- (void)srvSearch:(NSPasteboard *)pboard
        userData:(NSString *)data // typed as what we handle
           error:(NSString **)error
{
	NSString *string = [self getStringWith:pboard userData:data error:error];
    [self changeViewWithIndex:0];
    [currentViewController quickTranslateWithString:string];
    [segmentedControl setSelectedSegment:0];
    [self.view.window makeKeyAndOrderFront:self];
}

- (void)srvTranslate:(NSPasteboard *)pboard
            userData:(NSString *)data // typed as what we handle
               error:(NSString **)error
{
	NSString *string = [self getStringWith:pboard userData:data error:error];
    [self changeViewWithIndex:1];
    [currentViewController quickTranslateWithString:string];
    [segmentedControl setSelectedSegment:1];
    [self.view.window makeKeyAndOrderFront:self];
}



@end
