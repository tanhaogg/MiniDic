//
//  DownData.h
//  MacTest
//
//  Created by 谭 颢 on 11-6-12.
//  Copyright 2011 天府学院. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol DownLoadDataDelegate;
@interface DownLoadData : NSObject {
	id<DownLoadDataDelegate> delegate;
	
	NSURL *url;
	NSURLConnection *con;
	NSMutableData *data;
}
@property (nonatomic, assign) id<DownLoadDataDelegate> delegate;

- (id)initWithUrlAddress:(NSString *)address;
- (void)start;

@end

@protocol DownLoadDataDelegate<NSObject>

- (void)downLoadBegin:(DownLoadData *)downLoadData;
- (void)downLoadFinish:(DownLoadData *)downLoadData didReceiveData:(NSData *)data;
- (void)downLoadFail:(DownLoadData *)downLoadData didFailWithError:(NSError *)error;

@end
