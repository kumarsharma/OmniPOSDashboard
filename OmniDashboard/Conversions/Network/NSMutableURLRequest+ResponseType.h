//
//  NSMutableURLRequest+ResponseType.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

@interface NSMutableURLRequest(ResponseType)

+(NSMutableURLRequest *) requestWithUrl:(NSURL *)url andMethod:(NSString*)method;

@end
