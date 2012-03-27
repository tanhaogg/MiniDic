//
//  SentenceViewController.m
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SentenceViewController.h"
#import "GeneralManager.h"
#import "GDataXMLNode.h"


@interface SentenceViewController()
- (void)translateEnd;
@end

static NSString *allLanguage[]={
	@"zh-CHS",@"en",@"ja"
};
static NSString *bingKey = @"408DC1DA22200F983E20EAC99A1D283A5EC5AB79";

@implementation SentenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) 
    {
		translates=[[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView
{
	[super loadView];
	
	NSInteger fromIndex=1;
	NSInteger toIndex=0;
	fromLanguage=allLanguage[fromIndex];
	toLanguage=allLanguage[toIndex];
	
	[fromPopUpButton selectItemAtIndex:fromIndex];
	[toPopUpButton selectItemAtIndex:toIndex];
	
	fromTextView.delegate=self;
}

- (void)dealloc{
	[translates release];
	[super dealloc];
}

#pragma mark -
#pragma mark CustomFunc

- (IBAction)buttonChange:(NSPopUpButton *)sender
{
	NSInteger index=[sender indexOfSelectedItem];
	if (sender==fromPopUpButton) {
		fromLanguage=allLanguage[index];
	}else {
		toLanguage=allLanguage[index];
	}
	
}

- (IBAction)translateBegin:(NSButton *)sender
{
	[[GeneralManager shareManager] stopSpeak];
	
	NSString *string=[fromTextView string];
	if ([string length]==0) 
    {
		return;
	}
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.microsofttranslator.com/V2/http.svc/translate?appId=%@&text=%@&from=%@&to=%@",bingKey,string,fromLanguage,toLanguage];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[MKServiceManager sharedManager] cancelForDelegate:self];
    [[MKServiceManager sharedManager] downloadWithURL:[NSURL URLWithString:urlStr] delegate:self context:nil];
    
	[toTextView setString:@"请等待⋯⋯"];
	return;
}

- (IBAction)changeClick:(NSButton *)sender
{
	NSInteger fromIndex=[fromPopUpButton indexOfSelectedItem];
	NSInteger toIndex=[toPopUpButton indexOfSelectedItem];
	
	fromLanguage=allLanguage[toIndex];
	toLanguage=allLanguage[fromIndex];
	
	[fromPopUpButton selectItemAtIndex:toIndex];
	[toPopUpButton selectItemAtIndex:fromIndex];
}

- (IBAction)talkClick:(NSButton *)sender
{
	
	NSInteger fromIndex=[fromPopUpButton indexOfSelectedItem];
	NSInteger toIndex=[toPopUpButton indexOfSelectedItem];
	if (fromIndex==1) {
		[[GeneralManager shareManager] speakWithText:[fromTextView string]];
	}
	else if(toIndex==1){
		[[GeneralManager shareManager] speakWithText:[toTextView string]];
	}
}

#pragma mark -
#pragma mark MKServiceManagerDelegate

- (void)serviceFinish:(MKServiceManager *)webService didReceiveData:(NSData *)data context:(id)context
{
    NSError *error;
	GDataXMLDocument* document = [[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
	GDataXMLElement *rootNode = [document rootElement];
    NSString *stingline = [rootNode stringValue];
    if (stingline.length == 0)
    {
        stingline = @"没有找到结果!";
    }
    
	[toTextView setString:stingline];
    [document release];
	[self translateEnd];
}

- (void)servicFail:(MKServiceManager *)webService didFailWithError:(NSError *)error context:(id)context
{
    [toTextView setString:@"加载超时，请检查是否连接网络⋯⋯"];
}

#pragma mark -
#pragma mark CustomTextViewDelegate

- (void)enterClick:(id)sender
{
	[self translateBegin:nil];
}

- (void)rightMenuItemClick:(NSString *)aText
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSearchWorld object:aText userInfo:nil];
}

#pragma mark -
#pragma mark CustomViewControllerProtocol

- (void)quickTranslateWithString:(NSString *)str
{
    [fromTextView setString:str];
    [self translateBegin:nil];
}

- (void)setFirstResponder
{
	[[fromTextView superview] becomeFirstResponder];
}

- (void)changeFont:(NSFont *)aFont
{
	[fromTextView setFont:aFont];
	[toTextView setFont:aFont];
}

- (void)translateEnd
{
	while ([translates count]>displayIndex+1) 
    {
		[translates removeLastObject];
	}
	
	NSString *searchVal=[NSString stringWithString:[fromTextView string]];
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
		[fromTextView setString:(NSString *)[currentTrans objectAtIndex:0]];
		[toTextView  setString:(NSString *)[currentTrans objectAtIndex:1]];
	}
}

- (void)redoAction
{
	if ([translates count]>displayIndex+1) 
    {
		++displayIndex;
		NSArray *currentTrans=[translates objectAtIndex:displayIndex];
		[fromTextView setString:(NSString *)[currentTrans objectAtIndex:0]];
		[toTextView  setString:(NSString *)[currentTrans objectAtIndex:1]];
	}
}

@end
