//
//  NSMutableURLRequest+ResponseType.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "NSMutableURLRequest+ResponseType.h"


static float timeoutInterval = 8.0;

@implementation NSMutableURLRequest(ResponseType)

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
