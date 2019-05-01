//
//  Connection.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface OPConnection : NSObject
+ (void)postWithBody:(NSString *)body withUrlString:(NSString *)urlString compBlock:(endRequestCompletionBlk_t)completionBlck;
+ (void)getWithUrlString:(NSString *)urlString compBlock:(endRequestCompletionBlk_t)completionBlck;
+ (void)sendRequest:(NSMutableURLRequest *)request compBlock:(endRequestCompletionBlk_t)completionBlck;

+ (void)didFinishConnection:(NSURLConnection *)connection;

+ (void)cancelAllConnections;
@end
