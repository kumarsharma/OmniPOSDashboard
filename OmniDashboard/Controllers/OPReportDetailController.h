//
//  OPReportDetailController.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPSaleSummary.h"
#import "OPReportViewController.h"
#import "OPViewController.h"

@interface OPReportDetailController : OPViewController<OPDateSelectionDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, weak) OPReportViewController *parentController;
@property (nonatomic, assign) BOOL isSaleSummaryMode, isItemSaleMode, isCategorySaleMode, isComparisonMode;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LoadingIndicatorView *indicatorView;
@property (nonatomic, strong) NSDate *date1, *date2, *compareDate1, *compareDate2;
@property (nonatomic, strong) OPSaleSummary *saleSummary, *saleSummary2;
@property (nonatomic, strong) UIBarButtonItem *middleBarItem;
@property (nonatomic, strong) NSString *rangeType; 
@end
