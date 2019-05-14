
//
//  OPReportSummaryCell.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPReportSummaryCell.h"
#import "OPSaleSummary.h"
#import "KSDateUtil.h"

@implementation OPReportSummaryCell
@synthesize grossSaleLabel, salesLabel, avgSalesLabel, reportTitleLabel;
@synthesize saleSummary;
@synthesize webview;
@synthesize chartView;
@synthesize barChart;
@synthesize showOnlyValuedBars;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews
{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_iphone"]];
//    self.contentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//    self.contentView.layer.borderWidth = 1.0;
    
    NSInteger kGap = 3;
    float labelHeight = 60;
    
    self.reportTitleLabel = [self  createUnderlinedLabelWithRect:CGRectMake(5, 2, self.frame.size.width-10, 19) text:@"" bgColor:[UIColor clearColor] font:[UIFont italicSystemFontOfSize:17.0]];
    self.reportTitleLabel.text = @"Sale Summary  ▶";
    self.reportTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    float nextY = 19;
    self.grossSaleLabel = [self  createLabelWithRect:CGRectMake(5, nextY, self.frame.size.width/3, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.grossSaleLabel.numberOfLines = 2;
    self.grossSaleLabel.adjustsFontSizeToFitWidth = YES;
    self.grossSaleLabel.textAlignment = NSTextAlignmentLeft;
    
    float posX = self.grossSaleLabel.frame.origin.x + self.grossSaleLabel.frame.size.width+kGap;
    self.salesLabel = [self  createLabelWithRect:CGRectMake(posX, nextY, self.frame.size.width/3, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.salesLabel.textAlignment = NSTextAlignmentCenter;
    self.salesLabel.adjustsFontSizeToFitWidth = YES;
    self.salesLabel.numberOfLines=2;
    posX = self.salesLabel.frame.origin.x + self.salesLabel.frame.size.width+kGap;
    
    self.avgSalesLabel = [self  createLabelWithRect:CGRectMake(posX, nextY, (self.frame.size.width/3)-15, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.avgSalesLabel.adjustsFontSizeToFitWidth = YES;
    self.avgSalesLabel.textAlignment = NSTextAlignmentRight;
    self.avgSalesLabel.numberOfLines=2;
    
    [self.contentView addSubview:self.reportTitleLabel];
    [self.contentView addSubview:self.grossSaleLabel];
    [self.contentView addSubview:self.salesLabel];
    [self.contentView addSubview:self.avgSalesLabel];

    self.chartView = [[UIView alloc] initWithFrame:CGRectMake(0, labelHeight+5, self.frame.size.width, 210)];        
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.chartView.frame.size.width, 200)];
    [webview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.chartView addSubview:webview];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(webview);
    [self.chartView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webview]|" options:0 metrics:nil views:viewsDictionary]];
    [self.chartView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webview]|" options:0 metrics:nil views:viewsDictionary]];
    webview.scrollView.scrollEnabled = YES;
    webview.scrollView.showsHorizontalScrollIndicator = YES;
    self.webview = webview;
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/cw.html"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
    [self.contentView addSubview:self.chartView];
    
}

- (void)reloadViews
{
//    NSArray* labels = [NSMutableArray arrayWithArray:@[@"Cash",@"Card",@"Voucher",@"On A/c", @"Others"]];
    NSMutableArray* datasets = [NSMutableArray array];
    
    /*
    for(NSInteger i = 1; i <= 1; i++) {
        CWBarDataSet* ds = nil;
        
        if(i==1)
            ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalCash),@(self.saleSummary.totalCard),@(self.saleSummary.totalVoucher),@(self.saleSummary.totalOnAccount),@(self.saleSummary.totalMix)]];
        ds.label = [NSString stringWithFormat:@"Label %ld",i];
        CWColor* c1 = [[CWColors sharedColors] pickColor];
        CWColor* c2 = [c1 colorWithAlphaComponent:1.0f];
        ds.fillColor = c2;
        ds.strokeColor = c1;
        [datasets addObject:ds];
    }*/

    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:24];
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:24];
    if(self.showOnlyValuedBars)
    {
        NSArray *valuedTimes = self.saleSummary.timeWiseReports.allKeys;
        for(NSString *time in valuedTimes)
        {
            [labels addObject:[KSDateUtil chartTimeForTime:time]];
            [data addObject:[self.saleSummary.timeWiseReports valueForKey:time]];
        }
        
        for(NSInteger i = 1; i <= 1; i++) {
            
            CWBarDataSet* ds = nil;
            ds = [[CWBarDataSet alloc] initWithData:data];
            ds.label = [NSString stringWithFormat:@"Label %ld",i];
            CWColor* c1 = [[CWColors sharedColors] pickColor];
            CWColor* c2 = [c1 colorWithAlphaComponent:1.0f];
            ds.fillColor = c2;
            ds.strokeColor = c1;
            [datasets addObject:ds];
        }     
    }
    else
    {
        labels = [NSMutableArray arrayWithArray:@[@"1-2 am",@"2-3 am",@"3-4 am",@"4-5 am", @"5-6 am",@"6-7 am",@"7-8 am",@"8-9 am",@"9-10 am", @"10-11 am", @"11-12 am",@"12-1 pm",@"1-2 pm",@"2-3 pm", @"3-4 pm",@"4-5 pm",@"5-6 pm",@"6-7 pm",@"7-8 pm", @"8-9 pm",@"9-10 pm",@"10-11 pm",@"11-12 pm",@"12-1 am"]];
        
        for(NSInteger i = 1; i <= 1; i++) {
            CWBarDataSet* ds = nil;
            
                ds = [[CWBarDataSet alloc] initWithData:@[@([[self.saleSummary.timeWiseReports valueForKey:@"1"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"2"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"3"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"4"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"5"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"6"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"7"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"8"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"9"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"10"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"11"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"12"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"13"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"14"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"15"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"16"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"17"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"18"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"19"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"20"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"21"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"22"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"23"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"24"] floatValue])]];
            
            ds.label = [NSString stringWithFormat:@"Label %ld",i];
            CWColor* c1 = [[CWColors sharedColors] pickColor];
            CWColor* c2 = [c1 colorWithAlphaComponent:1.0f];
            ds.fillColor = c2;
            ds.strokeColor = c1;
            [datasets addObject:ds];
        }     
    }
    
    CWBarChartData* bcd = [[CWBarChartData alloc] initWithLabels:labels andDataSet:datasets];
    CWBarChart* bc = [[CWBarChart alloc] initWithWebView:self.webview name:@"BarChart1" width:450 height:180 data:bcd options:nil];
    if(self.barChart)
        [self.barChart removeChart];
    self.barChart = bc;
    [bc addChart];
}

- (UILabel *)createLabelWithRect:(CGRect)rect text:(NSString *)text bgColor:(UIColor *)color font:(UIFont*)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.text = text;
    
    return label;
}

- (UnderLineLabel *)createUnderlinedLabelWithRect:(CGRect)rect text:(NSString *)text bgColor:(UIColor *)color font:(UIFont*)font
{
    UnderLineLabel *label = [[UnderLineLabel alloc] initWithFrame:rect];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.text = text;
    
    return label;
}

- (NSInteger) random:(NSInteger) max {
    return (NSInteger)arc4random_uniform((u_int32_t)max);
}

@end
