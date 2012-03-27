//
//  CustomViewControllerProtocol.h
//  MKDic
//
//  Created by 谭 颢 on 11-6-16.
//  Copyright 2011 天府学院. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol CustomViewControllerProtocol<NSObject>
@required
- (void)setFirstResponder;
- (void)changeFont:(NSFont *)aFont;

- (void)undoAction;
- (void)redoAction;

- (void)quickTranslateWithString:(NSString *)str;

@end
