//
//  ConnectionDelegate.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OPConnectionDelegate : NSObject {
    
	NSMutableData *data;
	NSHTTPURLResponse *response;
	BOOL done;
	NSError *error;
	NSURLConnection *connection;
	
    endRequestCompletionBlk_t completionBlock_;
}

- (BOOL) isDone;
- (void) cancel;

@property(nonatomic, strong) NSHTTPURLResponse *response;
@property(nonatomic, strong) NSMutableData *data;
@property(nonatomic, strong) NSError *error;
@property(nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) endRequestCompletionBlk_t completionBlock;

@end