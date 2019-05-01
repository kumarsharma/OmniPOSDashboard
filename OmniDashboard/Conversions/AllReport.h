//
//  AllReport.h
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPReportHolder.h"

@class ItemSoldReport;
@interface AllReport : OPReportHolder
{
    ItemSoldReport *_itemSoldReport;
    float _adjustedCashSale, _adjustedTax;
}

@property (nonatomic, strong) ItemSoldReport *itemSoldReport;

@property (nonatomic, assign) float adjustedCashSale, adjustedTax;

- (NSString *)xmlRepresentation;
- (float)totalAdjustedTax;
@end
