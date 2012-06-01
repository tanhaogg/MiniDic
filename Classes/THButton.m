//
//  THButton.m
//  Vdisk
//
//  Created by Hao Tan on 12/02/08.
//  Copyright (c) 2012年 tanhao. All rights reserved.
//

#import "THButton.h"

@implementation THButton

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)resetCursorRects
{
    [super resetCursorRects];
    [self addCursorRect:[self bounds] cursor:[NSCursor pointingHandCursor]];
}

@end
