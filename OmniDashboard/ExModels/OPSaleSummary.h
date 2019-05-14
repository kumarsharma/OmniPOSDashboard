//
//  OPSaleSummary.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 28/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPReportSection.h"

@interface OPSaleSummary : NSObject
{
    
}

@property (nonatomic, assign) float grossSale, grossTax, grossDiscount, grossSurcharge, averageSale, totalRefunds, categoryTotals, itemTotals, categoryCountTotals, itemCountTotals, totalCash, totalCard, totalVoucher, totalOnAccount, totalMix;
@property (nonatomic, assign) int totalNoOfSale, totalGuestServed;

@property (nonatomic, strong) OPReportSection *itemBreakDown, *categoryBreakDown, *summaryBreakDown;
@property (nonatomic, strong) NSDictionary *timeWiseReports;
- (void)parseFromRawItems:(NSArray *)items;
@end
