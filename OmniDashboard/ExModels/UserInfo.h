//
//  UserInfo.h
//  ExTunes
//
//  Created by Kumar Sharma on 15/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * firstName;
@property (nonatomic, strong) NSString * lastName;
@property (nonatomic, strong) NSString * loginPin;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSString * userID;
@property (nonatomic, strong) NSString * userType;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * userGroupId, * userGroupCode, *permittedMenuIDs, *locationId;

+ (NSDictionary *)mappingsFromObjectToXML;

+ (void)getAllDetailsWithExecutionBlock:(endRequestCompletionBlk_t)complBlock;
@end
