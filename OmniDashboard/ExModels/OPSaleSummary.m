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
#import "KSDateUtil.h"

@implementation OPSaleSummary
@synthesize itemBreakDown, categoryBreakDown, summaryBreakDown;
@synthesize grossSale, grossTax, grossDiscount, grossSurcharge, averageSale, totalRefunds, categoryTotals, itemTotals, categoryCountTotals, itemCountTotals;
@synthesize totalNoOfSale, totalGuestServed;
@synthesize totalCash, totalCard, totalVoucher, totalOnAccount, totalMix;
@synthesize timeWiseReports;

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
    NSMutableDictionary *dateWiseSales = [NSMutableDictionary dictionaryWithCapacity:24];
    for(int i = 1; i<=24; i++)
    {
        [dateWiseSales setValue:[NSNumber numberWithFloat:0] forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    for(NSString *trId in trGroupIDs)
    {
        NSArray *trGroups = [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"OrderTransactionID=%@", trId]];
        NSDate *dateTime = nil;
        float totalAmount = 0;
        for(NSDictionary *itemDict in trGroups)
        {
            if(!dateTime)
                dateTime = [KSDateUtil getDateFromString:[itemDict valueForKey:@"TransactionDate"]];
            
            if([[itemDict valueForKey:@"WasRefunded"] isEqualToString:@"False"] && [[itemDict valueForKey:@"WasVoided"] isEqualToString:@"False"])
            {
                self.grossSale+=[[itemDict valueForKey:@"Amount"] floatValue];
                self.grossTax+=[[itemDict valueForKey:@"TaxAmount"] floatValue];
                self.grossDiscount+=[[itemDict valueForKey:@"DiscountAmount"] floatValue];
                self.grossSurcharge+=[[itemDict valueForKey:@"SurchargeAmount"] floatValue];
                totalAmount+=[[itemDict valueForKey:@"Amount"] floatValue];
            }
            else if([[itemDict valueForKey:@"WasRefunded"] isEqualToString:@"True"])
            {
                self.totalRefunds+=[[itemDict valueForKey:@"Amount"] floatValue]*-1;
                self.totalNoOfSale--;
            }
        }
        
        
        NSString *startTimeString = @"08:00 AM";
        NSString *endTimeString = @"06:00 PM";
        
        for(NSString *key in dateWiseSales.allKeys)
        {            
            [self getStartTime:&startTimeString andEndTime:&endTimeString fromTime:key.intValue];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"hh:mm a"];
            
            NSString *nowTimeString = [formatter stringFromDate:dateTime];
            
            int startTime   = [self minutesSinceMidnight:[formatter dateFromString:startTimeString]];
            int endTime  = [self minutesSinceMidnight:[formatter dateFromString:endTimeString]];
            int nowTime     = [self minutesSinceMidnight:[formatter dateFromString:nowTimeString]];;

            if (startTime <= nowTime && nowTime <= endTime)
            {
                NSNumber *value = [dateWiseSales valueForKey:key];
                NSNumber *totalValue = [NSNumber numberWithFloat:value.floatValue+totalAmount];
                [dateWiseSales setValue:totalValue forKey:key];
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
    
    NSMutableArray *toRemovekeys = [NSMutableArray arrayWithCapacity:24];
    for(NSString *key in dateWiseSales)
    {
        NSNumber *val = [dateWiseSales valueForKey:key];
        if(val.floatValue<=0)
            [toRemovekeys addObject:key];
    }
    
    if(toRemovekeys.count)
        [dateWiseSales removeObjectsForKeys:toRemovekeys];
    
    summarySection.rows = summaries;
    self.summaryBreakDown=summarySection;
    self.timeWiseReports = dateWiseSales;
}

-(int) minutesSinceMidnight:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return 60 * (int)[components hour] + (int)[components minute];        
}

- (void)getStartTime:(NSString **)startTime andEndTime:(NSString **)endTime fromTime:(int)time
{
    switch (time) {
        case 1:
            {
                *startTime = @"01:00 AM";
                *endTime = @"02:00 AM";
            }
            break;
            
        case 2:
        {
            *startTime = @"02:00 AM";
            *endTime = @"03:00 AM";
        }
            break;
            
        case 3:
        {
            *startTime = @"03:00 AM";
            *endTime = @"04:00 AM";
        }
            break;
            
        case 4:
        {
            *startTime = @"04:00 AM";
            *endTime = @"05:00 AM";
        }
            break;
            
        case 5:
        {
            *startTime = @"05:00 AM";
            *endTime = @"06:00 AM";
        }
            break;
            
        case 6:
        {
            *startTime = @"06:00 AM";
            *endTime = @"07:00 AM";
        }
            break;
            
        case 7:
        {
            *startTime = @"07:00 AM";
            *endTime = @"08:00 AM";
        }
            break;
            
        case 8:
        {
            *startTime = @"08:00 AM";
            *endTime = @"09:00 AM";
        }
            break;
            
        case 9:
        {
            *startTime = @"09:00 AM";
            *endTime = @"10:00 AM";
        }
            break;
            
        case 10:
        {
            *startTime = @"10:00 AM";
            *endTime = @"11:00 AM";
        }
            break;
            
        case 11:
        {
            *startTime = @"11:00 AM";
            *endTime = @"12:00 AM";
        }
            break;
            
        case 12:
        {
            *startTime = @"12:00 AM";
            *endTime = @"01:00 PM";
        }
            break;
            
        case 13:
        {
            *startTime = @"01:00 PM";
            *endTime = @"02:00 PM";
        }
            break;
            
        case 14:
        {
            *startTime = @"02:00 PM";
            *endTime = @"03:00 PM";
        }
            break;
            
        case 15:
        {
            *startTime = @"03:00 PM";
            *endTime = @"04:00 PM";
        }
            break;
            
        case 16:
        {
            *startTime = @"04:00 PM";
            *endTime = @"05:00 PM";
        }
            break;
            
        case 17:
        {
            *startTime = @"05:00 PM";
            *endTime = @"06:00 PM";
        }
            break;
            
        case 18:
        {
            *startTime = @"06:00 PM";
            *endTime = @"07:00 PM";
        }
            break;
            
        case 19:
        {
            *startTime = @"07:00 PM";
            *endTime = @"08:00 PM";
        }
            break;
            
        case 20:
        {
            *startTime = @"08:00 PM";
            *endTime = @"09:00 PM";
        }
            break;
            
        case 21:
        {
            *startTime = @"09:00 PM";
            *endTime = @"10:00 PM";
        }
            break;
            
        case 22:
        {
            *startTime = @"10:00 PM";
            *endTime = @"11:00 PM";
        }
            break;
            
        case 23:
        {
            *startTime = @"11:00 PM";
            *endTime = @"12:00 PM";
        }
            break;
            
        case 24:
        {
            *startTime = @"12:00 PM";
            *endTime = @"01:00 AM";
        }
            break;
            
        default:
            break;
    }
}
@end
