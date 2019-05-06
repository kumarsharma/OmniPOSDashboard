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


@implementation OPReportComparisonCell
@synthesize grossSaleLabel, salesLabel, avgSalesLabel;
@synthesize grossSaleLabel2, salesLabel2, avgSalesLabel2, titleLabel1, titleLabel2, reportTitleLabel;
@synthesize saleSummary, saleSummary2;
@synthesize webview;
@synthesize chartView;
@synthesize barChart;

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
    webview.scrollView.scrollEnabled = NO;
    self.webview = webview;
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/cw.html"];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
    [self.contentView addSubview:self.chartView];    
}

- (void)reloadViews
{
    NSArray* labels = [NSMutableArray arrayWithArray:@[@"Cash",@"Card",@"Voucher",@"On A/c", @"Others"]];
    NSMutableArray* datasets = [NSMutableArray array];
    
    for(NSInteger i = 1; i <= 2; i++) {
        CWBarDataSet* ds = nil;
        
        if(i==1)
            ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalCash),@(self.saleSummary.totalCard),@(self.saleSummary.totalVoucher),@(self.saleSummary.totalOnAccount),@(self.saleSummary.totalMix)]];
        else
            ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary2.totalCash),@(self.saleSummary2.totalCard),@(self.saleSummary2.totalVoucher),@(self.saleSummary2.totalOnAccount),@(self.saleSummary2.totalMix)]];
        
        /*
         else if(i==2)
         ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalCard)]];
         else if(i==3)
         ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalVoucher)]];
         else if(i==4)
         ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalOnAccount)]];
         else if(i==5)
         ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalMix)]];*/
        
        ds.label = [NSString stringWithFormat:@"Label %ld",i];
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
    CWBarChartData* bcd = [[CWBarChartData alloc] initWithLabels:labels andDataSet:datasets];
    CWBarChart* bc = [[CWBarChart alloc] initWithWebView:self.webview name:@"BarChart1" width:300 height:200 data:bcd options:nil];
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
