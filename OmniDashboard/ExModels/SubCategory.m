//
//  SubCategory.m
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "SubCategory.h"
#import "NSObject+PropertySupport.h"
#import "Product.h"

@implementation SubCategory
@synthesize sub_cat_id, sub_cat_name;
@synthesize products;
@synthesize totalSold = _totalSold;
@synthesize adjustedSale = _adjustedSale;
@synthesize total_amount;

- (float)totalSold{
    
    _totalSold = 0;
    if(self.products.count)
    {
        for(Product *prod in self.products)
        {
            _totalSold += prod.totalPrice;
        }
    }
    else{
        
        _totalSold = self.total_amount;
    }
    
    return _totalSold;
}

- (float)adjustedSale{
    
    float total = 0;

    if(self.products.count)
    {
        for(Product *prod in self.products)
        {
            float pprice = prod.adjustedPrice;
            if(pprice <= 0)
                pprice = 0;
            
            total += pprice;
        }
    }
    else{
        
        total = self.total_amount;
    }
    
    return total;
}

- (float)adjustedSaleForGST{
    
    float total = 0;
    
    if(self.products.count)
    {
        for(Product *prod in self.products)
        {
            float pprice = [prod adjustedPriceForGST];
            if(pprice <= 0)
                pprice = 0;
                        
            total += pprice;
        }
    }
    else{
        
        total = self.total_amount;
    }
    
    return total;
}

#pragma mark - XML

- (BOOL)shouldInclusedPropertyInXML:(NSString *)prop{
    
    NSArray *includedProps = [NSArray arrayWithObjects:@"sub_cat_id", nil];
    
    if([includedProps containsObject:prop])
        return YES;
    
    return NO;
}

#pragma mark - Xml

- (NSString *)xmlRepresentation
{
    NSMutableString *xmlString = [NSMutableString string];
    
    NSString *rootTagName = @"Category";
    
    [xmlString appendFormat:@"<%@>\n", rootTagName];
    
    [xmlString appendFormat:@"<id>%@</id>\n", self.sub_cat_id];
    
    NSString *name = [self.sub_cat_name stringByReplacingOccurrencesOfString:@"&" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"<" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@">" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    name = [name stringByReplacingOccurrencesOfString:@"'" withString:@""];
    
    [xmlString appendFormat:@"<name>%@</name>\n", name];
    [xmlString appendFormat:@"<org_amt>%0.2f</org_amt>\n", self.totalSold];
    [xmlString appendFormat:@"<adj_amt>%0.2f</adj_amt>\n", self.adjustedSale];
    
    [xmlString appendFormat:@"<products>\n"];
    
    int prodsCount = 0;
    for(Product *prod in self.products)
    {
        if(prod.qtyOriginal != prod.qtyAdjusted)
        {
            [xmlString appendFormat:@"%@", [prod xmlRepresentation]];
            prodsCount++;
        }
    }
    [xmlString appendFormat:@"</products>\n"];
    
    [xmlString appendFormat:@"</%@>\n", rootTagName];
    
    if(0 == prodsCount)
        return nil;
    
    return xmlString;
}

+ (NSDictionary *)mappingsFromObjectToXML
{
    NSArray *objects = [NSArray arrayWithObjects:@"sub_cat_id", @"sub_cat_name", @"products", @"total_amount", NSStringFromClass(self), nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"sub_cat_id", @"sub_cat_name", @"products", @"total_amount", @"SubCategory", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableDictionary *p_mappings = [NSMutableDictionary dictionaryWithDictionary:[Product mappingsFromObjectToXML]];
    
    [p_mappings addEntriesFromDictionary:mappings];
    
    return p_mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSArray *objects = [NSArray arrayWithObjects:@"string", @"string", @"array", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"sub_cat_id", @"sub_cat_name", @"products", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableDictionary *p_mappings = [NSMutableDictionary dictionaryWithDictionary:[Product dataTypesForProperties]];
    
    [p_mappings addEntriesFromDictionary:mappings];
    
    return p_mappings;
}

+ (NSDictionary *)classMappings
{
    NSDictionary *propertyAndTypes = [self propertyNamesAndTypes];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    
    [mappings setValue:NSStringFromClass(self) forKey:NSStringFromClass(self)];
    [mappings addEntriesFromDictionary:propertyAndTypes];
    
    [mappings addEntriesFromDictionary:[Product dataTypesForProperties]];
    
    NSMutableDictionary *p_mappings = [NSMutableDictionary dictionaryWithDictionary:[Product classMappings]];
    
    [p_mappings addEntriesFromDictionary:mappings];
    
    return p_mappings;
}



@end
