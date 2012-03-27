//
//  MKWebService.h
//  MKNetSaveCard
//
//  Created by tanhao on 11-8-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MKWebServiceDelegate;
@interface MKWebService : NSObject {
	id<MKWebServiceDelegate>   _delegate;
	NSURL                      *_url;
	
	@private
	NSURLConnection            *_con;
	NSMutableData              *_data;
}
@property (nonatomic, assign) id<MKWebServiceDelegate> delegate;
@property (nonatomic, retain) NSURL *url;

/***上传***/
- (void)uploadDic:(NSDictionary *)dic;
/***下载***/
- (void)downloadBlob;

@end

@protocol MKWebServiceDelegate<NSObject>

- (void)webServiceBegin:(MKWebService *)webService;
- (void)webServiceFinish:(MKWebService *)webService didReceiveData:(NSData *)data;
- (void)webServiceFail:(MKWebService *)webService didFailWithError:(NSError *)error;

@end