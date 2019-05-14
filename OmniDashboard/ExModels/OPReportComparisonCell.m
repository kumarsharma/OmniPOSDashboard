//
//  OPReportComparisonCell.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 06/05/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPReportComparisonCell.h"
#import "OPSaleSummary.h"
#import "CWColors.h"
#import "KSDateUtil.h"

@implementation OPReportComparisonCell
@synthesize grossSaleLabel, salesLabel, avgSalesLabel;
@synthesize grossSaleLabel2, salesLabel2, avgSalesLabel2, titleLabel1, titleLabel2, reportTitleLabel;
@synthesize saleSummary, saleSummary2;
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
//        self.contentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//        self.contentView.layer.borderWidth = 1.0;
    
    NSInteger kGap = 3;
    float labelHeight = 60;
    
    self.reportTitleLabel = [self  createUnderlinedLabelWithRect:CGRectMake(5, 2, self.frame.size.width-10, 19) text:@"" bgColor:[UIColor clearColor] font:[UIFont italicSystemFontOfSize:17.0]];
    self.reportTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.reportTitleLabel.text = @"Sale Comparison  ▶";
    float nextY = 21;
    self.titleLabel1 = [self  createLabelWithRect:CGRectMake(5, nextY+6, self.frame.size.width-10, 19) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:13.0]];
    
    self.grossSaleLabel = [self  createLabelWithRect:CGRectMake(5, self.titleLabel1.frame.size.height+self.titleLabel1.frame.origin.y, self.frame.size.width/3, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.grossSaleLabel.numberOfLines = 3;
    self.grossSaleLabel.adjustsFontSizeToFitWidth = YES;
    self.grossSaleLabel.textAlignment = NSTextAlignmentLeft;
    
    float posX = self.grossSaleLabel.frame.origin.x + self.grossSaleLabel.frame.size.width+kGap;
    self.salesLabel = [self  createLabelWithRect:CGRectMake(posX, self.grossSaleLabel.frame.origin.y, self.frame.size.width/3, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.salesLabel.textAlignment = NSTextAlignmentCenter;
    self.salesLabel.adjustsFontSizeToFitWidth = YES;
    self.salesLabel.numberOfLines=3;
    posX = self.salesLabel.frame.origin.x + self.salesLabel.frame.size.width+kGap;
    
    self.avgSalesLabel = [self  createLabelWithRect:CGRectMake(posX, self.grossSaleLabel.frame.origin.y, (self.frame.size.width/3)-15, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.avgSalesLabel.adjustsFontSizeToFitWidth = YES;
    self.avgSalesLabel.textAlignment = NSTextAlignmentRight;
    self.avgSalesLabel.numberOfLines=3;
    
    [self.contentView addSubview: self.reportTitleLabel];
    [self.contentView addSubview:self.titleLabel1];
    [self.contentView addSubview:self.grossSaleLabel];
    [self.contentView addSubview:self.salesLabel];
    [self.contentView addSubview:self.avgSalesLabel];
    
    //for 2nd row
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){5,self.grossSaleLabel.frame.size.height+self.grossSaleLabel.frame.origin.y,self.frame.size.width-10,1}];
    lineView.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:lineView];
    
    nextY = self.grossSaleLabel.frame.size.height+self.grossSaleLabel.frame.origin.y+3;
    self.titleLabel2 = [self  createLabelWithRect:CGRectMake(5, nextY, self.frame.size.width-10, 19) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:13.0]];
    
    nextY = self.titleLabel2.frame.size.height+self.titleLabel2.frame.origin.y-5;
    self.grossSaleLabel2 = [self  createLabelWithRect:CGRectMake(5, nextY, self.frame.size.width/3, labelHeight-30) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.grossSaleLabel2.numberOfLines = 2;
    self.grossSaleLabel2.adjustsFontSizeToFitWidth = YES;
    self.grossSaleLabel2.textAlignment = NSTextAlignmentLeft;
    
    posX = self.grossSaleLabel2.frame.origin.x + self.grossSaleLabel2.frame.size.width+kGap;
    self.salesLabel2 = [self  createLabelWithRect:CGRectMake(posX, nextY, self.frame.size.width/3, labelHeight-30) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.salesLabel2.textAlignment = NSTextAlignmentCenter;
    self.salesLabel2.adjustsFontSizeToFitWidth = YES;
    self.salesLabel2.numberOfLines=2;
    posX = self.salesLabel2.frame.origin.x + self.salesLabel2.frame.size.width+kGap;
    
    self.avgSalesLabel2 = [self  createLabelWithRect:CGRectMake(posX, nextY, (self.frame.size.width/3)-15, labelHeight-30) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.avgSalesLabel2.adjustsFontSizeToFitWidth = YES;
    self.avgSalesLabel2.textAlignment = NSTextAlignmentRight;
    self.avgSalesLabel2.numberOfLines=2;
    
    self.titleLabel1.backgroundColor = [[CWColors sharedColors] rgba:@"241, 196, 15,1.0"];
    self.titleLabel2.backgroundColor = [[CWColors sharedColors] rgba:@"211, 84, 0,1.0"];
    self.titleLabel1.textColor = [UIColor whiteColor];
    self.titleLabel2.textColor = [UIColor whiteColor];
    self.titleLabel1.font = [UIFont boldSystemFontOfSize:13.0];
    self.titleLabel2.font = [UIFont boldSystemFontOfSize:13.0];
    
    [self.contentView addSubview:self.titleLabel2];
    [self.contentView addSubview:self.grossSaleLabel2];
    [self.contentView addSubview:self.salesLabel2];
    [self.contentView addSubview:self.avgSalesLabel2];
    
    nextY = self.grossSaleLabel2.frame.size.height+self.grossSaleLabel2.frame.origin.y;
    self.chartView = [[UIView alloc] initWithFrame:CGRectMake(1, nextY+1, self.frame.size.width, 210)];        
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.chartView.frame.size.width, 180)];
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
    NSMutableArray* datasets = [NSMutableArray array];
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:24];
//    NSArray* labels = [NSMutableArray arrayWithArray:@[@"Cash",@"Card",@"Voucher",@"On A/c", @"Others"]];
//    NSArray* labels = [NSMutableArray arrayWithArray:@[@"1 am",@"2 am",@"3 am",@"4 am", @"5 am",@"6 am",@"7 am",@"8 am",@"9 am", @"10 am", @"11 am",@"12 pm",@"1 pm",@"2 pm", @"3 pm",@"4 pm",@"5 pm",@"6 pm",@"7 pm", @"8 pm",@"9 pm",@"10 pm",@"11 pm",@"12 am"]];
    
    if(self.showOnlyValuedBars)
    {        
        NSArray *valuedTimes1 = self.saleSummary.timeWiseReports.allKeys;
        NSArray *valuedTimes2 = self.saleSummary2.timeWiseReports.allKeys;
        
        NSMutableArray *labels2 = [NSMutableArray arrayWithCapacity:24];
        NSMutableArray *data1 = [NSMutableArray arrayWithCapacity:24];
        NSMutableArray *data2 = [NSMutableArray arrayWithCapacity:24];
        for(NSString *time in valuedTimes1)
        {
            [labels addObject:[KSDateUtil chartTimeForTime:time]];
            [data1 addObject:[self.saleSummary.timeWiseReports valueForKey:time]];
        }
        
        for(NSString *time in valuedTimes2)
        {
            [labels2 addObject:[KSDateUtil chartTimeForTime:time]];
            [data2 addObject:[self.saleSummary2.timeWiseReports valueForKey:time]];
        }
        
        for(NSInteger i = 1; i <= 2; i++) {
            CWBarDataSet* ds = nil;
            
            if(i==1)
            {
                ds = [[CWBarDataSet alloc] initWithData:data1];
            }
            else
            {
                ds = [[CWBarDataSet alloc] initWithData:data2];
            }

            CWColor* c1 = [[CWColors sharedColors] pickColor];            
            if(i==1)
                c1 = [[CWColors sharedColors] rgba:@"241, 196, 15,1.0"];
            else
                c1 = [[CWColors sharedColors] rgba:@"211, 84, 0,1.0"];
            
            CWColor* c2 = [c1 colorWithAlphaComponent:1.0f];
            ds.fillColor = c2;
            ds.strokeColor = c1;
            [datasets addObject:ds];
        }   
    }
    else
    {
        labels = [NSMutableArray arrayWithArray:@[@"1-2 am",@"2-3 am",@"3-4 am",@"4-5 am", @"5-6 am",@"6-7 am",@"7-8 am",@"8-9 am",@"9-10 am", @"10-11 am", @"11-12 am",@"12-1 pm",@"1-2 pm",@"2-3 pm", @"3-4 pm",@"4-5 pm",@"5-6 pm",@"6-7 pm",@"7-8 pm", @"8-9 pm",@"9-10 pm",@"10-11 pm",@"11-12 pm",@"12-1 am"]];
        
        for(NSInteger i = 1; i <= 2; i++) {
            CWBarDataSet* ds = nil;
            
            if(i==1)
            {
                //            ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalCash),@(self.saleSummary.totalCard),@(self.saleSummary.totalVoucher),@(self.saleSummary.totalOnAccount),@(self.saleSummary.totalMix)]];
                ds = [[CWBarDataSet alloc] initWithData:@[@([[self.saleSummary.timeWiseReports valueForKey:@"1"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"2"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"3"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"4"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"5"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"6"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"7"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"8"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"9"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"10"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"11"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"12"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"13"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"14"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"15"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"16"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"17"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"18"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"19"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"20"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"21"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"22"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"23"] floatValue]),@([[self.saleSummary.timeWiseReports valueForKey:@"24"] floatValue])]];
            }
            else
            {
                //            ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary2.totalCash),@(self.saleSummary2.totalCard),@(self.saleSummary2.totalVoucher),@(self.saleSummary2.totalOnAccount),@(self.saleSummary2.totalMix)]];
                ds = [[CWBarDataSet alloc] initWithData:@[@([[self.saleSummary.timeWiseReports valueForKey:@"1"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"2"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"3"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"4"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"5"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"6"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"7"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"8"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"9"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"10"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"11"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"12"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"13"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"14"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"15"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"16"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"17"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"18"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"19"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"20"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"21"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"22"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"23"] floatValue]),@([[self.saleSummary2.timeWiseReports valueForKey:@"24"] floatValue])]];
            }
            
            /*
             else if(i==2)
             ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalCard)]];
             else if(i==3)
             ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalVoucher)]];
             else if(i==4)
             ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalOnAccount)]];
             else if(i==5)
             ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalMix)]];*/
            
            CWColor* c1 = [[CWColors sharedColors] pickColor];
            
            if(i==1)
                c1 = [[CWColors sharedColors] rgba:@"241, 196, 15,1.0"];
            else
                c1 = [[CWColors sharedColors] rgba:@"211, 84, 0,1.0"];
            
            CWColor* c2 = [c1 colorWithAlphaComponent:1.0f];
            ds.fillColor = c2;
            ds.strokeColor = c1;
            [datasets addObject:ds];
        }
    }
    CWBarChartData* bcd = [[CWBarChartData alloc] initWithLabels:labels andDataSet:datasets];
    CWBarChart* bc = [[CWBarChart alloc] initWithWebView:self.webview name:@"BarChart1" width:550 height:180 data:bcd options:nil];
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
