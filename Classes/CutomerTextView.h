//
//  CutomerTextView.h
//  MKDic
//
//  Created by stm on 11-6-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol CustomerTextViewDelegate;
@interface CutomerTextView : NSTextView{
	id<CustomerTextViewDelegate> delegate;
}
@property (nonatomic, assign)id<CustomerTextViewDelegate> delegate;
@end


@protocol CustomerTextViewDelegate<NSObject>

- (void)enterClick:(id)sender;
- (void)rightMenuItemClick:(NSString *)aText;

@end
