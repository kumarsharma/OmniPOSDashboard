//
//  Settings.m
//  omniPOS
//
//  Created by Kumar Sharma on 21/07/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "RestaurantInfo.h"
#import "OPConnection.h"
#import "NSString+Extension.h"
#import "NSObject+PropertySupport.h"
#import "NSString+InflectionSupport.h"
#import "NSObject+XMLSerializableSupport.h"

@implementation RestaurantInfo

@synthesize address1;
@synthesize address2;
@synthesize city;
@synthesize location;
@synthesize name;
@synthesize phone;
@synthesize state;
@synthesize zip;
@synthesize website;
@synthesize email;
@synthesize taxInclusive;
@synthesize currencySymbol;
@synthesize restaurantId;
@synthesize companyName;

@synthesize headerName, headerAddress1, headerCity, headerState, headerZip;
@synthesize headerPhone, headerABN, headerWebsite;

#pragma mark -encoding/decoding

-(id)initWithCoder:(NSCoder *)decoder
{
    headerName = [decoder decodeObjectForKey:@"headerName"];
    headerAddress1 = [decoder decodeObjectForKey:@"headerAddress1"];
    headerCity = [decoder decodeObjectForKey:@"headerCity"];
    
    headerState = [decoder decodeObjectForKey:@"headerState"];
    headerZip = [decoder decodeObjectForKey:@"headerZip"];
    
    headerPhone = [decoder decodeObjectForKey:@"headerPhone"];
    headerABN = [decoder decodeObjectForKey:@"headerABN"];
    headerWebsite = [decoder decodeObjectForKey:@"headerWebsite"];
    
    
    address1 = [decoder decodeObjectForKey:@"address1"];
    address2 = [decoder decodeObjectForKey:@"address2"];
    companyName = [decoder decodeObjectForKey:@"companyName"];
    
    city = [decoder decodeObjectForKey:@"city"];
    location = [decoder decodeObjectForKey:@"location"];
    
    name = [decoder decodeObjectForKey:@"name"];
    phone = [decoder decodeObjectForKey:@"phone"];
    
    state = [decoder decodeObjectForKey:@"state"];
    zip = [decoder decodeObjectForKey:@"zip"];
    
    website = [decoder decodeObjectForKey:@"website"];
    email = [decoder decodeObjectForKey:@"email"];
    
    taxInclusive = [decoder decodeObjectForKey:@"taxInclusive"];
    currencySymbol = [decoder decodeObjectForKey:@"currencySymbol"];
    restaurantId = [decoder decodeObjectForKey:@"restaurantId"];
    
	return self;
}


-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:headerName forKey:@"headerName"];
    [encoder encodeObject:headerAddress1 forKey:@"headerAddress1"];
    [encoder encodeObject:headerCity forKey:@"headerCity"];
    
    [encoder encodeObject:headerState forKey:@"headerState"];
    [encoder encodeObject:headerZip forKey:@"headerZip"];
    [encoder encodeObject:headerPhone forKey:@"headerPhone"];
    [encoder encodeObject:headerABN forKey:@"headerABN"];
    
    [encoder encodeObject:headerWebsite forKey:@"headerWebsite"];
    
    //
    [encoder encodeObject:companyName forKey:@"companyName"];
    [encoder encodeObject:address1 forKey:@"address1"];
    [encoder encodeObject:address2 forKey:@"address2"];
    
    [encoder encodeObject:city forKey:@"city"];
    [encoder encodeObject:location forKey:@"location"];
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:phone forKey:@"phone"];
    
    [encoder encodeObject:state forKey:@"state"];
    [encoder encodeObject:zip forKey:@"zip"];
    [encoder encodeObject:website forKey:@"website"];
    [encoder encodeObject:email forKey:@"email"];
    [encoder encodeObject:taxInclusive forKey:@"taxInclusive"];
    [encoder encodeObject:currencySymbol forKey:@"currencySymbol"];
    [encoder encodeObject:restaurantId forKey:@"restaurantId"];
}


#pragma mark - Remote fetch

+ (NSString *)remoteFetchPath
{
    return @"/getRestaurantInfo.asmx/getRestaurantDetails";
}

+ (void)signInUsingUsername:(NSString *)userName andPassword:(NSString *)password withExecutionBlock:(endRequestCompletionBlk_t)complBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", [NetworkConfig getBaseURL], [self remoteFetchPath]];
    NSString *body = [NSString stringWithFormat:@"param1=UserName&val1=%@&param2=UserPassword&val2=%@", userName, password];
    
    //    NSString *str = [NSString stringWithFormat:@"<UserName>%@</UserName><UserPassword>%@</UserPassword>", userName, password];
//    NSString *params = [body stringByAddingPercentEscapesUsingEncoding:NSUTF16BigEndianStringEncoding];
    
    [OPConnection postWithBody:body withUrlString:urlString compBlock:complBlock];
}

#pragma mark - Conversions

+ (RestaurantInfo *)parseXml:(NSData *)xmlData
{
    RestaurantInfo *mObject =  (RestaurantInfo *)[self fromXMLData:xmlData mappings:[self mappingsFromObjectToXML] dataTypes:[self dataTypesForProperties] classMappings:[self classMappings]];
    
    return mObject;
}

+ (NSDictionary *)mappingsFromObjectToXML
{
    NSArray *objects = [NSArray arrayWithObjects:@"name", @"address1", @"address2", @"city", @"currencySymbol", @"email", @"restaurantId", @"state", @"taxInclusive", @"website", @"zip", @"headerName", @"headerAddress1", @"headerCity", @"headerState", @"headerZip", @"headerPhone", @"headerABN", @"headerWebsite", NSStringFromClass(self), nil];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"RestName", @"Address1", @"Address2", @"City", @"CurrencySymbol", @"Email", @"RestID", @"state", @"Tax", @"website", @"Zip", @"Header_Name", @"Header_Address1", @"Header_City", @"Header_State", @"Header_Zip", @"Header_Phone", @"Header_ABN", @"Header_Website", @"LocationInfo", nil];
    
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
