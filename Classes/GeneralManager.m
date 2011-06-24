//
//  GeneralManager.m
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GeneralManager.h"

static GeneralManager *generalManager;
@implementation GeneralManager

+ (id)shareManager{
	if (generalManager==nil) {
		generalManager=[[GeneralManager alloc] init];
	}
	return generalManager;
}

+ (void)end{
	if (generalManager!=nil) {
		[generalManager release];
		generalManager=nil;
	}
}

- (id)init{
	self=[super init];
	if (self) {
		speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
	}
	return self;
}

- (void)dealloc{
	[speechSynth release];
	[super dealloc];
}

#pragma mark -
#pragma mark CustomFunc
- (void)speakWithText:(NSString *)aText{
	[speechSynth startSpeakingString:aText];
}

- (void)stopSpeak{
	[speechSynth stopSpeaking];
}

- (NSString *)stringFromEscapes:(NSString *)aString{
	NSMutableString *resultString=[NSMutableString stringWithString:aString];
	NSString* escapes[][2]={
		{@"&#601;",@"ə"},
		{@"&#596;",@"ɔ"},
		{@"&#652;",@"ʌ"},
		{@"&#230;",@"æ"},
		{@"&#593;",@"ɑ"},
		{@"&#603;",@"ɛ"},
		{@"&#952;",@"θ"},
		{@"&#331;",@"ŋ"},
		{@"&#643;",@"ʃ"},
		{@"&#240;",@"ð"},
		{@"&#658;",@"ʒ"},
		{@"&#650;",@"ʊ"},
		{@"&lt;",@"<"},
		{@"&gt;",@">"},
	};
	for (int i=0; i<sizeof(escapes)/sizeof(escapes[0]); i++) {
		[resultString replaceOccurrencesOfString:escapes[i][0] withString:escapes[i][1] options:0 range:NSMakeRange(0, [resultString length])];
	}
	return resultString;
}

@end
