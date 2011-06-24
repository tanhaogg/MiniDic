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
- (void)setFirstResponder;               //设置第一响应
- (void)changeFont:(NSFont *)aFont;      //字体改变

- (void)undoAction;   //undo
- (void)redoAction;   //redo

@end
