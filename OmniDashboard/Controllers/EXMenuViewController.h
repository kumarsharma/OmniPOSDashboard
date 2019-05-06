//
//  EXListViewController.h
//  ExTunes
//
//  Created by Kumar Sharma on 14/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RangePickerViewController.h"
#import "OPSaleSummary.h"
#import "LoadingIndicatorView.h"
#import "OPViewController.h"

@interface EXMenuViewController : OPViewController<RangeDatePickerDelegate, UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *exList;
@property (nonatomic, strong) LoadingIndicatorView *indicatorView;
@property (nonatomic, strong) NSDate *date1, *date2, *compareDate1, *compareDate2;
@property (nonatomic, strong) OPSaleSummary *saleSummary, *saleSummary2;
@property (nonatomic, strong) UIBarButtonItem *middleBarItem;
@property (nonatomic, strong) NSString *rangeType; 

- (void)showErrorMessage;
- (void)fetchReports;
- (void)updateDateLabel;
@end
