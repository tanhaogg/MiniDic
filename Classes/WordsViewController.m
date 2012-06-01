//
//  WordsViewController.m
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WordsViewController.h"
#import "GeneralManager.h"
#import "GDataXMLNode.h"
#import "WordNoteDao.h"

@implementation WordsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) 
    {
		translates=[[NSMutableArray alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:kNotificationSearchWorld object:nil];
	}
	return self;
}

- (void)receiveNotification:(NSNotification *)aNotification
{
	[self performSelector:@selector(rightMenuItemClick:) withObject:[aNotification object]];
}

- (void)loadView
{
	[super loadView];
	searchField.delegate=self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[translates release];
	[super dealloc];
}

#pragma mark -
#pragma mark CustomFunc

- (IBAction)translateBegin:(NSButton *)sender
{
	[[GeneralManager shareManager] stopSpeak];
	
	NSString *string=[searchField stringValue];
	if ([string length]==0) 
    {
		return;
	}
	
	//此处利用了异步加载
    //NSString *urlstring = [NSString stringWithFormat:@"http://dict.cn/ws.php?q=%@",string];
    NSString *urlstring = [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=tanhao&key=881024171&type=data&doctype=xml&version=1.1&q=%@",string];
    NSString *encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlstring, NULL, NULL,  kCFStringEncodingUTF8 );
    [[MKServiceManager sharedManager] cancelForDelegate:self];
    [[MKServiceManager sharedManager] downloadWithURL:[NSURL URLWithString:encodedString] delegate:self context:nil];
    
	[toTextView setString:@"请等待⋯⋯"];
    CFRelease(encodedString);
	return;
}

- (IBAction)talkClick:(NSButton *)sender
{
	[[GeneralManager shareManager] speakWithText:[searchField stringValue]];
}

- (IBAction)addNewWord:(NSButton *)sender
{
	WordNote *wordNote=[[WordNote alloc] init];
	static int mm=100;
	wordNote.row=mm++;
	wordNote.word=[searchField stringValue];
	wordNote.translate=[toTextView string];
	wordNote.level=0;
	
	[[WordNoteDao shareDao] insertWordNote:wordNote];
	[wordNote release];
}

- (void)translateEnd
{
	while ([translates count]>displayIndex+1) 
    {
		[translates removeLastObject];
	}
	
	NSString *searchVal=[NSString stringWithString:[searchField stringValue]];
	NSString *translVal=[NSString stringWithString:[toTextView string]];
	NSArray *currentTrans=[[NSArray alloc] initWithObjects:searchVal,translVal,nil];
	[translates addObject:currentTrans];
	[currentTrans release];
	
	displayIndex=[translates count]-1;
}

- (void)undoAction
{
	if (displayIndex>0) 
    {
		--displayIndex;
		NSArray *currentTrans=[translates objectAtIndex:displayIndex];
		[searchField setStringValue:(NSString *)[currentTrans objectAtIndex:0]];
		[toTextView  setString:(NSString *)[currentTrans objectAtIndex:1]];
	}
}

- (void)redoAction
{
	if ([translates count]>displayIndex+1) 
    {
		++displayIndex;
		NSArray *currentTrans=[translates objectAtIndex:displayIndex];
		[searchField setStringValue:(NSString *)[currentTrans objectAtIndex:0]];
		[toTextView  setString:(NSString *)[currentTrans objectAtIndex:1]];
	}
}


#pragma mark -
#pragma mark MKServiceManagerDelegate

- (NSString *)readXmlInfo:(NSString *)aString
{
    NSMutableString *displayString=[[[NSMutableString alloc] init] autorelease];
	
	NSError *error;
	//NSStringEncoding encoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSStringEncoding encoding=NSUTF8StringEncoding;
	NSData *data=[aString dataUsingEncoding:encoding];
	GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	GDataXMLElement *rootNode = [document rootElement];
    
    //自动纠错
	NSArray *sugg=[rootNode nodesForXPath:@"//dict/sugg" error:&error];
	if ([sugg count]>0) {
		[displayString appendFormat:@"您要查找的是不是:\n"];
		for(GDataXMLNode* node in sugg){
			[displayString appendFormat:@"%@    ",[node stringValue]];
		}
	}
	//读音
	NSArray *pron = [rootNode nodesForXPath:@"//basic/phonetic" error:&error];
	if ([pron count]>0) {
		[displayString appendFormat:@"读音: %@\n\n",[[pron objectAtIndex:0] stringValue]];
	}
    //解释
	NSArray *def = [rootNode nodesForXPath:@"//basic/explains/ex" error:&error];
	if ([def count]>0) 
    {
        [displayString appendFormat:@"释义:\n"];
		for (int i=0; i<[def count]; i++) 
        {		
			[displayString appendFormat:@"%@\n",[[def objectAtIndex:i] stringValue]];
		}
	}
    //例句
	NSArray *orig = [rootNode nodesForXPath:@"//explain/key" error:&error];
	NSArray *trans= [rootNode nodesForXPath:@"//explain/value/ex" error:&error];
	if ([orig count]>0) {
		[displayString appendFormat:@"\n例句:\n"];
		for (int i=0; i<[orig count]; i++) 
        {		
			[displayString appendFormat:@"%@\n%@\n",[[orig objectAtIndex:i] stringValue],[[trans objectAtIndex:i] stringValue]];
		}
	}
    
    [document release];
	return displayString;
}


- (NSString *)readXmlInfoOld:(NSString *)aString{
	NSMutableString *displayString=[[[NSMutableString alloc] init] autorelease];
	
	NSError *error;
	//NSStringEncoding encoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSStringEncoding encoding=NSUTF8StringEncoding;
	NSData *data=[aString dataUsingEncoding:encoding];
	GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	GDataXMLElement *rootNode = [document rootElement];
	
	//自动纠错
	NSArray *sugg=[rootNode nodesForXPath:@"//dict/sugg" error:&error];
	if ([sugg count]>0) {
		[displayString appendFormat:@"您要查找的是不是:\n"];
		for(GDataXMLNode* node in sugg){
			[displayString appendFormat:@"%@    ",[node stringValue]];
		}
	}
	//读音
	NSArray *pron = [rootNode nodesForXPath:@"//dict/pron" error:&error];
	if ([pron count]>0) {
		[displayString appendFormat:@"读音: %@\n\n",[[pron objectAtIndex:0] stringValue]];
	}
	//解释
	NSArray *def = [rootNode nodesForXPath:@"//dict/def" error:&error];
	if ([def count]>0) {
		[displayString appendFormat:@"释义:\n%@\n\n",[[def objectAtIndex:0] stringValue]];
	}
	//例句
	NSArray *orig = [rootNode nodesForXPath:@"//dict/sent/orig" error:&error];
	NSArray *trans= [rootNode nodesForXPath:@"//dict/sent/trans" error:&error];
	if ([orig count]>0) {
		[displayString appendFormat:@"例句:\n"];
		for (int i=0; i<[orig count]; i++) {		
			[displayString appendFormat:@"%@\n%@\n",[[orig objectAtIndex:i] stringValue],[[trans objectAtIndex:i] stringValue]];
		}
	}
	//替换掉<em>和</em>标签
	[displayString replaceOccurrencesOfString:@"<em>" withString:@"" options:0 range:NSMakeRange(0, [displayString length])];
	[displayString replaceOccurrencesOfString:@"</em>" withString:@"" options:0 range:NSMakeRange(0, [displayString length])];
	
    [document release];
	return displayString;
}

- (void)serviceFinish:(MKServiceManager *)webService didReceiveData:(NSData *)data context:(id)context
{
    //NSStringEncoding encoding=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSStringEncoding encoding=NSUTF8StringEncoding;
	NSString *receiveString = [[NSString alloc] initWithData:data encoding:encoding];
	if (receiveString==nil) 
    {
		[toTextView setString:@"No Define !"];
		return;
	}	
	
	NSString *displayString=[self readXmlInfo:receiveString];
	[toTextView setString:displayString];
    
    if ([displayString length] == 0)
    {
        [toTextView setString:@"查无此单词！"];
    }
	
    [receiveString release];
	[self translateEnd];
}

- (void)servicFail:(MKServiceManager *)webService didFailWithError:(NSError *)error context:(id)context
{
    [toTextView setString:[error description]];
}

#pragma mark -
#pragma mark NSControlTextEditingDelegate

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	[self translateBegin:nil];
	return YES;
}

#pragma mark -
#pragma mark CustomViewControllerProtocol

- (void)quickTranslateWithString:(NSString *)str
{
    [searchField setStringValue:str];
    [self translateBegin:nil];
}

- (void)setFirstResponder
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window makeFirstResponder:searchField];
    });
	//[searchField becomeFirstResponder];
}

- (void)changeFont:(NSFont *)aFont
{
	[toTextView setFont:aFont];
}

#pragma mark -
#pragma mark CustomerTextViewDelegate

- (void)rightMenuItemClick:(NSString *)aText
{
	[searchField setStringValue:aText];
	[self translateBegin:nil];
}

@end
