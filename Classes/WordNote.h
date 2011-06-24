//
//  WordNote.h
//  MKDic
//
//  Created by 谭 颢 on 11-6-20.
//  Copyright 2011 天府学院. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface WordNote : NSObject {
	int row;
	int level;
	NSString *word;
	NSString *translate;
}
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int level;
@property (nonatomic, retain) NSString *word;
@property (nonatomic, retain) NSString *translate;

@end
