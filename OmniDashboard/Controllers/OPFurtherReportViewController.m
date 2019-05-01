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

@interface OPFurtherReportViewController ()

@end

@implementation OPFurtherReportViewController
@synthesize isSaleSummaryMode, isItemSaleMode, isCategorySaleMode;
@synthesize parentController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isSaleSummaryMode)
        self.title = @"Sale Summary";
    else if(isItemSaleMode)
        self.title = @"Item Sales";
    else if(isCategorySaleMode)
        self.title = @"Category Sales";
    
    self.saleSummary = self.parentController.saleSummary;
    
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


- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
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
    }
    else if(self.isItemSaleMode || self.isCategorySaleMode)
    {
        NSDictionary *dict = nil;
        if(self.isItemSaleMode)
            dict = [self.saleSummary.itemBreakDown.rows objectAtIndex:indexPath.row];
        else
            dict = [self.saleSummary.categoryBreakDown.rows objectAtIndex:indexPath.row];
        
        NSString *key = dict.allKeys.firstObject;
        NSArray *texts = [key componentsSeparatedByString:@"X"];
        cell.titleLabel.text = [texts objectAtIndex:0];
        cell.countField.text = [texts objectAtIndex:1];
        cell.totalAmountLabel.text = [NSString stringWithFormat:@"%@%0.2f", @"$", [[dict valueForKey:key] floatValue]];
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
