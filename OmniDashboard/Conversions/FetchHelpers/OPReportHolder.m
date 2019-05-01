//
//  OPReportHolder.m
//  omniPOS
//
//  Created by Kumar Sharma on 11/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "OPReportHolder.h"
#import "OPReportInfo.h"
#import "NSObject+XMLSerializableSupport.h"

@implementation OPReportHolder
@synthesize fromDate, tillDate, reportTitle;

@synthesize cashSale, cardSale, voucherSale, refundAmount, payoutAmount, tipAmount, taxAmount, surChargeAmount, discountAmount, totalNetAmount, grossAmount, paypalSale, creditSale, onlineSale, loyaltyPointsSale, mixSale, taSale, diSale, pendingCashSale, pendingCardSale, pendingVoucherSale, pendingOtherSale, pendingTax, pendingGrossSale, pendingNetSale, pendingDiscount, pendingSurcharge;

@synthesize drawerDetails, employeeDetails, categoryDetails, productDetails, modifierDetails, deviceDetails;
@synthesize totalTiTrans, totalDITrans, totalQty;
@synthesize isLocal;
@synthesize hourlySales, itemSolds;
@synthesize reportType;

+ (OPReportHolder *)parseXml:(NSData *)xmlData
{
    OPReportHolder *objectHolder =  (OPReportHolder *)[self fromXMLData:xmlData mappings:[self objectToXMLMapping] dataTypes:[self dataTypesForProperties] classMappings:[self classMappings]];
    
    return objectHolder;
}

+ (NSDictionary *)objectToXMLMapping
{    
    NSArray *objects = [NSArray arrayWithObjects:@"fromDate", @"tillDate", @"cashSale", @"cardSale", @"voucherSale", @"refundAmount", @"payoutAmount", @"tipAmount", @"taxAmount", @"surChargeAmount", @"discountAmount", @"totalNetAmount", @"grossAmount", @"paypalSale", @"creditSale", @"loyaltyPointsSale", @"onlineSale", @"mixSale", @"taSale", @"diSale",@"totalTiTrans", @"totalDITrans", @"deviceDetails", nil];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"FromDate", @"TillDate", @"cash_sale", @"card_sale", @"voucher_sale", @"total_refund", @"total_payout", @"total_tips", @"total_tax", @"total_surcharge", @"total_discount", @"net_sale", @"gross_sale", @"paypal_sale", @"credit_sale", @"loyalty_points_sale", @"online_sale", @"other_sale", @"total_ta_sale", @"total_di_sale",@"total_ta_trans", @"total_di_trans", @"Devices", nil];
    
    NSDictionary *mappingsForInfo = [OPReportInfo mappingsFromObjectToXML];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [mappings addEntriesFromDictionary:mappingsForInfo];
    
    return mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSDictionary *classMappingsFromInfo = [OPReportInfo dataTypesForProperties];
    
    NSArray *objects = [NSArray arrayWithObjects:@"string", @"string", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"float", @"int", @"int", @"array", nil];
    
    
    NSArray *keys = [NSArray arrayWithObjects:@"FromDate", @"TillDate", @"cash_sale", @"card_sale", @"voucher_sale", @"total_refund", @"total_payout", @"total_tips", @"total_tax", @"total_surcharge", @"total_discount", @"net_sale", @"gross_sale", @"paypal_sale", @"credit_sale", @"loyalty_points_sale", @"online_sale", @"other_sale", @"total_ta_sale", @"total_di_sale",@"total_ta_trans", @"total_di_trans", @"Devices", nil];
    
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [mappings addEntriesFromDictionary:classMappingsFromInfo];
    
    return mappings;
}

+ (NSDictionary *)classMappings
{
    NSDictionary *classMappingsFromInfo = [OPReportInfo classMappings];
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:NSStringFromClass(self), NSStringFromClass(self), nil] forKeys:[NSArray arrayWithObjects:@"ZReportInfo", @"XReportInfo", nil]];
    [mappings addEntriesFromDictionary:classMappingsFromInfo];
    
    return mappings;
}


@end
