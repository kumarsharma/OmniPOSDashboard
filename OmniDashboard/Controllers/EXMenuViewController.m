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
#import "ODSettingsTableViewController.h"
#import "CompanyInfo.h"
#import "OPCategoryItem.h"
#import "OPReportComparisonCell.h"
#import "UnderLineLabel.h"

@interface EXMenuViewController ()
{
    BOOL isFirstTimeLoaded;
}

@property (nonatomic, strong) UIRefreshControl *refreshController;

@end

#define kExListen @"View Report"
#define kExTune @"eXTunes"

@implementation EXMenuViewController
@synthesize exList;
@synthesize indicatorView;
@synthesize date1, date2;
@synthesize saleSummary, saleSummary2;
@synthesize middleBarItem;
@synthesize rangeType;
@synthesize refreshController;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewTitleLabel.text = [EXAppDelegate sharedAppDelegate].selectedLocationName;
    isFirstTimeLoaded = NO;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarView.frame.size.height+self.topBarView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-(self.topBarView.frame.size.height+self.topBarView.frame.origin.y)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *prevDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(prevDayBtnAction)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *dateBtn = [[UIBarButtonItem alloc] initWithTitle:[KSDateUtil getDayMonthYearString:[NSDate date]] style:UIBarButtonItemStyleDone target:self action:@selector(dateBtnAction)];
    
    self.middleBarItem = dateBtn;
    self.middleBarItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *space2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *nextDayBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right-arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(nextDatBtnAction)];
    self.toolbarItems = [NSArray arrayWithObjects:prevDayBtn, space, dateBtn, space2, nextDayBtn, nil];
    self.date1 = [NSDate date];
    self.date2 = self.date1;
    
    EXAppDelegate *app = [EXAppDelegate sharedAppDelegate];
    if(app.company.allLocations.count<=1)
    {
//        UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"avatar"] style:UIBarButtonItemStyleDone target:self action:@selector(settingsAction)];
//        self.navigationItem.rightBarButtonItem = settingsBtn;
    }   
    [self fetchReports];
    
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
    RangePickerViewController *vc = [[RangePickerViewController alloc] initWithDate1:self.date1 Date2:self.date2];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.barStyle = UIBarStyleBlackOpaque;
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
        return 300;
    else if(indexPath.section==1)
        return 370;
    else if(indexPath.section==2 || indexPath.section==3)
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
            return @"Sale Comparison";
        else if(section==2)
            return @"Items";
        else if(section==3)
            return @"Categories";
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section == 2 || section == 3)
        {
            return 60;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section == 2 || section == 3)
        {
            UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)];
            secView.backgroundColor = [UIColor clearColor];
            
            UnderLineLabel *label = [[UnderLineLabel alloc] initWithFrame:CGRectMake(5, 10, self.tableView.frame.size.width-10, 19)];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont italicSystemFontOfSize:17];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor blackColor];

            OPReportItemCell *cell = [[OPReportItemCell alloc] initWithFrame:CGRectMake(0, 30, self.tableView.frame.size.width, 30)];
            cell.titleLabel.text = @"Item";
            cell.countField.text = @"Qty";
            cell.totalAmountLabel.text = @"Amount";
            if(section == 2)
            {
                label.text = @"Item Sales  ▶";
                cell.titleLabel.text = @"Item";
            }
            else
            {
                label.text = @"Category Sales  ▶";
                cell.titleLabel.text = @"Category";
            }

            cell.frame = CGRectMake(0, 30, self.tableView.frame.size.width, 30);
            [secView addSubview:label];
            [secView addSubview:cell];
            
            UITapGestureRecognizer *taptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnHeaderView:)];
            secView.tag = section;
            [secView addGestureRecognizer:taptap];
            return secView;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(self.saleSummary)
    {
        if(section == 2 || section == 3)
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
        if(section == 2)
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
        else if(section==3)
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
//    return 1;
    return 4;
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
    {
        if(self.saleSummary2)
            return 1;
        else
            return 0;
    }
    else if(section==2)
        return self.saleSummary.itemBreakDown.rows.count;
    else if(section==3)
        return self.saleSummary.categoryBreakDown.rows.count;
    else
        return 0;
    //return self.exList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    static NSString *CellIdentifier3 = @"Cell3";
    UITableViewCell *cell = nil;
    if(indexPath.section == 0)
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
    else if(indexPath.section==1)
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(nil == cell)
    {
        if(indexPath.section==0)    
            cell = [[OPReportSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        else if(indexPath.section==1)    
            cell = [[OPReportComparisonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
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

        if(!rcell.saleSummary || ![self.saleSummary isEqual:rcell.saleSummary])
        {
            rcell.saleSummary = self.saleSummary;
            [rcell reloadViews];
        }
        else
        {
            [rcell.barChart removeChart];
            [rcell.barChart addChart];
        }
    }
    else if(indexPath.section == 1)
    {
        OPReportComparisonCell *rcell = (OPReportComparisonCell *)cell;
        //cell.textLabel.text = [NSString stringWithFormat:@"Gross Sale: %@%0.2f", @"$", self.saleSummary.grossSale];
        rcell.grossSaleLabel.text = [NSString stringWithFormat:@"Gross Sales\n\n%@%0.2f", @"$", self.saleSummary.grossSale];
        rcell.salesLabel.text = [NSString stringWithFormat:@"Sales\n\n%d", self.saleSummary.totalNoOfSale];
        rcell.avgSalesLabel.text = [NSString stringWithFormat:@"Average Sale\n\n%@%0.2f", @"$", self.saleSummary.averageSale];
        
        rcell.grossSaleLabel2.text = [NSString stringWithFormat:@"%@%0.2f", @"$", self.saleSummary2.grossSale];
        rcell.salesLabel2.text = [NSString stringWithFormat:@"%d", self.saleSummary2.totalNoOfSale];
        rcell.avgSalesLabel2.text = [NSString stringWithFormat:@"%@%0.2f", @"$", self.saleSummary2.averageSale];
        rcell.saleSummary = self.saleSummary;
        rcell.saleSummary2 = self.saleSummary2;
        [rcell reloadViews];
        
        NSString *firstDateTitle = nil;
        if([self.date1 compare:self.date2] == NSOrderedSame)
            firstDateTitle = [KSDateUtil getDayMonthYearString:self.date1];
        else
            firstDateTitle = [NSString stringWithFormat:@"%@-%@", [KSDateUtil getDayMonthYearString:self.date1], [KSDateUtil getDayMonthYearString:self.date2]];
        
        NSString *secondDateTitle = nil;
        if([self.compareDate1 compare:self.compareDate2] == NSOrderedSame)
            secondDateTitle = [KSDateUtil getDayMonthYearString:self.compareDate1];
        else
            secondDateTitle = [NSString stringWithFormat:@"%@-%@", [KSDateUtil getDayMonthYearString:self.compareDate1], [KSDateUtil getDayMonthYearString:self.compareDate2]];
        
        rcell.titleLabel1.text = firstDateTitle;
        rcell.titleLabel2.text = secondDateTitle;

        /*
        if(!rcell.saleSummary || ![self.saleSummary isEqual:rcell.saleSummary])
        {
            rcell.saleSummary = self.saleSummary;
            rcell.saleSummary2 = self.saleSummary2;
            [rcell reloadViews];
        }
        else
        {
            [rcell.barChart removeChart];
            [rcell.barChart addChart];
        }*/
    }
    else if(indexPath.section==2 || indexPath.section==3)
    {
        OPReportItemCell *rcell = (OPReportItemCell *)cell;
        OPCategoryItem *catItem = nil;
        if(indexPath.section == 2)
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

- (void)didTapOnHeaderView:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    OPFurtherReportViewController *frvc = [[OPFurtherReportViewController alloc] init];
    if(tap.view.tag == 3)
    {
        frvc.isSaleSummaryMode = NO;
        frvc.isItemSaleMode = NO;
        frvc.isCategorySaleMode = YES;
    }
    else if(tap.view.tag == 2)
    {
        frvc.isSaleSummaryMode = NO;
        frvc.isItemSaleMode = YES;
        frvc.isCategorySaleMode = NO;
    }
    frvc.parentController = self;
    [self.navigationController pushViewController:frvc animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    OPFurtherReportViewController *frvc = [[OPFurtherReportViewController alloc] init];
    if(indexPath.section==0)
    {
        frvc.isSaleSummaryMode = YES;
        frvc.isItemSaleMode = NO;
        frvc.isCategorySaleMode = NO;
    }
    else if(indexPath.section==1)
    {
        frvc.isSaleSummaryMode = NO;
        frvc.isItemSaleMode = NO;
        frvc.isCategorySaleMode = NO;
        frvc.isComparisonMode=YES;
    }
    else if(indexPath.section == 2)
    {
        frvc.isSaleSummaryMode = NO;
        frvc.isItemSaleMode = YES;
        frvc.isCategorySaleMode = NO;
    }
    else if(indexPath.section == 3)
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
    self.tableView.tableHeaderView=nil;
    if(self.saleSummary && [self.tableView numberOfRowsInSection:0]>0)
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
//            [self.tableView reloadData];
//            self.tableView.tableHeaderView=nil;
            [self fetchComparisonReports];
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

- (void)reloadTableForFirstTime
{
    [self.tableView reloadData];
}

- (void)loadInWebViewTheHtmlString:(NSString *)htmlContent
{
   
}

- (void)startAnimating
{
    self.indicatorView = [LoadingIndicatorView showLoadingIndicatorInView:self.view withMessage:nil];
    [self.refreshController endRefreshing];
}

- (void)stopAnimating
{
    [LoadingIndicatorView removeLoadingIndicator:self.indicatorView];
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
            if(!isFirstTimeLoaded)
            {
                isFirstTimeLoaded = YES;
                [self performSelector:@selector(reloadTableForFirstTime) withObject:nil afterDelay:1];
            }
        }
        else{
            self.saleSummary2 = nil;
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
