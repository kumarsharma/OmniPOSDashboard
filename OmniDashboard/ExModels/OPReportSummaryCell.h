//
//  OPReportSummaryCell.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSBarChart.h"

@class OPSaleSummary;
@interface OPReportSummaryCell : UITableViewCell
{
    
}

@property (nonatomic, strong) UILabel *grossSaleLabel, *salesLabel, *avgSalesLabel;
@property (nonatomic, strong) DSBarChart *chartView;
@property (nonatomic, strong) OPSaleSummary *saleSummary;
- (void)reloadViews;
@end

