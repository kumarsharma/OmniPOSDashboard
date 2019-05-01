//
//  Settings.h
//  omniPOS
//
//  Created by Kumar Sharma on 21/07/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestaurantInfo : NSObject

@property (nonatomic, strong) NSString * restaurantId;
@property (nonatomic, strong) NSString * address1;
@property (nonatomic, strong) NSString * address2;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * state;
@property (nonatomic, strong) NSString * zip;
@property (nonatomic, strong) NSString * website;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSNumber * taxInclusive;
@property (nonatomic, strong) NSString * currencySymbol;
@property (nonatomic, strong) NSString * companyName;
@property (nonatomic, strong) NSString * headerName, *headerAddress1, *headerCity, *headerState, *headerZip;
@property (nonatomic, strong) NSString * headerPhone, *headerABN, *headerWebsite;

+ (void)signInUsingUsername:(NSString *)userName andPassword:(NSString *)password withExecutionBlock:(endRequestCompletionBlk_t)complBlock;

+ (RestaurantInfo *)parseXml:(NSData *)xmlData;
+ (NSDictionary *)mappingsFromObjectToXML;
@end
