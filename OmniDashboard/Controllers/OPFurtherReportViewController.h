//
//  OPFurtherReportViewController.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPSaleSummary.h"
#import "EXMenuViewController.h"

@interface OPFurtherReportViewController : EXMenuViewController
{
    
}

@property (nonatomic, weak) EXMenuViewController *parentController;
@property (nonatomic, assign) BOOL isSaleSummaryMode, isItemSaleMode, isCategorySaleMode;
@end
