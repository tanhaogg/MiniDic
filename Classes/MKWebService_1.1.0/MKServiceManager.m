//
//  MKServiceManager.m
//  MKNetSaveCard
//
//  Created by tanhao on 11-8-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MKServiceManager.h"

static MKServiceManager *instance=nil;

@implementation MKServiceManager

- (id)init
{
    self = [super init];
    if (self) {
        delegates = [[NSMutableArray alloc] init];
        downloaders = [[NSMutableArray alloc] init];
        contexts=[[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)retain{
    return self;
}

- (id)autorelease{
    return self;
}

- (oneway void)release{
    return ;
}

- (NSUInteger)retainCount{
    return NSUIntegerMax;
}

- (void)dealloc
{
    [delegates release], delegates = nil;
    [downloaders release], downloaders = nil;
    [contexts release], contexts = nil;
    [super dealloc];
}

+ (id)sharedManager
{
    if (instance == nil)
    {
        instance = [[MKServiceManager alloc] init];
    }
    return instance;
}

#pragma mark -
#pragma mark CustomMethod

- (void)cancelForDelegate:(id<MKServiceManagerDelegate>)delegate
{
	NSUInteger idx = [delegates indexOfObjectIdenticalTo:delegate];
	
    if (idx == NSNotFound)
    {
        return;
    }
	
	MKWebService *webService = [[downloaders objectAtIndex:idx] retain];
	
    [delegates removeObjectAtIndex:idx];
    [downloaders removeObjectAtIndex:idx];
	[contexts removeObjectAtIndex:idx];
    
    [webService release];
}

- (void)uploadWithURL:(NSURL *)url delegate:(id<MKServiceManagerDelegate>)delegate postDic:(NSDictionary *)dic context:(id)context
{
    if (!url || !delegate || !dic) {
        return;
    }
    if (!context) {
        context=[NSNull null];
    }
    
    MKWebService *webService=[[[MKWebService alloc] init] autorelease];
    webService.url=url;
    webService.delegate=self;
    [webService uploadDic:dic];
    
    [delegates addObject:delegate];
    [downloaders addObject:webService];
    [contexts addObject:context];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<MKServiceManagerDelegate>)delegate context:(id)context{
    if (!url || !delegate) {
        return;
    }
    if (!context) {
        context=[NSNull null];
    }
    
    MKWebService *webService=[[[MKWebService alloc] init] autorelease];
    webService.url=url;
    webService.delegate=self;
    [webService downloadBlob];
    
    [delegates addObject:delegate];
    [downloaders addObject:webService];
    [contexts addObject:context];
}

#pragma mark -
#pragma mark MKWebServiceDelegate

- (void)webServiceBegin:(MKWebService *)webService{
    
}

- (void)webServiceFinish:(MKWebService *)webService didReceiveData:(NSData *)data
{
    [webService retain];
    for (NSInteger idx = [downloaders count] - 1; idx >= 0; idx--)
    {
        MKWebService *aWebService = [downloaders objectAtIndex:idx];
        if (aWebService == webService)
        {
            id<MKServiceManagerDelegate> delegate = [delegates objectAtIndex:idx];
            id context=[contexts objectAtIndex:idx];
			if ([context isKindOfClass:[NSNull class]]) {
                context=nil;
            }
            
            if (data)
            {
				if ([delegate respondsToSelector:@selector(serviceFinish:didReceiveData:context:)]) 
				{
                    [delegate serviceFinish:self didReceiveData:data context:context];
				}
            }
            else
            {
				if ([delegate respondsToSelector:@selector(servicFail:didFailWithError:context:)]) 
				{
                    [delegate servicFail:self didFailWithError:nil context:context];
				}
            }
			
            [downloaders removeObjectAtIndex:idx];
            [delegates removeObjectAtIndex:idx];
            [contexts removeObjectAtIndex:idx];
        }
    }
    [webService release];
}

- (void)webServiceFail:(MKWebService *)webService didFailWithError:(NSError *)error
{
    [webService retain];
    for (NSInteger idx = [downloaders count] - 1; idx >= 0; idx--)
    {
        MKWebService *aWebService = [downloaders objectAtIndex:idx];
        if (aWebService == webService)
        {
            id<MKServiceManagerDelegate> delegate = [delegates objectAtIndex:idx];
            id context=[contexts objectAtIndex:idx];
            if ([context isKindOfClass:[NSNull class]]) {
                context=nil;
            }
			
            if ([delegate respondsToSelector:@selector(servicFail:didFailWithError:context:)]) 
            {
                [delegate servicFail:self didFailWithError:error context:context];
            }
			
            [downloaders removeObjectAtIndex:idx];
            [delegates removeObjectAtIndex:idx];
            [contexts removeObjectAtIndex:idx];
        }
    }
    [webService release];
}

@end
