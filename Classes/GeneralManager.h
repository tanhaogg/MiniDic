//
//  GeneralManager.h
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GeneralManager : NSObject {
	NSSpeechSynthesizer *speechSynth;
}

+ (id)shareManager;
+ (void)end;

- (void)speakWithText:(NSString *)aText;
- (void)stopSpeak;
//转换转义字符（暂时没用,保留此处以备后用）
- (NSString *)stringFromEscapes:(NSString *)aString;

@end
