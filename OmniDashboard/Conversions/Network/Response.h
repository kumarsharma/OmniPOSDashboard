//
//  Response.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject
{
    NSString *responseString_;
    NSInteger statusCode_;
    NSString *failureMessage_;
    NSData *responseData_;
}

@property (nonatomic, strong) NSString *responseString, *failureMessage;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) NSData *responseData;

@end
