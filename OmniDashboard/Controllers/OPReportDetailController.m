//
//  OPFurtherReportViewController.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPReportDetailController.h"
#import "KSDateUtil.h"
#import "OPReportItemCell.h"
#import "OPDataFetchHelper.h"
#import "NSString+SBJSON.h"
#import "OPCategoryItem.h"
#import "OPReportComparisonItemCell.h"

@interface OPReportDetailController ()
@property (nonatomic, strong) UIRefreshControl *refreshController;

@end

@implementation OPReportDetailController
@synthesize isSaleSummaryMode, isItemSaleMode, isCategorySaleMode, isComparisonMode;
@synthesize parentController;
@synthesize indicatorView;
@synthesize date1, date2, compareDate1, compareDate2;
@synthesize saleSummary, saleSummary2;
@synthesize middleBarItem;
@synthesize rangeType;
@synthesize refreshController;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isSaleSummaryMode)
        self.title = @"Sale Summary";
    else if(isItemSaleMode)
        self.title = @"By Item";
    else if(isCategorySaleMode)
        self.title = @"By Category";
    else if(isComparisonMode)
        self.title = @"Comparison";
    
    self.viewTitleLabel.text = self.title;
    self.date1 = self.parentController.date1;
    self.date2=self.parentController.date2;
    self.compareDate1 = self.parentController.compareDate1;
    self.compareDate2=self.parentController.compareDate2;
    self.saleSummary = self.parentController.saleSummary;
    self.saleSummary2 = self.parentController.saleSummary2;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarView.frame.size.height+self.topBarView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-(self.topBarView.frame.size.height+self.topBarView.frame.origin.y)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    //    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *prevDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(prevDayBtnAction)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *dateBtn = [[UIBarButtonItem alloc] initWithTitle:[KSDateUtil getDayMonthYearString:[NSDate date]] style:UIBarButtonItemStyleDone target:self action:@selector(dateBtnAction)];
    
    self.middleBarItem = dateBtn;
    self.middleBarItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *nextDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right-arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(nextDatBtnAction)];
    self.toolbarItems = [NSArray arrayWithObjects:prevDayBtn, space, dateBtn, space2, nextDayBtn, nil];
    
    [self updateDateLabel];
    
    /*
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    //    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *prevDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(prevDayBtnAction)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *dateBtn = [[UIBarButtonItem alloc] initWithTitle:[KSDateUtil getYYYyMmDdDateFormat:[NSDate date]] style:UIBarButtonItemStyleDone target:self action:@selector(dateBtnAction)];
    self.middleBarItem = dateBtn;
    self.middleBarItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *nextDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(nextDatBtnAction)];
    self.toolbarItems = [NSArray arrayWithObjects:prevDayBtn, space, dateBtn, space2, nextDayBtn, nil];
    self.date1 = [NSDate date];
    self.date2 = self.date1;*/
    
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshController];
}

#pragma mark - Handle Refresh Method

-(void)handleRefresh : (id)sender
{
    [self.refreshController endRefreshing];
    [self fetchReports];
}

- (void)dateBtnAction
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Today", @"This Week", @"This Month", @"Custom", nil];
    [actionsheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex<4)
    {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        self.rangeType = title;
        if([self.rangeType isEqualToString:@"Today"] || [self.rangeType isEqualToString:@"This Week"] || [self.rangeType isEqualToString:@"This Month"])
        {
            if([self.rangeType isEqualToString:@"Today"])
            {
                self.date1 = [NSDate date];
                self.date2 = self.date1;
            }
            else if([self.rangeType isEqualToString:@"This Week"])
            {
                self.date1 = [KSDateUtil getCurrentWeeksBeginingDate];
                self.date2 = [NSDate date];
            }
            else if([self.rangeType isEqualToString:@"This Month"])
            {
                self.date1 = [KSDateUtil getFirstDayOfCurrentMonth];
                self.date2 = [NSDate date];
            }
            
            [self fetchReports];
            [self updateDateLabel];
        }
        else
        {
            [self showDateView];
        }
    }
}

- (void)nextDatBtnAction
{
    if([self.rangeType isEqualToString:@"Today"])
    {
        self.date1 = [KSDateUtil getNextDayByCount:1 fromDate:self.date1];
        self.date2 = self.date1;
    }
    else if([self.rangeType isEqualToString:@"This Week"])
    {
        self.date1 = [KSDateUtil getNextWeekByCount:7 fromDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:6 fromDate:self.date1];
    }
    else if([self.rangeType isEqualToString:@"This Month"])
    {
        self.date1 = [KSDateUtil getNextMonthByCount:1 fromDate:self.date1];
        NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:days.length-1 fromDate:self.date1];
    }
    else
    {
        int dayToAdd = (int)[KSDateUtil getDayDiffBetweenDate1:self.date1 andDate2:self.date2]+1;
        self.date1 = [KSDateUtil getNextDayByCount:dayToAdd fromDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:dayToAdd fromDate:self.date2];
    }
    
    [self fetchReports];
    [self updateDateLabel];
}

- (void)prevDayBtnAction
{
    if([self.rangeType isEqualToString:@"Today"])
    {
        self.date1 = [KSDateUtil getNextDayByCount:-1 fromDate:self.date1];
        self.date2 = self.date1;
    }
    else if([self.rangeType isEqualToString:@"This Week"])
    {
        self.date1 = [KSDateUtil getNextWeekByCount:-7 fromDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:6 fromDate:self.date1];
    }
    else if([self.rangeType isEqualToString:@"This Month"])
    {
        self.date1 = [KSDateUtil getNextMonthByCount:-1 fromDate:self.date1];
        NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:days.length-1 fromDate:self.date1];
    }
    else
    {
        int dayToReduce = (int)[KSDateUtil getDayDiffBetweenDate1:self.date1 andDate2:self.date2]+1;
        self.date1 = [KSDateUtil getNextDayByCount:dayToReduce*-1 fromDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:dayToReduce*-1 fromDate:self.date2];
    }
    [self fetchReports];
    [self updateDateLabel];
}

- (void)updateDateLabel
{
    if([self.rangeType isEqualToString:@"Todayz"])
        [self.middleBarItem setTitle:@"Today"];
    else if([self.rangeType isEqualToString:@"This Weekz"])
        [self.middleBarItem setTitle:@"This Week"];
    else if([self.rangeType isEqualToString:@"This Monthz"])
        [self.middleBarItem setTitle:@"This Month"];
    else
    {
        if([self.date1 compare:self.date2] == NSOrderedSame)
        {
            [self.middleBarItem setTitle:[KSDateUtil getDayMonthYearString:self.date1]];
        }
        else
        {
            [self.middleBarItem setTitle:[NSString stringWithFormat:@"%@-%@", [KSDateUtil getDayMonthYearString:self.date1], [KSDateUtil getDayMonthYearString:self.date2]]];
        }
    }
}

- (void)showDateView
{
    OPCalendarViewController *vc = [[OPCalendarViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}



- (void)viewDidAppear:(BOOL)animated
{
//    [super viewDidAppear:animated];
//    [self fetchReports];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.isSaleSummaryMode)
    {
        if(section==0)
            return @"Summary";
        else
            return @"Comparison";
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary && (self.isItemSaleMode || self.isCategorySaleMode || self.isComparisonMode || self.isSaleSummaryMode))
    {
        if(self.isComparisonMode)
            return 50;
        else
            return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary && (self.isItemSaleMode || self.isCategorySaleMode))
    {
        OPReportItemCell *cell = [[OPReportItemCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        cell.titleLabel.text = @"Item";
        cell.countField.text = @"Qty";
        cell.totalAmountLabel.text = @"Amount";
        if(self.isItemSaleMode)
            cell.titleLabel.text = @"Item";
        else
            cell.titleLabel.text = @"Category";
        
        return cell;
    }
    else if(self.saleSummary && self.isComparisonMode)
    {
        UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
        
        OPReportComparisonItemCell *cell = [[OPReportComparisonItemCell alloc] initWithFrame:CGRectMake(0, 10, self.tableView.frame.size.width, 40)];
        
        if(section==0)
            cell.titleLabel.text = @"Sale by Tender";
        else
            cell.titleLabel.text = @"Hourly Sale";
        cell.titleLabel.textAlignment=NSTextAlignmentLeft;
        
        NSString *firstDateTitle = nil;
        if([self.date1 compare:self.date2] == NSOrderedSame)
            firstDateTitle = [KSDateUtil getDayMonthYearString:self.date1];
        else
            firstDateTitle = [NSString stringWithFormat:@"%@-\n%@", [KSDateUtil getDayMonthYearString:self.date1], [KSDateUtil getDayMonthYearString:self.date2]];
        
        NSString *secondDateTitle = nil;
        if([self.compareDate1 compare:self.compareDate2] == NSOrderedSame)
            secondDateTitle = [KSDateUtil getDayMonthYearString:self.compareDate1];
        else
            secondDateTitle = [NSString stringWithFormat:@"%@-\n%@", [KSDateUtil getDayMonthYearString:self.compareDate1], [KSDateUtil getDayMonthYearString:self.compareDate2]];
        
        cell.totalAmountLabel1.text = secondDateTitle;
        cell.totalAmountLabel2.text = firstDateTitle;
        cell.totalAmountLabel1.font = [UIFont boldSystemFontOfSize:14.0];
        cell.totalAmountLabel2.font = [UIFont boldSystemFontOfSize:14.0];
        cell.frame=CGRectMake(0, 20, self.tableView.frame.size.width, 30);
        [secView addSubview:cell];
        return secView;
    }
    else if(self.saleSummary && self.isSaleSummaryMode)
    {
        OPReportComparisonItemCell *cell = [[OPReportComparisonItemCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        
        if(section==0)
        {
            cell.titleLabel.text = @"Sale by Tender";
            cell.totalAmountLabel1.text = @"Desc";
            cell.totalAmountLabel2.text = @"Amount";
        }
        else
        {
            cell.titleLabel.text = @"Hourly Sale";
            cell.totalAmountLabel1.text = @"Time";
            cell.totalAmountLabel2.text = @"Amount";
        }
        cell.titleLabel.textAlignment=NSTextAlignmentLeft;
        cell.totalAmountLabel1.textAlignment=NSTextAlignmentLeft;
        cell.totalAmountLabel1.font = [UIFont boldSystemFontOfSize:14.0];
        cell.totalAmountLabel2.font = [UIFont boldSystemFontOfSize:14.0];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(self.isItemSaleMode || self.isCategorySaleMode)
        {
            return 40;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(self.isItemSaleMode)
        {
            OPReportItemCell *cell = [[OPReportItemCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
            cell.titleLabel.text = @"TOTAL";
            cell.countField.text = [NSString stringWithFormat:@"%0.2f", self.saleSummary.itemCountTotals];
            cell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", self.saleSummary.itemTotals];
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.countField.font = [UIFont boldSystemFontOfSize:14];
            
            cell.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
            return cell;
        }
        else if(self.isCategorySaleMode)
        {
            OPReportItemCell *cell = [[OPReportItemCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
            cell.titleLabel.text = @"TOTAL";
            cell.countField.text = [NSString stringWithFormat:@"%0.2f", self.saleSummary.categoryCountTotals];
            cell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", self.saleSummary.categoryTotals];
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.countField.font = [UIFont boldSystemFontOfSize:14];
            cell.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.isSaleSummaryMode || self.isComparisonMode)
        return 2;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isSaleSummaryMode || self.isComparisonMode)
    {
        if(section==0)
            return self.saleSummary.summaryBreakDown.rows.count;
        else
            return 24;
    }
    else if(self.isItemSaleMode)
        return self.saleSummary.itemBreakDown.rows.count;
    else if(self.isCategorySaleMode)
        return self.saleSummary.categoryBreakDown.rows.count;
    else
        return 0;
    //return self.exList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell)
    {
        if(self.isComparisonMode)
            cell = [[OPReportComparisonItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        else
            cell = [[OPReportItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if(self.isSaleSummaryMode)
    {
        OPReportItemCell *cell_d = (OPReportItemCell *)cell;
        
        if(indexPath.section==0)
        {
            NSDictionary *dict = [self.saleSummary.summaryBreakDown.rows objectAtIndex:indexPath.row]; 
            NSString *key = dict.allKeys.firstObject;
            cell_d.titleLabel.text = key;
            cell_d.countField.text = @"";
            cell_d.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[dict valueForKey:key] floatValue]];
            if([cell_d.titleLabel.text hasPrefix:@"GROSS TOTAL"])
            {
                cell_d.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                cell_d.countField.font = [UIFont boldSystemFontOfSize:14];
                cell_d.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
            }
            else
            {
                cell_d.titleLabel.font = [UIFont systemFontOfSize:14];
                cell_d.countField.font = [UIFont systemFontOfSize:14];
                cell_d.totalAmountLabel.font = [UIFont systemFontOfSize:14];
            }
        }
        else
        { 
            NSString *key = [NSString stringWithFormat:@"%d", (int)indexPath.row+1];
            cell_d.titleLabel.text = [KSDateUtil chartTimeForTime:key];
            cell_d.countField.text = @"";
            cell_d.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[self.saleSummary.timeWiseReports valueForKey:key] floatValue]];
            if([cell_d.titleLabel.text hasPrefix:@"GROSS TOTAL"])
            {
                cell_d.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                cell_d.countField.font = [UIFont boldSystemFontOfSize:14];
                cell_d.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
            }
            else
            {
                cell_d.titleLabel.font = [UIFont systemFontOfSize:14];
                cell_d.countField.font = [UIFont systemFontOfSize:14];
                cell_d.totalAmountLabel.font = [UIFont systemFontOfSize:14];
            }
        }
    }
    else if(self.isComparisonMode)
    {
        OPReportComparisonItemCell *cell_d = (OPReportComparisonItemCell *)cell;
        
        if(indexPath.section==0)
        {
            NSDictionary *dict = [self.saleSummary.summaryBreakDown.rows objectAtIndex:indexPath.row];
            NSDictionary *dict2 = [self.saleSummary2.summaryBreakDown.rows objectAtIndex:indexPath.row];
            
            NSString *key = dict.allKeys.firstObject;
            cell_d.titleLabel.text = key;
            
            cell_d.totalAmountLabel1.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[dict2 valueForKey:key] floatValue]];
            cell_d.totalAmountLabel2.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[dict valueForKey:key] floatValue]];
            if([cell_d.titleLabel.text hasPrefix:@"GROSS TOTAL"])
            {
                cell_d.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont boldSystemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont boldSystemFontOfSize:14];
            }
            else
            {
                cell_d.titleLabel.font = [UIFont systemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont systemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont systemFontOfSize:14];
            }
        }
        else
        {
            NSString *key = [NSString stringWithFormat:@"%d", (int)indexPath.row+1];
            cell_d.titleLabel.text = [KSDateUtil chartTimeForTime:key];
            
            cell_d.totalAmountLabel1.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[self.saleSummary2.timeWiseReports valueForKey:key] floatValue]];
            cell_d.totalAmountLabel2.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[self.saleSummary.timeWiseReports valueForKey:key] floatValue]];
            if([cell_d.titleLabel.text hasPrefix:@"GROSS TOTAL"])
            {
                cell_d.titleLabel.font = [UIFont boldSystemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont boldSystemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont boldSystemFontOfSize:14];
            }
            else
            {
                cell_d.titleLabel.font = [UIFont systemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont systemFontOfSize:14];
                cell_d.totalAmountLabel1.font = [UIFont systemFontOfSize:14];
            }
        }
    }
    else if(self.isItemSaleMode || self.isCategorySaleMode)
    {
        OPReportItemCell *cell_d = (OPReportItemCell *)cell;
        OPCategoryItem *catItem = nil;
        if(self.isItemSaleMode)
            catItem = [self.saleSummary.itemBreakDown.rows objectAtIndex:indexPath.row];
        else
            catItem = [self.saleSummary.categoryBreakDown.rows objectAtIndex:indexPath.row];
        
        cell_d.titleLabel.text = catItem.name;
        cell_d.countField.text = [NSString stringWithFormat:@"%0.2f", catItem.qty];
        cell_d.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", catItem.amount];
        
        
        if([cell_d.titleLabel.text hasPrefix:@"TOTAL"])
        {
            cell_d.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell_d.countField.font = [UIFont boldSystemFontOfSize:14];
            cell_d.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        else
        {
            cell_d.titleLabel.font = [UIFont systemFontOfSize:14];
            cell_d.countField.font = [UIFont systemFontOfSize:14];
            cell_d.totalAmountLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectDate1:(NSDate *)date1 andDate2:(NSDate *)date2
{
    self.date1 = date1;
    self.date2 = date2;
    [self updateDateLabel];
//    self.parentController.date1=date1;
//    self.parentController.date2=date2;
    [self fetchReports];
}

#pragma mark - Remote Reports

- (void)fetchReports
{    
    [self startAnimating];
    
    if(self.saleSummary)
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self performSelector:@selector(loadReportLately) withObject:nil afterDelay:0.1];
}

- (void)loadReportLately
{
    [OPDataFetchHelper fetchSalesSummaryItemWiseFromDate:self.date1 toDate:self.date2 withExecutionBlock:^(BOOL success, Response *response){
        
        if(success)
        {
            [self performSelectorOnMainThread:@selector(didFetchReportsWithResponse:) withObject:response waitUntilDone:NO];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showErrorMessage) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)fetchLocalReportAndShow
{
}

- (void)didFetchReportsWithResponse:(Response *)response
{    
    [self stopAnimating];
    NSString *stmt = response.responseString;
    stmt = [stmt stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>" withString:@""];
    stmt = [stmt stringByReplacingOccurrencesOfString:@"<string xmlns=\"http://tempuri.org/\">" withString:@""];
    stmt = [stmt stringByReplacingOccurrencesOfString:@"</string>" withString:@""];
    NSDictionary *dict = [stmt JSONValue];
    BOOL didFoundSales = NO;
    if(dict){
        
        id val = [[dict valueForKey:@"ItemTransactions"] valueForKey:@"Transaction"];
        NSArray *statements = nil;
        if([val isKindOfClass:[NSArray class]])
            statements = val;
        else if([val isKindOfClass:[NSDictionary class]])
            statements = [NSArray arrayWithObject:val];
        
        if(statements.count){
            didFoundSales=YES;
            OPSaleSummary *sm = [[OPSaleSummary alloc] init];
            [sm parseFromRawItems:statements];
            self.saleSummary = sm;
            
            if(self.isComparisonMode)
            {
                [self fetchComparisonReports];
            }
            else
            {
                [self.tableView reloadData];
                self.tableView.tableHeaderView=nil;
            }
        }
    }
    
    if(!didFoundSales){
        
        self.saleSummary = nil;
        [self.tableView reloadData];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, self.tableView.frame.size.height)];
        label.text = @"No report is currently available for the selected date(s). Please pull down to refresh.";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont italicSystemFontOfSize:17];
        label.numberOfLines = 3;
        self.tableView.tableHeaderView=label;
    }
}


- (void)loadInWebViewTheHtmlString:(NSString *)htmlContent
{
    
}

- (void)startAnimating
{
    self.indicatorView = [LoadingIndicatorView showLoadingIndicatorInView:self.view withMessage:nil];
}

- (void)stopAnimating
{
    [LoadingIndicatorView removeLoadingIndicator:self.indicatorView];
    [self.refreshController endRefreshing];
}

- (void)showErrorMessage
{
    [self stopAnimating];
    NSString *title = [NSString stringWithFormat:@"Unable to Fetch Reports"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"An error occurred. Your request could not be completed at this time. Please try again later." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Try again", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self fetchReports];
    }
}

//report comparison
- (void)updateReportComparisonDates
{
    if([self.rangeType isEqualToString:@"Today"])
    {
        self.compareDate1 = [KSDateUtil getNextDayByCount:-1 fromDate:self.date1];
        self.compareDate2 = self.date1;
    }
    else if([self.rangeType isEqualToString:@"This Week"])
    {
        self.compareDate1 = [KSDateUtil getNextWeekByCount:-7 fromDate:self.date1];
        self.compareDate2 = [KSDateUtil getNextDayByCount:6 fromDate:self.compareDate1];
    }
    else if([self.rangeType isEqualToString:@"This Month"])
    {
        self.compareDate1 = [KSDateUtil getNextMonthByCount:-1 fromDate:self.date1];
        NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.compareDate1];
        self.compareDate2 = [KSDateUtil getNextDayByCount:days.length-1 fromDate:self.compareDate1];
    }
    else
    {
        int dayToReduce = (int)[KSDateUtil getDayDiffBetweenDate1:self.date1 andDate2:self.date2]+1;
        self.compareDate1 = [KSDateUtil getNextDayByCount:dayToReduce*-1 fromDate:self.date1];
        self.compareDate2 = [KSDateUtil getNextDayByCount:dayToReduce*-1 fromDate:self.date2];
    }
}
- (void)fetchComparisonReports
{
    [self startAnimating];
    [self updateReportComparisonDates];
    [self performSelector:@selector(loadComparisonReportLately) withObject:nil afterDelay:0.1];
}

- (void)loadComparisonReportLately
{
    [OPDataFetchHelper fetchSalesSummaryItemWiseFromDate:self.compareDate1 toDate:self.compareDate2 withExecutionBlock:^(BOOL success, Response *response){
        
        if(success)
        {
            [self performSelectorOnMainThread:@selector(didFetchComparisonReportsWithResponse:) withObject:response waitUntilDone:NO];
        }
        else
        {
            [self performSelectorOnMainThread:@selector(showErrorMessage2) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)didFetchComparisonReportsWithResponse:(Response *)response
{    
    [self stopAnimating];
    NSString *stmt = response.responseString;
    stmt = [stmt stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>" withString:@""];
    stmt = [stmt stringByReplacingOccurrencesOfString:@"<string xmlns=\"http://tempuri.org/\">" withString:@""];
    stmt = [stmt stringByReplacingOccurrencesOfString:@"</string>" withString:@""];
    NSDictionary *dict = [stmt JSONValue];
    BOOL didFoundSales = NO;
    if(dict){
        
        id val = [[dict valueForKey:@"ItemTransactions"] valueForKey:@"Transaction"];
        NSArray *statements = nil;
        if([val isKindOfClass:[NSArray class]])
            statements = val;
        else if([val isKindOfClass:[NSDictionary class]])
            statements = [NSArray arrayWithObject:val];
        
        if(statements.count){
            didFoundSales=YES;
            OPSaleSummary *sm = [[OPSaleSummary alloc] init];
            [sm parseFromRawItems:statements];
            self.saleSummary2 = sm;
            [self.tableView reloadData];
            self.tableView.tableHeaderView=nil;
        }
    }
    
    if(!didFoundSales){
        
        self.saleSummary2 = nil;
    }
}

- (void)showErrorMessage2
{
    [self stopAnimating];
}
@end
