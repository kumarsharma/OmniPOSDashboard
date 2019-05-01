//
//  EXListViewController.m
//  ExTunes
//
//  Created by Kumar Sharma on 14/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "EXMenuViewController.h"
#import "RestaurantInfo.h"
#import "KSConstants.h"
#import "KSDateUtil.h"
#import "OPDataFetchHelper.h"
#import "LoadingIndicatorView.h"
#import "NSString+SBJSON.h"
#import "OPReportItemCell.h"
#import "OPReportSummaryCell.h"
#import "OPFurtherReportViewController.h"
#import "DSBarChart.h"
#import "ODSettingsTableViewController.h"
#import "CompanyInfo.h"
#import "OPCategoryItem.h"

@interface EXMenuViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshController;

@end

#define kExListen @"View Report"
#define kExTune @"eXTunes"

@implementation EXMenuViewController
@synthesize exList;
@synthesize indicatorView;
@synthesize date1, date2;
@synthesize saleSummary;
@synthesize middleBarItem;
@synthesize rangeType;
@synthesize refreshController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [EXAppDelegate sharedAppDelegate].selectedLocationName;
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
//    self.navigationController.toolbar.tintColor = [UIColor whiteColor];
    UIBarButtonItem *prevDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(prevDayBtnAction)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *dateBtn = [[UIBarButtonItem alloc] initWithTitle:[KSDateUtil getDayMonthYearString:[NSDate date]] style:UIBarButtonItemStyleDone target:self action:@selector(dateBtnAction)];
    self.middleBarItem = dateBtn;
    self.middleBarItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
     UIBarButtonItem *nextDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(nextDatBtnAction)];
    self.toolbarItems = [NSArray arrayWithObjects:prevDayBtn, space, dateBtn, space2, nextDayBtn, nil];
    self.date1 = [NSDate date];
    self.date2 = self.date1;
    
    EXAppDelegate *app = [EXAppDelegate sharedAppDelegate];
    if(app.company.allLocations.count<=1)
    {
        UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user4"] style:UIBarButtonItemStyleDone target:self action:@selector(settingsAction)];
        self.navigationItem.rightBarButtonItem = settingsBtn;
    }   
    [self fetchReports];
    
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshController];
}

#pragma mark - Handle Refresh Method

-(void)handleRefresh : (id)sender
{
    [self fetchReports];
    [self.refreshController endRefreshing];
}

- (void)settingsAction
{
    ODSettingsTableViewController *setVc = [[ODSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:setVc animated:YES];
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
        self.date1 = [KSDateUtil getNextWeekByCount:1 fromDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:6 fromDate:self.date1];
    }
    else if([self.rangeType isEqualToString:@"This Month"])
    {
        self.date1 = [KSDateUtil getNextMonthByCount:1 fromDate:self.date1];
        NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self.date1];
        self.date2 = [KSDateUtil getNextDayByCount:days.length fromDate:self.date1];
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
        self.date1 = [KSDateUtil getNextWeekByCount:-1 fromDate:self.date1];
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
    RangePickerViewController *vc = [[RangePickerViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self fetchReports];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        return 280;
    else if(indexPath.section==1 || indexPath.section==2)
        return 35;
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section==0)
            return @"Sale Summary";
        else if(section==1)
            return @"Items";
        else if(section==2)
            return @"Categories";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section == 1 || section == 2)
        {
            return 30;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section == 1 || section == 2)
        {
            OPReportItemCell *cell = [[OPReportItemCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
            cell.titleLabel.text = @"Item";
            cell.countField.text = @"Qty";
            cell.totalAmountLabel.text = @"Amount";
            if(section == 1)
                cell.titleLabel.text = @"Item";
            else
                cell.titleLabel.text = @"Category";
            
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section == 1 || section == 2)
        {
            return 20;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section == 1)
        {
            UIView *vv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
            OPReportItemCell *cell = [[OPReportItemCell alloc] initWithFrame:CGRectMake(0, -10, self.tableView.frame.size.width, 20)];
            cell.titleLabel.text = @"TOTAL";
            cell.countField.text = [NSString stringWithFormat:@"%0.2f", self.saleSummary.itemCountTotals];
            cell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", self.saleSummary.itemTotals];
            cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            cell.countField.font = [UIFont boldSystemFontOfSize:14];
            cell.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
            [vv addSubview:cell];
            return vv;
        }
        else
        {
            OPReportItemCell *cell = [[OPReportItemCell alloc] initWithFrame:CGRectMake(0, -10, self.tableView.frame.size.width, 20)];
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
//    return 1;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        if(self.saleSummary)
            return 1;
        else
            return 0;
    }
    else if(section==1)
        return self.saleSummary.itemBreakDown.rows.count;
    else if(section==2)
        return self.saleSummary.categoryBreakDown.rows.count;
    else
        return 0;
    //return self.exList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    UITableViewCell *cell = nil;
    if(indexPath.section == 0)
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell)
    {
        if(indexPath.section==0)    
            cell = [[OPReportSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        else
            cell = [[OPReportItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
//    cell.textLabel.text = [self.exList objectAtIndex:indexPath.row];
//    cell.imageView.image = [UIImage imageNamed:@"report_60x60"];
    if(indexPath.section == 0)
    {
        OPReportSummaryCell *rcell = (OPReportSummaryCell *)cell;
        //cell.textLabel.text = [NSString stringWithFormat:@"Gross Sale: %@%0.2f", @"$", self.saleSummary.grossSale];
        rcell.grossSaleLabel.text = [NSString stringWithFormat:@"%@%0.2f\nGross Sales", @"$", self.saleSummary.grossSale];
        rcell.salesLabel.text = [NSString stringWithFormat:@"%d\nSales", self.saleSummary.totalNoOfSale];
        rcell.avgSalesLabel.text = [NSString stringWithFormat:@"%@%0.2f\nAverage Sale", @"$", self.saleSummary.averageSale];        
        rcell.saleSummary = self.saleSummary;
        [rcell reloadViews];
    }
    else if(indexPath.section==1 || indexPath.section==2)
    {
        OPReportItemCell *rcell = (OPReportItemCell *)cell;
        OPCategoryItem *catItem = nil;
        if(indexPath.section == 1)
            catItem = [self.saleSummary.itemBreakDown.rows objectAtIndex:indexPath.row];
        else
            catItem = [self.saleSummary.categoryBreakDown.rows objectAtIndex:indexPath.row];
        
        rcell.titleLabel.text = catItem.name;
        rcell.countField.text = [NSString stringWithFormat:@"%0.2f", catItem.qty];
        rcell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", catItem.amount];
        
        if([rcell.titleLabel.text hasPrefix:@"TOTAL"])
        {
            rcell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            rcell.countField.font = [UIFont boldSystemFontOfSize:14];
            rcell.totalAmountLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        else
        {
            rcell.titleLabel.font = [UIFont systemFontOfSize:14];
            rcell.countField.font = [UIFont systemFontOfSize:14];
            rcell.totalAmountLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    OPFurtherReportViewController *frvc = [[OPFurtherReportViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if(indexPath.section==0)
    {
        frvc.isSaleSummaryMode = YES;
        frvc.isItemSaleMode = NO;
        frvc.isCategorySaleMode = NO;
    }
    else if(indexPath.section == 1)
    {
        frvc.isSaleSummaryMode = NO;
        frvc.isItemSaleMode = YES;
        frvc.isCategorySaleMode = NO;
    }
    else if(indexPath.section == 2)
    {
        frvc.isSaleSummaryMode = NO;
        frvc.isItemSaleMode = NO;
        frvc.isCategorySaleMode = YES;
    }
    frvc.parentController = self;
    [self.navigationController pushViewController:frvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectDate1:(NSDate *)date1 andDate2:(NSDate *)date2
{
    self.date1 = date1;
    self.date2 = date2;
    [self updateDateLabel];
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
