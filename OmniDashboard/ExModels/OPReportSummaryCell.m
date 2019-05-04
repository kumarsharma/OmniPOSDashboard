
//
//  OPReportSummaryCell.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 30/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPReportSummaryCell.h"
#import "OPSaleSummary.h"

@implementation OPReportSummaryCell
@synthesize grossSaleLabel, salesLabel, avgSalesLabel;
@synthesize saleSummary;
@synthesize webview;
@synthesize chartView;

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
    //    self.contentView.backgroundColor = [UIColor grayColor];
    //    self.contentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    //    self.contentView.layer.borderWidth = 1.0;
    
    NSInteger kGap = 3;
    float labelHeight = 60;

    self.grossSaleLabel = [self  createLabelWithRect:CGRectMake(5, 0, self.frame.size.width/3, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.grossSaleLabel.numberOfLines = 2;
    self.grossSaleLabel.adjustsFontSizeToFitWidth = YES;
    self.grossSaleLabel.textAlignment = NSTextAlignmentLeft;
    
    float posX = self.grossSaleLabel.frame.origin.x + self.grossSaleLabel.frame.size.width+kGap;
    self.salesLabel = [self  createLabelWithRect:CGRectMake(posX, 0, self.frame.size.width/3, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.salesLabel.textAlignment = NSTextAlignmentCenter;
    self.salesLabel.adjustsFontSizeToFitWidth = YES;
    self.salesLabel.numberOfLines=2;
    posX = self.salesLabel.frame.origin.x + self.salesLabel.frame.size.width+kGap;
    
    self.avgSalesLabel = [self  createLabelWithRect:CGRectMake(posX, 0, (self.frame.size.width/3)-15, labelHeight) text:@"" bgColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15.0]];
    self.avgSalesLabel.adjustsFontSizeToFitWidth = YES;
    self.avgSalesLabel.textAlignment = NSTextAlignmentRight;
    self.avgSalesLabel.numberOfLines=2;
    [self.contentView addSubview:self.grossSaleLabel];
    [self.contentView addSubview:self.salesLabel];
    [self.contentView addSubview:self.avgSalesLabel];

    self.chartView = [[UIView alloc] initWithFrame:CGRectMake(1, labelHeight+5, self.frame.size.width, 210)];        
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.chartView.frame.size.width, 180)];
    webview.UIDelegate = self;
    [webview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.chartView addSubview:webview];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(webview);
    [self.chartView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[webview]|" options:0 metrics:nil views:viewsDictionary]];
    [self.chartView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webview]|" options:0 metrics:nil views:viewsDictionary]];
    
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
    for(NSInteger i = 1; i <= 1; i++) {
        CWBarDataSet* ds = nil;
        
        if(i==1)
            ds = [[CWBarDataSet alloc] initWithData:@[@(self.saleSummary.totalCash),@(self.saleSummary.totalCard),@(self.saleSummary.totalVoucher),@(self.saleSummary.totalOnAccount),@(self.saleSummary.totalMix)]];
        
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
        CWColor* c2 = [c1 colorWithAlphaComponent:1.0f];
        ds.fillColor = c2;
        ds.strokeColor = c1;
        [datasets addObject:ds];
    }    
    CWBarChartData* bcd = [[CWBarChartData alloc] initWithLabels:labels andDataSet:datasets];
    CWBarChart* bc = [[CWBarChart alloc] initWithWebView:self.webview name:@"BarChart1" width:300 height:200 data:bcd options:nil];
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

- (NSInteger) random:(NSInteger) max {
    return (NSInteger)arc4random_uniform((u_int32_t)max);
}

@end
