//
//  OPOperationManager.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 27/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "OPOperationManager.h"

@interface OPOperationManager()

@property (nonatomic, strong) NSOperationQueue *operationQueue;


@end

@implementation OPOperationManager
@synthesize operationQueue = operationQueue_;



//Single ton ////
static OPOperationManager *sharedSingleton = nil;

+ (id)sharedManager
{
	@synchronized(self){
		if (sharedSingleton == nil) {
			sharedSingleton = [[super allocWithZone:NULL] init];
            
            sharedSingleton.operationQueue = [[NSOperationQueue alloc] init];
		}
	}
    return sharedSingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark -

- (void)addNewOperation:(OPOperation *)anOperation
{
    [self.operationQueue addOperation:(NSOperation *)anOperation];    
}

- (void)cancelAllOperation
{
    [self.operationQueue cancelAllOperations];
}


@end
