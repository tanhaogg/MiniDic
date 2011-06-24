//
//  SentenceViewController.m
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SentenceViewController.h"
#import "CJSONDeserializer.h"
#import "GeneralManager.h"

@interface SentenceViewController()
- (void)translateEnd;
@end

static NSString *allLanguage[]={
	@"zh",@"en",@"ja"
};
@implementation SentenceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		translates=[[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView{
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

- (IBAction)buttonChange:(NSPopUpButton *)sender{
	NSInteger index=[sender indexOfSelectedItem];
	if (sender==fromPopUpButton) {
		fromLanguage=allLanguage[index];
	}else {
		toLanguage=allLanguage[index];
	}
	
}

- (IBAction)translateBegin:(NSButton *)sender{
	[[GeneralManager shareManager] stopSpeak];
	
	NSString *string=[fromTextView string];
	if ([string length]==0) {
		return;
	}
	
	NSInteger fromIndex=[fromPopUpButton indexOfSelectedItem];
	NSInteger toIndex=[toPopUpButton indexOfSelectedItem];
	fromLanguage=allLanguage[fromIndex];
	toLanguage=allLanguage[toIndex];
	
	NSString *urlstring = [NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/language/translate?v=1.0&langpair=%@|%@&q=%@",
						   fromLanguage,toLanguage,string];
    NSString * encodedString = (NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, (CFStringRef)urlstring, NULL, (CFStringRef)@"|",  kCFStringEncodingUTF8 );
	//NSLog(@"%@",encodedString);
	//此处利用了异步加载
	DownLoadData *downLoad=[[DownLoadData alloc] initWithUrlAddress:encodedString];
	downLoad.delegate=self;
	[downLoad start];
	[toTextView setString:@"请等待⋯⋯"];
	return;
}

- (IBAction)changeClick:(NSButton *)sender{
	NSInteger fromIndex=[fromPopUpButton indexOfSelectedItem];
	NSInteger toIndex=[toPopUpButton indexOfSelectedItem];
	
	fromLanguage=allLanguage[toIndex];
	toLanguage=allLanguage[fromIndex];
	
	[fromPopUpButton selectItemAtIndex:toIndex];
	[toPopUpButton selectItemAtIndex:fromIndex];
}

- (IBAction)talkClick:(NSButton *)sender{
	
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
#pragma mark DownLoadDataDelegate

- (void)downLoadBegin:(DownLoadData *)downLoadData{
	[toTextView setString:@"翻译中⋯⋯"];
}

- (void)downLoadFinish:(DownLoadData *)downLoadData didReceiveData:(NSData *)data{	
	NSString *stingline = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];	
	NSData *jsonData = [stingline dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:nil];
	NSDictionary *arrayline = [dictionary valueForKey:@"responseData"];
	
	NSString *translatedText=[arrayline valueForKey:@"translatedText"];
	[toTextView setString:translatedText];
	
	[downLoadData release];
	[self translateEnd];
}

- (void)downLoadFail:(DownLoadData *)downLoadData didFailWithError:(NSError *)error{	
	[toTextView setString:@"加载超时，请检查是否连接网络⋯⋯"];
	
	[downLoadData release];
}

#pragma mark -
#pragma mark CustomTextViewDelegate

- (void)enterClick:(id)sender{
	[self translateBegin:nil];
}

- (void)rightMenuItemClick:(NSString *)aText{
	[[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSearchWorld object:aText userInfo:nil];
}

#pragma mark -
#pragma mark CustomViewControllerProtocol

- (void)setFirstResponder{
	[[fromTextView superview] becomeFirstResponder];
}

- (void)changeFont:(NSFont *)aFont{
	[fromTextView setFont:aFont];
	[toTextView setFont:aFont];
}

//翻译结束，让结果保存到回溯的栈中
- (void)translateEnd{
	while ([translates count]>displayIndex+1) {
		[translates removeLastObject];
	}
	
	NSString *searchVal=[NSString stringWithString:[fromTextView string]];
	NSString *translVal=[NSString stringWithString:[toTextView string]];
	NSArray *currentTrans=[[NSArray alloc] initWithObjects:searchVal,translVal,nil];
	[translates addObject:currentTrans];
	[currentTrans release];
	
	displayIndex=[translates count]-1;
}

- (void)undoAction{
	if (displayIndex>0) {
		--displayIndex;
		NSArray *currentTrans=[translates objectAtIndex:displayIndex];
		[fromTextView setString:(NSString *)[currentTrans objectAtIndex:0]];
		[toTextView  setString:(NSString *)[currentTrans objectAtIndex:1]];
	}
}

- (void)redoAction{
	if ([translates count]>displayIndex+1) {
		++displayIndex;
		NSArray *currentTrans=[translates objectAtIndex:displayIndex];
		[fromTextView setString:(NSString *)[currentTrans objectAtIndex:0]];
		[toTextView  setString:(NSString *)[currentTrans objectAtIndex:1]];
	}
}

@end
