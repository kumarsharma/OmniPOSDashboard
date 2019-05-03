//
//  OPFurtherReportViewController.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPFurtherReportViewController.h"
#import "KSDateUtil.h"
#import "OPReportItemCell.h"
#import "OPDataFetchHelper.h"
#import "NSString+SBJSON.h"
#import "OPCategoryItem.h"

@interface OPFurtherReportViewController ()
@property (nonatomic, strong) UIRefreshControl *refreshController;

@end

@implementation OPFurtherReportViewController
@synthesize isSaleSummaryMode, isItemSaleMode, isCategorySaleMode;
@synthesize parentController;
@synthesize indicatorView;
@synthesize date1, date2;
@synthesize saleSummary;
@synthesize middleBarItem;
@synthesize rangeType;
@synthesize refreshController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isSaleSummaryMode)
        self.title = @"Sale Summary";
    else if(isItemSaleMode)
        self.title = @"Item Sales";
    else if(isCategorySaleMode)
        self.title = @"Category Sales";
    
    self.date1 = self.parentController.date1;
    self.date2=self.parentController.date2;
    self.saleSummary = self.parentController.saleSummary;
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    //    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *prevDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left"] style:UIBarButtonItemStyleDone target:self action:@selector(prevDayBtnAction)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *dateBtn = [[UIBarButtonItem alloc] initWithTitle:[KSDateUtil getDayMonthYearString:[NSDate date]] style:UIBarButtonItemStyleDone target:self action:@selector(dateBtnAction)];
    self.middleBarItem = dateBtn;
    self.middleBarItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *space4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *nextDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_right"] style:UIBarButtonItemStyleDone target:self action:@selector(nextDatBtnAction)];
    self.toolbarItems = [NSArray arrayWithObjects:prevDayBtn, space, space2, dateBtn, space3, space4, nextDayBtn, nil];
    
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
                self.date2 = [NSDate date];
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
    self.date1 = [KSDateUtil getNextDayByCount:1 fromDate:self.date1];
    self.date2 = [KSDateUtil getNextDayByCount:1 fromDate:self.date2];
    [self fetchReports];
    [self updateDateLabel];
}

- (void)prevDayBtnAction
{
    self.date1 = [KSDateUtil getNextDayByCount:-1 fromDate:self.date1];
    self.date2 = [KSDateUtil getNextDayByCount:-1 fromDate:self.date2];
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
    RangePickerViewController *vc = [[RangePickerViewController alloc] init];
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
    return 35;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary && (self.isItemSaleMode || self.isCategorySaleMode))
    {
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.isSaleSummaryMode)
        return self.saleSummary.summaryBreakDown.rows.count;
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
    OPReportItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell)
    {
        cell = [[OPReportItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    if(self.isSaleSummaryMode)
    {
        NSDictionary *dict = [self.saleSummary.summaryBreakDown.rows objectAtIndex:indexPath.row];
        
        NSString *key = dict.allKeys.firstObject;
        cell.titleLabel.text = key;
        cell.countField.text = @"";
        cell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[dict valueForKey:key] floatValue]];
        if([cell.titleLabel.text hasPrefix:@"GROSS TOTAL"])
        {
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.countField.font = [UIFont boldSystemFontOfSize:14];
            cell.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        else
        {
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.countField.font = [UIFont systemFontOfSize:14];
            cell.totalAmountLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    else if(self.isItemSaleMode || self.isCategorySaleMode)
    {
        OPCategoryItem *catItem = nil;
        if(self.isItemSaleMode)
            catItem = [self.saleSummary.itemBreakDown.rows objectAtIndex:indexPath.row];
        else
            catItem = [self.saleSummary.categoryBreakDown.rows objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = catItem.name;
        cell.countField.text = [NSString stringWithFormat:@"%0.2f", catItem.qty];
        cell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", catItem.amount];
        
        
        if([cell.titleLabel.text hasPrefix:@"TOTAL"])
        {
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.countField.font = [UIFont boldSystemFontOfSize:14];
            cell.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        else
        {
            cell.titleLabel.font = [UIFont systemFontOfSize:14];
            cell.countField.font = [UIFont systemFontOfSize:14];
            cell.totalAmountLabel.font = [UIFont systemFontOfSize:14];
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
            [self.tableView reloadData];
            self.tableView.tableHeaderView=nil;
        }
    }
    
    if(!didFoundSales){
        
        self.saleSummary = nil;
        [self.tableView reloadData];
        UILabel *label = [[UILabel alloc] initWithFrame:self.tableView.frame];
        label.text = @"No Sales!";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont italicSystemFontOfSize:17];
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
}

- (void)showErrorMessage
{
    [self stopAnimating];
    NSString *title = [NSString stringWithFormat:@"Error in generating reports!"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
