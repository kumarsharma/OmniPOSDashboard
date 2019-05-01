//
//  OPOperation.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 27/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "OPOperation.h"
#import "OPConnection.h"

@interface OPOperation()

@property (nonatomic, strong) NSString *connectionUrlString;
@property (nonatomic, strong) NSString *postBody;
    @property (nonatomic, strong) endRequestCompletionBlk_t completionBlock;

@end

@implementation OPOperation
@synthesize connectionUrlString = connectionUrlString_;
@synthesize postBody = postBody_;
@synthesize completionBlock = completionBlock_;

- (id)initWithUrlString:(NSString *)urlString andPostBody:(NSString *)inPostBody endRequestCompletionBlock:(endRequestCompletionBlk_t)complBlock
{
    if(self = [super init])
    {
        self.connectionUrlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], urlString];
        self.postBody = inPostBody;
        self.completionBlock = [complBlock copy];
    }
    
    return self;
}

- (void)main
{
    [OPConnection postWithBody:self.postBody withUrlString:self.connectionUrlString compBlock:^(BOOL success, Response *response)
     {
         NSLog(@"Response: %@", response.responseString);
         
         
         dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
         dispatch_async(queue, ^{
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 
                 self.completionBlock(success, response);
                 
             }) ;
         });    
         
     }
    ];
}

@end
