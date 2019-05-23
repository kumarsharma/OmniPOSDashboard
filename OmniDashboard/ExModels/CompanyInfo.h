//
//  CompanyInfo.h
//  ExTunes
//
//  Created by Kumar Sharma on 08/04/14.
//  Copyright (c) 2014 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;
@interface CompanyInfo : NSObject
{
    NSArray *allLocations;
    NSString *companyName;
    UserInfo *user;
    NSString *companyCode;
}

@property (nonatomic, strong) NSArray *allLocations;
@property (nonatomic, strong) NSString *companyName, * companyCode;
@property (nonatomic, strong) UserInfo *user;

+ (void)signInUsingUsername:(NSString *)userName andPassword:(NSString *)password withExecutionBlock:(endRequestCompletionBlk_t)complBlock;

+ (CompanyInfo *)parseXml:(NSData *)xmlData;
+ (void)signInUsingUsername:(NSString *)userName andPassword:(NSString *)password withCompanyCode:(NSString *)companyCode withExecutionBlock:(endRequestCompletionBlk_t)complBlock;
+ (void)loadGroupPermissions:(NSString *)userGroupId withCompanyCode:(NSString *)companyCode withExecutionBlock:(endRequestCompletionBlk_t)complBlock;
@end
