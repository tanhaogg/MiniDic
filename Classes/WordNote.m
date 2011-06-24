//
//  WordNote.m
//  MKDic
//
//  Created by 谭 颢 on 11-6-20.
//  Copyright 2011 天府学院. All rights reserved.
//

#import "WordNote.h"


@implementation WordNote
@synthesize row;
@synthesize level;
@synthesize word;
@synthesize translate;

- (void)dealloc{
	if(word!=nil) [word release];
	if(translate!=nil) [translate release];
	[super dealloc];
}
@end
