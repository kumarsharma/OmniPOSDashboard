//
//  NSMutableURLRequest+Responses.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 21/12/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "NSMutableURLRequest+Responses.h"

static float timeoutInterval = 8.0;

@implementation NSMutableURLRequest (Responses)

+(NSMutableURLRequest *)requestWithUrl:(NSURL *)url andMethod:(NSString*)method
{
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                        timeoutInterval:timeoutInterval];
	[request setHTTPMethod:method];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/xml" forHTTPHeaderField:@"Accept"];
    
	return request;
}
@end
