//
//  Connection.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "OPConnection.h"
#import "OPConnectionDelegate.h"
//#import "NSMutableURLRequest+ResponseType.h"
#import "NSMutableURLRequest+Responses.h"

static NSInteger numberOfActiveConnections = 0;
static NSMutableArray *activeConnections;

@implementation OPConnection

+ (void)postWithBody:(NSString *)body withUrlString:(NSString *)urlString compBlock:(endRequestCompletionBlk_t)completionBlck
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^(void) {
    
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:url andMethod:@"POST"];
        
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self sendRequest:request compBlock:completionBlck];
//    });
}

+ (void)getWithUrlString:(NSString *)urlString compBlock:(endRequestCompletionBlk_t)completionBlck
{
//     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^(void) {
    
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:url andMethod:@"GET"];
        [self sendRequest:request compBlock:completionBlck];
//     });
}

+ (void)sendRequest:(NSMutableURLRequest *)request compBlock:(endRequestCompletionBlk_t)completionBlck
{
    OPConnectionDelegate *connectionDelegate = [[OPConnectionDelegate alloc] init];
	
    [request setTimeoutInterval:60];
    
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:connectionDelegate startImmediately:NO];
    
	connectionDelegate.connection = connection;
	connectionDelegate.completionBlock = [completionBlck copy];
    
    if(nil == activeConnections)
        activeConnections = [NSMutableArray array];
    
    [activeConnections addObject:connection];

    numberOfActiveConnections++;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[connection start];
}

+ (void)didFinishConnection:(NSURLConnection *)connection
{
    if([activeConnections containsObject:connection])
        [activeConnections removeObject:connection];
    
    if(numberOfActiveConnections > 0)
        numberOfActiveConnections--;
    
    if(numberOfActiveConnections <= 0)
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if(activeConnections.count == 0)
    {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishActiveNetworkOperations object:nil];
    }
}

+ (void)cancelAllConnections
{
    for(NSURLConnection *con in activeConnections)
    {
        [con cancel];
    }
    numberOfActiveConnections = 0;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
