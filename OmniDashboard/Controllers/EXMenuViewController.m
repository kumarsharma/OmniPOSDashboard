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

@interface EXMenuViewController ()

@end

#define kExListen @"View Report"
#define kExTune @"eXTunes"

@implementation EXMenuViewController
@synthesize exList;
@synthesize indicatorView;
@synthesize date1, date2;
@synthesize saleSummary;
@synthesize middleBarItem;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [EXAppDelegate sharedAppDelegate].selectedLocationName;
    
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
    self.date2 = self.date1;
}

- (void)dateBtnAction
{
    RangePickerViewController *vc = [[RangePickerViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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
    if([self.date1 compare:self.date2] == NSOrderedSame)
    {
        [self.middleBarItem setTitle:[KSDateUtil getYYYyMmDdDateFormat:self.date1]];
    }
    else
    {
        [self.middleBarItem setTitle:[NSString stringWithFormat:@"%@-%@", [KSDateUtil getYYYyMmDdDateFormat:self.date1], [KSDateUtil getYYYyMmDdDateFormat:self.date2]]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self fetchReports];
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
    if(section==0)
        return @"Sale Summary";
    else if(section==1)
        return @"Items";
    else if(section==2)
        return @"Categories";
    else
        return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 1;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
        return 1;
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
        NSDictionary *dict = nil;
        if(indexPath.section == 1)
            dict = [self.saleSummary.itemBreakDown.rows objectAtIndex:indexPath.row];
        else
            dict = [self.saleSummary.categoryBreakDown.rows objectAtIndex:indexPath.row];
        
        NSString *key = dict.allKeys.firstObject;
        NSArray *texts = [key componentsSeparatedByString:@"X"];
        rcell.titleLabel.text = [texts objectAtIndex:0];
        rcell.countField.text = [texts objectAtIndex:1];
        rcell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[dict valueForKey:key] floatValue]];
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
    if(dict){
        
        id val = [[dict valueForKey:@"ItemTransactions"] valueForKey:@"Transaction"];
        
        NSArray *statements = nil;
        if([val isKindOfClass:[NSArray class]])
            statements = val;
        else if([val isKindOfClass:[NSDictionary class]])
            statements = [NSArray arrayWithObject:val];
        
        if(statements.count){
            
            OPSaleSummary *sm = [[OPSaleSummary alloc] init];
            [sm parseFromRawItems:statements];
            self.saleSummary = sm;
            [self.tableView reloadData];
        }else{
            
            OPSaleSummary *sm = [[OPSaleSummary alloc] init];
            [sm parseFromRawItems:[NSArray array]];
            self.saleSummary = sm;
            [self.tableView reloadData];
        }
    }else{
        
    }
}


- (void)loadInWebViewTheHtmlString:(NSString *)htmlContent
{
   
}

- (void)startAnimating
{
    if(nil == self.indicatorView)
    {
        DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotate tintColor:[UIColor blackColor]];
        CGFloat width = 400;
        CGFloat height = 400;
        
        activityIndicatorView.frame = CGRectMake(200, 200, width, height);
        
        [self.view addSubview:activityIndicatorView];
        self.indicatorView = activityIndicatorView;
    }
    self.indicatorView.center = self.view.center;
    [self.indicatorView startAnimating];
    self.navigationController.view.userInteractionEnabled = NO;
}

- (void)stopAnimating
{
    self.navigationController.view.userInteractionEnabled = YES;
    [self.indicatorView stopAnimating];
}

- (void)showErrorMessage
{
    [self stopAnimating];
    NSString *title = [NSString stringWithFormat:@"Error in generating reports!"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

@end
