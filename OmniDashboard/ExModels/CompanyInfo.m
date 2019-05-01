//
//  CompanyInfo.m
//  ExTunes
//
//  Created by Kumar Sharma on 08/04/14.
//  Copyright (c) 2014 OmniSyems. All rights reserved.
//

#import "CompanyInfo.h"
#import "OPConnection.h"
#import "NSString+Extension.h"
#import "NSObject+PropertySupport.h"
#import "NSString+InflectionSupport.h"
#import "NSObject+XMLSerializableSupport.h"
#import "RestaurantInfo.h"
#import "UserInfo.h"

@implementation CompanyInfo
@synthesize allLocations;
@synthesize companyName, companyCode;
@synthesize user;

-(id)initWithCoder:(NSCoder *)decoder
{
    allLocations = [decoder decodeObjectForKey:@"allLocations"];
    companyName = [decoder decodeObjectForKey:@"companyName"];
    user = [decoder decodeObjectForKey:@"user"];
    companyCode = [decoder decodeObjectForKey:@"companyCode"];
 	return self;
}


-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:allLocations forKey:@"allLocations"];
    [encoder encodeObject:companyName forKey:@"companyName"];
    [encoder encodeObject:companyCode forKey:@"companyCode"];
    [encoder encodeObject:user forKey:@"user"];
}


#pragma mark - Remote fetch

+ (NSString *)remoteFetchPath
{
    return @"/companydataservices.asmx/GetAllLocation";
}

+ (void)signInUsingUsername:(NSString *)userName andPassword:(NSString *)password withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], [self remoteFetchPath]];
    NSString *body = [NSString stringWithFormat:@"param1=UserName&val1=%@&param2=UserPassword&val2=%@", userName, password];
    
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

+ (void)signInUsingUsername:(NSString *)userName andPassword:(NSString *)password withCompanyCode:(NSString *)companyCode withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], [self remoteFetchPath]];
    NSString *body = [NSString stringWithFormat:@"companycode=%@&param1=UserName&val1=%@&param2=UserPassword&val2=%@", companyCode, userName, password];
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

#pragma mark - Conversions

+ (CompanyInfo *)parseXml:(NSData *)xmlData
{
    CompanyInfo *mObject =  (CompanyInfo *)[self fromXMLData:xmlData mappings:[self mappingsFromObjectToXML] dataTypes:[self dataTypesForProperties] classMappings:[self classMappings]];
    
    return mObject;
}

+ (NSDictionary *)mappingsFromObjectToXML
{
    NSArray *objects = [NSArray arrayWithObjects:@"companyName", @"allLocations", @"user", NSStringFromClass(self), nil];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"Company", @"allLocations", @"UserInfo", @"CompanyInfo", nil];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    [mappings addEntriesFromDictionary:[UserInfo mappingsFromObjectToXML]];
    [mappings addEntriesFromDictionary:[RestaurantInfo mappingsFromObjectToXML]];
    
    return mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSArray *objects = [NSArray arrayWithObjects:@"string", @"array", @"UserInfo", @"RestaurantInfo", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"companyName", @"allLocations", @"user", @"LocationInfo", nil];
    
    NSMutableDictionary *props = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSDictionary *r_props = [RestaurantInfo propertyNamesAndTypes];
    NSDictionary *u_props = [UserInfo propertyNamesAndTypes];
    
    [props addEntriesFromDictionary:r_props];
    [props addEntriesFromDictionary:u_props];
    return props;
}

+ (NSDictionary *)classMappings
{
    NSDictionary *propertyAndTypes = [self propertyNamesAndTypes];
    NSDictionary *r_props = [RestaurantInfo propertyNamesAndTypes];
    NSDictionary *u_props = [UserInfo propertyNamesAndTypes];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    
    [mappings setValue:NSStringFromClass(self) forKey:NSStringFromClass(self)];
    [mappings setValue:NSStringFromClass([RestaurantInfo class]) forKey:@"LocationInfo"];
    
    [mappings addEntriesFromDictionary:propertyAndTypes];
    [mappings addEntriesFromDictionary:r_props];
    [mappings addEntriesFromDictionary:u_props];
    
    return mappings;
}


@end
