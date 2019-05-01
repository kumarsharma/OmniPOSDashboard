//
//  OPReportInfo.m
//  omniPOS
//
//  Created by Kumar Sharma on 11/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "OPReportInfo.h"
#import "NSObject+PropertySupport.h"

@implementation OPReportInfo
@synthesize objId, name;
@synthesize amount, cashSale, cardSale, voucherSale;

+ (NSDictionary *)mappingsFromObjectToXML
{
    NSArray *objects = [NSArray arrayWithObjects:@"objId", @"name", @"amount", @"cashSale", @"cardSale", @"voucherSale", NSStringFromClass(self), NSStringFromClass(self), NSStringFromClass(self), NSStringFromClass(self), NSStringFromClass(self), nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"ID", @"Name", @"Amount", @"CashSale", @"CardSale", @"VoucherSale", @"DrawerInfo", @"EmployeeInfo", @"CategoryInfo", @"ProductInfo", @"ModiferInfo", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSArray *objects = [NSArray arrayWithObjects:@"string", @"string", @"float", @"float", @"float", @"float", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"ID", @"Name", @"Amount", @"CashSale", @"CardSale", @"VoucherSale", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return mappings;
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
