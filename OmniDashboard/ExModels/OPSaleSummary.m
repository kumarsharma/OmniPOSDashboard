//
//  OPSaleSummary.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 28/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPSaleSummary.h"
#import "OPReportSection.h"
#import "OPCategoryItem.h"

@implementation OPSaleSummary
@synthesize itemBreakDown, categoryBreakDown, summaryBreakDown;
@synthesize grossSale, grossTax, grossDiscount, grossSurcharge, averageSale, totalRefunds, categoryTotals, itemTotals, categoryCountTotals, itemCountTotals;
@synthesize totalNoOfSale, totalGuestServed;
@synthesize totalCash, totalCard, totalVoucher, totalOnAccount, totalMix;

- (void)parseFromRawItems:(NSArray *)items
{
    self.grossSale=self.grossTax=self.grossDiscount=self.grossSurcharge=self.averageSale=self.totalRefunds=0;
    self.totalNoOfSale=self.totalGuestServed=0;
    self.itemTotals=self.categoryTotals=self.itemCountTotals=self.categoryCountTotals=0;
    totalCash=totalCard=totalVoucher=totalOnAccount=totalMix=0;
    
    NSArray *itemGroupIDs = [items valueForKeyPath:@"@distinctUnionOfObjects.ItemID"];
    NSMutableDictionary *itemGroups = [NSMutableDictionary dictionaryWithCapacity:itemGroupIDs.count];
    NSArray *categoryGroupIDs = [items valueForKeyPath:@"@distinctUnionOfObjects.CategoryID"];
    NSMutableDictionary *categoryGroups = [NSMutableDictionary dictionaryWithCapacity:itemGroupIDs.count];
    if(itemGroupIDs.count)
    {
        for(NSString *itemId in itemGroupIDs)
        {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"ItemID=%@", itemId];
            NSArray *itemGroup = [items filteredArrayUsingPredicate:p];
            NSString *itemName = [[itemGroup firstObject] valueForKey:@"ProductName"];
            [itemGroups setValue:itemGroup forKey:itemName];
        }
    }
    
    if(categoryGroupIDs.count)
    {
        for(NSString *catId in categoryGroupIDs)
        {
            NSPredicate *p = [NSPredicate predicateWithFormat:@"CategoryID=%@", catId];
            NSArray *catGroup = [items filteredArrayUsingPredicate:p];
            NSString *catName = [[catGroup firstObject] valueForKey:@"CategoryName"];
            [categoryGroups setValue:catGroup forKey:catName];
        }
    }
    
    //for open items;
    NSPredicate *p = [NSPredicate predicateWithFormat:@"ItemID=%@", @"-1"];
    NSArray *itemGroup = [items filteredArrayUsingPredicate:p];
    if(itemGroup.count)
        [itemGroups setValue:itemGroup forKey:@"Open Items"];
    
    OPReportSection *itemSection = [[OPReportSection alloc] init];
    itemSection.sectionTitle = @"Items";
    NSMutableArray *itemSolds = [NSMutableArray array];
    for(NSString *key in itemGroups)
    {
        NSArray *values = [itemGroups valueForKey:key];
        float totals = 0, totalQty=0;
        NSString *cid = @"";
        for(NSDictionary *itemDict in values){
            
            totalQty+=[[itemDict valueForKey:@"Qty"] floatValue];
            totals+=[[itemDict valueForKey:@"Amount"] floatValue];
            if(cid.length<=0)
                cid = [itemDict valueForKey:@"ItemID"]; 
        }
        self.itemTotals+=totals;
        self.itemCountTotals+=totalQty;
        
        OPCategoryItem *citem = [[OPCategoryItem alloc] init];
        citem.uid = cid;
        citem.name = key;
        citem.qty = totalQty;
        citem.amount = totals;
        [itemSolds addObject:citem];
    }
    
    //for total last row
    /*
    NSDictionary *totalItem = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.itemTotals] forKey:[NSString stringWithFormat:@"%@ X %0.2f", @"TOTAL", self.itemCountTotals]];
    [itemSolds addObject:totalItem];
     */
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];    
    [itemSolds sortUsingDescriptors:sortDescriptors];

    itemSection.rows = itemSolds;
    self.itemBreakDown=itemSection;
    
    
    OPReportSection *catSection = [[OPReportSection alloc] init];
    catSection.sectionTitle = @"Categories";
    NSMutableArray *catSolds = [NSMutableArray array];
    for(NSString *key in categoryGroups.allKeys)
    {
        NSArray *values = [categoryGroups valueForKey:key];
        float totals = 0, totalQty=0;
        NSString *cid = @"";
        for(NSDictionary *itemDict in values){
            
            totalQty+=[[itemDict valueForKey:@"Qty"] floatValue];
            totals+=[[itemDict valueForKey:@"Amount"] floatValue];
            if(cid.length<=0)
                cid = [itemDict valueForKey:@"CategoryID"]; 
        }
        self.categoryTotals+=totals;
        self.categoryCountTotals+=totalQty;
        OPCategoryItem *citem = [[OPCategoryItem alloc] init];
        citem.uid = cid;
        citem.name = key;
        citem.qty = totalQty;
        citem.amount = totals;
        [catSolds addObject:citem];
    }
    //for total last row
    /*
    NSDictionary *totalCats = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.categoryTotals] forKey:[NSString stringWithFormat:@"%@ X %0.2f", @"TOTAL", self.categoryCountTotals]];
     [catSolds addObject:totalCats];*/
    
    firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO];
    sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];    
    [catSolds sortUsingDescriptors:sortDescriptors];
    
    catSection.rows = catSolds;
    self.categoryBreakDown = catSection;
    
    NSArray *trGroupIDs = [items valueForKeyPath:@"@distinctUnionOfObjects.OrderTransactionID"];
    self.totalNoOfSale = (int)trGroupIDs.count;
    for(NSString *trId in trGroupIDs)
    {
        NSArray *trGroups = [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"OrderTransactionID=%@", trId]];
        for(NSDictionary *itemDict in trGroups)
        {
            if([[itemDict valueForKey:@"WasRefunded"] isEqualToString:@"False"] && [[itemDict valueForKey:@"WasVoided"] isEqualToString:@"False"])
            {
                self.grossSale+=[[itemDict valueForKey:@"Amount"] floatValue];
                self.grossTax+=[[itemDict valueForKey:@"TaxAmount"] floatValue];
                self.grossDiscount+=[[itemDict valueForKey:@"DiscountAmount"] floatValue];
                self.grossSurcharge+=[[itemDict valueForKey:@"SurchargeAmount"] floatValue];
            }
            else if([[itemDict valueForKey:@"WasRefunded"] isEqualToString:@"True"])
            {
                self.totalRefunds+=[[itemDict valueForKey:@"Amount"] floatValue]*-1;
                self.totalNoOfSale--;
            }
        }
    }
    self.averageSale = self.grossSale/self.totalNoOfSale;
    
    NSArray *paymentGroupIDs = [items valueForKeyPath:@"@distinctUnionOfObjects.PaymentType"];
    for(NSString *paymentId in paymentGroupIDs)
    {
        NSArray *paymentGroups = [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"PaymentType=%@", paymentId]];
        for(NSDictionary *itemDict in paymentGroups)
        {
            if([[itemDict valueForKey:@"WasRefunded"] isEqualToString:@"False"] && [[itemDict valueForKey:@"WasVoided"] isEqualToString:@"False"])
            {
                if([paymentId isEqualToString:@"1"])
                    self.totalCash+=[[itemDict valueForKey:@"Amount"] floatValue];
                else if([paymentId isEqualToString:@"2"])
                    self.totalCard+=[[itemDict valueForKey:@"Amount"] floatValue];
                else if([paymentId isEqualToString:@"3"])
                    self.totalVoucher+=[[itemDict valueForKey:@"Amount"] floatValue];
                else if([paymentId isEqualToString:@"4"])
                    self.totalOnAccount+=[[itemDict valueForKey:@"Amount"] floatValue];
                else
                    self.totalMix+=[[itemDict valueForKey:@"Amount"] floatValue];
            }
        }
    }
    
    //summaries
    OPReportSection *summarySection = [[OPReportSection alloc] init];
    itemSection.sectionTitle = @"Summaries";
    NSMutableArray *summaries = [NSMutableArray array];

    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.totalCash] forKey:@"Cash"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.totalCard] forKey:@"Card"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.totalVoucher] forKey:@"Voucher"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.totalOnAccount] forKey:@"On A/c"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.totalMix] forKey:@"Others"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.grossDiscount] forKey:@"Discount"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.grossSurcharge] forKey:@"Surcharge"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.totalRefunds] forKey:@"Refund"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.grossTax] forKey:@"Tax"]];
    [summaries addObject:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%0.2f", self.grossSale] forKey:@"GROSS TOTAL"]];
    
    summarySection.rows = summaries;
    self.summaryBreakDown=summarySection;
}

@end
