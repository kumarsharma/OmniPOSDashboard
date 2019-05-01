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

@interface OPFurtherReportViewController : UITableViewController<RangeDatePickerDelegate, UIActionSheetDelegate>
{
    
}

@property (nonatomic, weak) EXMenuViewController *parentController;
@property (nonatomic, assign) BOOL isSaleSummaryMode, isItemSaleMode, isCategorySaleMode;

@property (nonatomic, strong) LoadingIndicatorView *indicatorView;
@property (nonatomic, strong) NSDate *date1, *date2;
@property (nonatomic, strong) OPSaleSummary *saleSummary;
@property (nonatomic, strong) UIBarButtonItem *middleBarItem;
@property (nonatomic, strong) NSString *rangeType; 
@end
