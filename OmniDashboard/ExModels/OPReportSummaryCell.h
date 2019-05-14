//
//  OPReportSummaryCell.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CW.h"
#import "UnderLineLabel.h"

@class OPSaleSummary;
@interface OPReportSummaryCell : UITableViewCell
{
    
}

@property (nonatomic, strong) UILabel *grossSaleLabel, *salesLabel, *avgSalesLabel;
@property (nonatomic, strong) UnderLineLabel * reportTitleLabel;
@property (nonatomic, strong) OPSaleSummary *saleSummary;
@property (nonatomic, strong) WKWebView *webview;
@property  (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) CWBarChart* barChart;
@property (nonatomic, assign) BOOL showOnlyValuedBars;
- (void)reloadViews;
@end

