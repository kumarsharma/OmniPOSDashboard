
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
@synthesize chartView;
@synthesize saleSummary;

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
}

- (void)reloadViews
{
    if(self.chartView)
        [self.chartView removeFromSuperview];
    float labelHeight = 60;
    NSArray *vals = [NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:self.saleSummary.totalCash],
                     [NSNumber numberWithInt:self.saleSummary.totalCard],
                     [NSNumber numberWithInt:self.saleSummary.totalVoucher],
                     [NSNumber numberWithInt:self.saleSummary.totalOnAccount],
                     [NSNumber numberWithInt:self.saleSummary.totalMix],
                     nil];
    NSArray *refs = [NSArray arrayWithObjects:@"Cash", @"Card", @"Voucher", @"On A/c", @"Others", nil];

    DSBarChart *chrt = [[DSBarChart alloc] initWithFrame:CGRectMake(1, labelHeight+20, self.frame.size.width, 200) color:[UIColor blackColor] references:refs andValues:vals];
    chrt.backgroundColor = [UIColor clearColor];
    self.chartView = chrt;
    [self.contentView addSubview:chrt];
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


@end
