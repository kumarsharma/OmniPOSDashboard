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
#import "DGActivityIndicatorView.h"

@interface EXMenuViewController : UITableViewController<RangeDatePickerDelegate>
{
    
}
@property (nonatomic, strong) NSArray *exList;
@property (nonatomic, strong) DGActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSDate *date1, *date2;
@property (nonatomic, strong) OPSaleSummary *saleSummary;
@property (nonatomic, strong) UIBarButtonItem *middleBarItem;

- (void)showErrorMessage;
- (void)fetchReports;
- (void)updateDateLabel;
@end
