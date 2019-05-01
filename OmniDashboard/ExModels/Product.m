//
//  Product.m
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "Product.h"
#import "NSObject+PropertySupport.h"
#import "Product.h"
#import "KSDateUtil.h"

@implementation Product
@synthesize prod_id, prod_name;
@synthesize unitPrice, qtyOriginal = _qtyOriginal, qtyAdjusted = _qtyAdjusted, totalPrice;
@synthesize adjustedPrice;
@synthesize wasRowSelected = _wasRowSelected;
@synthesize lastAdjustedValue;
@synthesize hasGST;

- (float)unitPrice{
    
    if(self.qtyOriginal == 0)
        return 0;
    
    return self.totalPrice/self.qtyOriginal;
}

- (float)adjustedPrice{
    
    float price = self.unitPrice * self.qtyAdjusted;
    return price;
}

- (float)adjustedPriceForGST{
    
    float price = 0;
    if([self.hasGST isEqualToString:@"True"])
    {
        price = self.unitPrice * self.qtyAdjusted;
    }
    else{
        
        price = self.unitPrice * self.qtyOriginal;
    }
    return price;
}

- (void)setQtyOriginal:(float)qtyOriginal{
    
    _qtyOriginal = qtyOriginal;
    _qtyAdjusted = _qtyOriginal;
}

- (BOOL)shouldInclusedPropertyInXML:(NSString *)prop{
    
    NSArray *includedProps = [NSArray arrayWithObjects:@"prod_id", @"qtyAdjusted", nil];
    
    if([includedProps containsObject:prop])
        return YES;
    
    return NO;
}

#pragma mark - Xml

- (NSString *)xmlRepresentation
{
    NSMutableString *xmlString = [NSMutableString string];
    
    NSString *rootTagName = NSStringFromClass([self class]);
    
    [xmlString appendFormat:@"<%@>\n", rootTagName];
    
    [xmlString appendFormat:@"<id>%@</id>\n", self.prod_id];
    [xmlString appendFormat:@"<org_qty>%0.2f</org_qty>\n", self.qtyOriginal];
    [xmlString appendFormat:@"<adj_qty>%0.2f</adj_qty>\n", self.qtyAdjusted];
    [xmlString appendFormat:@"<org_amt>%0.2f</org_amt>\n", self.totalPrice];
    [xmlString appendFormat:@"<adj_amt>%0.2f</adj_amt>\n", self.adjustedPrice];
    [xmlString appendFormat:@"<hasGST>%@</hasGST>\n", self.hasGST];
    
    [xmlString appendFormat:@"</%@>\n", rootTagName];
    
    return xmlString;
}

+ (NSDictionary *)mappingsFromObjectToXML
{
    NSArray *objects = [NSArray arrayWithObjects:@"prod_id", @"prod_name", @"totalPrice", @"qtyOriginal", @"hasGST", NSStringFromClass(self), nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"prod_id", @"prod_name", @"price", @"qty", @"HasGST", @"Product", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSArray *objects = [NSArray arrayWithObjects:@"string", @"string", @"float", @"float", @"boolean", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"prod_id", @"prod_name", @"totalPrice", @"qtyOriginal", @"hasGST", nil];
    
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
