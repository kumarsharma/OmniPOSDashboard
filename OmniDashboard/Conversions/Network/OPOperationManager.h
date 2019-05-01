//
//  OPOperationManager.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 27/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPOperation;
@interface OPOperationManager : NSObject
{
    NSOperationQueue *operationQueue_;
}

+ (id)sharedManager;

- (void)addNewOperation:(OPOperation *)anOperation;

- (void)cancelAllOperation;

@end
