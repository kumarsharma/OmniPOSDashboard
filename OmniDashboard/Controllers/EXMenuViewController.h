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

@interface EXMenuViewController : UITableViewController<RangeDatePickerDelegate, UIActionSheetDelegate>
{
    
}
@property (nonatomic, strong) NSArray *exList;
@property (nonatomic, strong) LoadingIndicatorView *indicatorView;
@property (nonatomic, strong) NSDate *date1, *date2;
@property (nonatomic, strong) OPSaleSummary *saleSummary;
@property (nonatomic, strong) UIBarButtonItem *middleBarItem;
@property (nonatomic, strong) NSString *rangeType; 

- (void)showErrorMessage;
- (void)fetchReports;
- (void)updateDateLabel;
@end
