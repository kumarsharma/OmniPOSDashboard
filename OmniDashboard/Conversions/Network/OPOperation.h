//
//  OPOperation.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 27/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//


@interface OPOperation : NSOperation
{
    NSString *connectionUrlString_;
    NSString *postBody_;
    endRequestCompletionBlk_t completionBlock_;
}

- (id)initWithUrlString:(NSString *)urlString andPostBody:(NSString *)inPostBody endRequestCompletionBlock:(endRequestCompletionBlk_t)complBlock;

@end
