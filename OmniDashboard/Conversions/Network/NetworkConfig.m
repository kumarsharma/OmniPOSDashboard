//
//  NetworkConfig.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 27/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "NetworkConfig.h"
#import "NSMutableURLRequest+ResponseType.h"
#import "NSString+Extension.h"


static NSString *baseURL = nil;
static NSString *baseBaseURL = nil;
#define kBaseBaseURL @"BaseBaseURL"
#define kOmniPOSUserName @"OmniPOSUserName"
#define kOmniPOSPassword @"OmniPOSPassword"

#define kTestDomainName @"omnisystems.com.au"

@interface NetworkConfig()

+ (void)setBaseBaseURL:(NSString *)url;

@end

@implementation NetworkConfig

+ (void)setBaseURL:(NSString *)baseUrl
{
    [self setBaseBaseURL:baseUrl];
    
//     [NetworkConfig setBaseURL:@"http://omnisystems.com.au/PosApp/WebServices"];
    
    baseURL = [self getActualBaseURL];
}

+ (NSString *)getBaseURL
{
    if(nil == baseURL)
    {
        baseURL = [self getActualBaseURL];
        
        if(nil == baseURL)
        {
            NSMutableString *actualBaseURL = [NSMutableString stringWithString:@"https://"];
            NSString *endPath = @"WebServices";
            [actualBaseURL appendFormat:@"%@/%@", @"www.omniposonline.com", endPath];
            return actualBaseURL;
        }
    }
    
    return baseURL;
}

+ (NSString *)getActualBaseURL
{
    NSString *baseBaseURl = [self getBaseBaseURL];
    if(!baseBaseURl)
        return nil;
    
    NSMutableString *actualBaseURL = nil;
    
#if kDEBUG_PRODUCTION_SERVER_MODE
    actualBaseURL = [NSMutableString stringWithString:@"https://"];
#else
    actualBaseURL = [NSMutableString stringWithString:@"http://"];
#endif
    
    NSString *endPath = @"WebServices";
    [actualBaseURL appendFormat:@"%@/%@", baseBaseURl, endPath];
    return actualBaseURL;
    return nil;
}

+ (NSString *)getBaseBaseURL
{
    
#if kDEBUG_PRODUCTION_SERVER_MODE
    //    baseBaseURL = @"www.omniposweb.com";
#else
    baseBaseURL = @"test.omniposonline.com";
#endif
    
    if(nil == baseBaseURL)
    {
        NSURL *url = [NSURL URLWithString:@"http://utils.omniposonline.com/webservices/OmniUtilityServices.asmx/GetBaseURLForPOSApp"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithUrl:url andMethod:@"POST"];
        [request setTimeoutInterval:10];
        NSString *body = @"username=varya&password=Vivek@786";
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        baseBaseURL = [res contentForTag:@"BaseURL"];
        if(nil == baseBaseURL)
            baseBaseURL = @"www.omniposonline.com";
    }
    
    return baseBaseURL;
}

+ (NSString *)getActualBaseURLFromURL:(NSString *)baseBaseURl
{
    NSMutableString *actualBaseURL = [NSMutableString stringWithString:@"http://"];
    
    NSString *endPath = nil;
    if([baseBaseURl isEqualToString:kTestDomainName])
        endPath = @"PosApp/WebServices";
    else
        endPath = @"WebServices";
    
    [actualBaseURL appendFormat:@"%@/%@", baseBaseURl, endPath];
    
    return actualBaseURL;
}

+ (void)setBaseBaseURL:(NSString *)url
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setValue:url forKey:kBaseBaseURL];
    
    [ud synchronize];
}

+ (void)setUserName:(NSString *)name withPassword:(NSString *)password
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setValue:name forKey:kOmniPOSUserName];
    [ud setValue:password forKey:kOmniPOSPassword];
    
    [ud synchronize];
}

+ (void)getUserName:(NSString **)name andPassword:(NSString **)password
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    *name = [ud valueForKey:kOmniPOSUserName];
    *password = [ud valueForKey:kOmniPOSPassword];
    
    [ud synchronize];
}

@end
