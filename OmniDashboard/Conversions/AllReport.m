//
//  AllReport.m
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "AllReport.h"
#import "NSObject+XMLSerializableSupport.h"
#import "ItemSoldReport.h"
#import "SubCategory.h"

@implementation AllReport

@synthesize itemSoldReport = _itemSoldReport;
@synthesize adjustedCashSale = _adjustedCashSale;
@synthesize adjustedTax = _adjustedTax;

#pragma mark - Xml

- (NSString *)xmlRepresentation
{
    NSMutableString *xmlString = nil;
    
    
    NSString *xml = [self.itemSoldReport xmlRepresentation];
    
    if(xml)
    {
        xmlString = [NSMutableString string];
        
//        NSString *rootTagName = @"CategoryReport";
//        [xmlString appendFormat:@"<%@>\n", rootTagName];
        [xmlString appendFormat:@"%@", [self.itemSoldReport xmlRepresentation]];
//        [xmlString appendFormat:@"</%@>", rootTagName];
    }
    
    return xmlString;
}


- (float)adjustedCashSale{
    
    float total = 0;
    float totalAdj = 0;
    for(SubCategory *cat in self.itemSoldReport.subCategories)
        total += cat.totalSold;
    
    for(SubCategory *cat in self.itemSoldReport.subCategories)
        totalAdj += cat.adjustedSale;
    
    float adjCashSale = total - totalAdj;
    if(total > 0)
    {
        adjCashSale = self.cashSale - adjCashSale;
    }
    
    return adjCashSale;
}


- (float)totalSale{
    
    float total = 0;
    for(SubCategory *cat in self.itemSoldReport.subCategories)
        total += cat.totalSold;
    
    return total;
}

- (float)adjustedCashSaleForGST{
    
    float total = 0;
    float totalAdj = 0;
    for(SubCategory *cat in self.itemSoldReport.subCategories)
        total += cat.totalSold;
    
    for(SubCategory *cat in self.itemSoldReport.subCategories)
        totalAdj += [cat adjustedSaleForGST];
    
    float adjCashSale = total - totalAdj;
    if(total > 0)
    {
        adjCashSale = self.cashSale - adjCashSale;
    }
    
    return adjCashSale;
}

- (float)totalAdjustedTax{
    
    float totalAmount = self.voucherSale + self.cardSale + self.cashSale;
    float adj_tax_Amount = self.voucherSale + self.cardSale + [self adjustedCashSaleForGST];
    
    float diff_tax = totalAmount - adj_tax_Amount;
    
    float tax = (diff_tax / (100+10)) * 10;
    
    tax = self.taxAmount - tax;
    
    return tax;
}

+ (AllReport *)parseXml:(NSData *)xmlData
{
    AllReport *objectHolder =  (AllReport *)[self fromXMLData:xmlData mappings:[self objectToXMLMapping] dataTypes:[self dataTypesForProperties] classMappings:[self classMappings]];
    
    return objectHolder;
}

+ (NSDictionary *)objectToXMLMapping
{
    NSArray *objects = [NSArray arrayWithObjects:@"cashSale", @"cardSale", @"voucherSale", @"refundAmount", @"payoutAmount", @"tipAmount", @"taxAmount", @"surChargeAmount", @"discountAmount", @"grossAmount", @"totalNetAmount", @"itemSoldReport", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"cash_sale", @"card_sale", @"voucher_sale", @"total_refund", @"total_payout", @"total_tips", @"total_tax", @"total_surcharge", @"total_discount", @"gross_sale", @"net_sale", @"ItemSoldReport", nil];
    
    NSDictionary *mappingsForInfo = [ItemSoldReport mappingsFromObjectToXML];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [mappings addEntriesFromDictionary:mappingsForInfo];
    
    return mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSDictionary *classMappingsFromInfo = [ItemSoldReport dataTypesForProperties];
    
    NSArray *objects = [NSArray arrayWithObjects:@"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"ItemSoldReport", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"CashSale", @"CardSale", @"VoucherSale", @"RefundAmount", @"PayoutAmount", @"TipAmount", @"TaxAmount", @"SurChargeAmount", @"DiscountAmount", @"TotalNetAmount", @"GrossAmount", @"ItemSoldReport", nil];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [mappings addEntriesFromDictionary:classMappingsFromInfo];
    
    return mappings;
}

+ (NSDictionary *)classMappings
{
    NSDictionary *classMappingsFromInfo = [ItemSoldReport classMappings];
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSStringFromClass([ItemSoldReport class]), nil] forKeys:[NSArray arrayWithObjects:@"ItemSoldReport", nil]];
    
    [mappings addEntriesFromDictionary:classMappingsFromInfo];
    
    return mappings;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Ignored: set value: for undefined key: %@", key);
}

@end
