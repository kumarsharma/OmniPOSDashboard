//
//  OPReportComparisonCell.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 06/05/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CW.h"
#import "UnderLineLabel.h"

@class OPSaleSummary;
@interface OPReportComparisonCell : UITableViewCell
{
    
}

@property (nonatomic, strong) UILabel *grossSaleLabel, *salesLabel, *avgSalesLabel, *titleLabel1, *titleLabel2;
@property (nonatomic, strong) UnderLineLabel * reportTitleLabel;
@property (nonatomic, strong) UILabel *grossSaleLabel2, *salesLabel2, *avgSalesLabel2;
@property (nonatomic, strong) OPSaleSummary *saleSummary, *saleSummary2;
@property (nonatomic, strong) WKWebView *webview;
@property  (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) CWBarChart* barChart;
@property (nonatomic, assign) BOOL showOnlyValuedBars;
- (void)reloadViews;
@end
