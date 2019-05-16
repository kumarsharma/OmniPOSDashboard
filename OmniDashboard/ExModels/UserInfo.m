//
//  UserInfo.m
//  ExTunes
//
//  Created by Kumar Sharma on 15/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "UserInfo.h"
#import "OPConnection.h"
#import "NSObject+PropertySupport.h"
#import "NSString+InflectionSupport.h"

@implementation UserInfo

@synthesize email;
@synthesize firstName;
@synthesize lastName;
@synthesize loginPin;
@synthesize phone;
@synthesize startDate;
@synthesize userID;
@synthesize userType;
@synthesize userName;

-(id)initWithCoder:(NSCoder *)decoder
{
    email = [decoder decodeObjectForKey:@"email"];
    firstName = [decoder decodeObjectForKey:@"firstName"];
    
    lastName = [decoder decodeObjectForKey:@"lastName"];
    loginPin = [decoder decodeObjectForKey:@"loginPin"];
    
    phone = [decoder decodeObjectForKey:@"phone"];
    startDate = [decoder decodeObjectForKey:@"startDate"];
    
    userID = [decoder decodeObjectForKey:@"userID"];
    userType = [decoder decodeObjectForKey:@"userType"];
    
    userName = [decoder decodeObjectForKey:@"userName"];
    
	return self;
}


-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:email forKey:@"email"];
    [encoder encodeObject:firstName forKey:@"firstName"];
    
    [encoder encodeObject:lastName forKey:@"lastName"];
    [encoder encodeObject:loginPin forKey:@"loginPin"];
    [encoder encodeObject:phone forKey:@"phone"];
    [encoder encodeObject:startDate forKey:@"startDate"];
    
    [encoder encodeObject:userID forKey:@"userID"];
    [encoder encodeObject:userType forKey:@"userType"];
    [encoder encodeObject:userName forKey:@"userName"];
}



+ (NSString *)getParamString
{
    NSString *body = [NSString stringWithFormat:@"param=Rest_ID&val=%@", ([OPDashboardAppDelegate sharedAppDelegate]).currentRestaurantId];
    return body;
}

+ (void)getAllDetailsWithExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], [self remoteFetchPath]];
    
    [OPConnection postWithBody:[self getParamString] withUrlString:urlString compBlock:complBlock];
}


#pragma mark - Remote fetch

+ (NSString *)remoteFetchPath
{
    return @"/getAllUserInfo.asmx/getAllUserDetails";
}

#pragma mark - Conversions

+ (NSDictionary *)mappingsFromObjectToXML
{
    NSArray *objects = [NSArray arrayWithObjects:@"email", @"firstName", @"lastName", @"loginPin", @"phone", @"startDate", @"userID", @"userName", @"userType", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"UserEmail", @"FirstName", @"LastName", @"UserPin", @"UserPHone", @"StartDate", @"UserID", @"UserName", @"userType", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSDictionary *props = [self propertyNamesAndTypes];
    
    return props;
}

+ (NSDictionary *)classMappings
{
    NSDictionary *propertyAndTypes = [self propertyNamesAndTypes];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    
    [mappings setValue:NSStringFromClass(self) forKey:NSStringFromClass(self)];
    [mappings addEntriesFromDictionary:propertyAndTypes];
    
    return mappings;
}


@end
