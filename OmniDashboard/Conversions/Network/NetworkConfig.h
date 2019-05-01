//
//  NetworkConfig.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 27/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kREQUEST_TIMEDOUT_INTERVAL 3600

@interface NetworkConfig : NSObject


+ (void)setBaseURL:(NSString *)baseUrl;
+ (NSString *)getBaseURL;
+ (NSString *)getBaseBaseURL;
+ (void)setUserName:(NSString *)name withPassword:(NSString *)password;
+ (void)getUserName:(NSString **)name andPassword:(NSString **)password;
+ (NSString *)getActualBaseURLFromURL:(NSString *)baseBaseURl;
@end
