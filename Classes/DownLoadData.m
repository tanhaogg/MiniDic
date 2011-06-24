//
//  DownData.m
//  MacTest
//
//  Created by 谭 颢 on 11-6-12.
//  Copyright 2011 天府学院. All rights reserved.
//

#import "DownLoadData.h"


@implementation DownLoadData
@synthesize delegate;

- (id)initWithUrlAddress:(NSString *)address{
	self=[super init];
	if (self) {
		url=[NSURL URLWithString:address];
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		//con=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
		con=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		data=[[NSMutableData alloc] init];
	}
	return self;
}

- (void)start{
	[con start];
}

- (void)dealloc{
	[con release];
	[data release];
	[super dealloc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	if ([delegate respondsToSelector:@selector(downLoadBegin:)]) {
		[delegate downLoadBegin:self];
	}
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData{
    if(con!=nil){
	    [data appendData:aData];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if ([delegate respondsToSelector:@selector(downLoadFail:didFailWithError:)]) {
		[delegate downLoadFail:self didFailWithError:error];
	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
	if ([delegate respondsToSelector:@selector(downLoadFinish:didReceiveData:)]) {
		[delegate downLoadFinish:self didReceiveData:data];
	}
}

@end
