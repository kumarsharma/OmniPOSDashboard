//
//  ConnectionDelegate.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "OPConnectionDelegate.h"
#import "Response.h"
#import "NSString+Extension.h"
#import "OPConnection.h"

@implementation OPConnectionDelegate

@synthesize response, data, error, connection;
@synthesize completionBlock = completionBlock_;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.data = [NSMutableData data];
		done = NO;
	}
	return self;
}

- (BOOL) isDone {
	return done;
}

- (void) cancel {
	[connection cancel];
	self.response = nil;
	self.data = nil;
	self.error = nil;
	done = YES;
}

#pragma mark NSURLConnectionDelegate methods
- (NSURLRequest *)connection:(NSURLConnection *)aConnection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if ([challenge previousFailureCount] > 0) {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
	else {
		[[challenge sender] useCredential:[challenge proposedCredential] forAuthenticationChallenge:challenge];
	}
}
- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	done = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
	self.response = (NSHTTPURLResponse *)aResponse;

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
    
	[data appendData:someData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    
    if(self.completionBlock)
    {
        NSString *responseString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        
        Response *aResponse = [[Response alloc] init];
        aResponse.responseString = responseString;
        aResponse.statusCode = [self.response statusCode];
        aResponse.responseData = self.data;
        
        aResponse.failureMessage = [aResponse.responseString contentForTag:@"ErrorMessage"];
        
        BOOL success = (aResponse.statusCode == 200 ? YES : NO);
        
        if(aResponse.failureMessage)
            success = NO;
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.completionBlock(success, aResponse);
                
            }) ;
        });     
    }
    
    [OPConnection didFinishConnection:self.connection];
	done = YES;
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)aError {
	self.error = aError;
    
    if(self.completionBlock)
    {
        Response *aResponse = [[Response alloc] init];
        aResponse.failureMessage = [aError localizedDescription];
        aResponse.statusCode = [self.response statusCode];
        
        BOOL success = (aResponse.statusCode == 200 ? YES : NO);
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                self.completionBlock(success, aResponse);
                
            }) ;
        });     
    }
    
    [OPConnection didFinishConnection:self.connection];
	done = YES;
}

//don't cache resources for now
- (NSCachedURLResponse *)connection:(NSURLConnection *)aConnection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
	return nil;
}


#pragma mark cleanup
- (void) dealloc
{

}


@end

