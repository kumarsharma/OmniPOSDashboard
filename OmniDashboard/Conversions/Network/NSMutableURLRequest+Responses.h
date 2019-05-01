//
//  NSMutableURLRequest+Responses.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 21/12/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Responses)
+(NSMutableURLRequest *) requestWithUrl:(NSURL *)url andMethod:(NSString*)method;
@end
