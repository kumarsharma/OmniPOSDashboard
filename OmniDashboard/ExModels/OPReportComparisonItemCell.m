//
//  OPReportComparisonItemCell.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 06/05/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPReportComparisonItemCell.h"

@implementation OPReportComparisonItemCell
@synthesize titleLabel, totalAmountLabel1, totalAmountLabel2;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubviews];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews
{
    NSInteger kGap = 3;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    self.titleLabel = [self  createLabelWithRect:CGRectMake(5, 0, 120, self.frame.size.height) text:@"" bgColor:[UIColor clearColor] font:font];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
    float posX = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width+kGap;
    
    self.totalAmountLabel1 = [self  createLabelWithRect:CGRectMake(posX, 0, 90, self.frame.size.height) text:@"" bgColor:[UIColor clearColor] font:font];
    self.totalAmountLabel1.textAlignment = NSTextAlignmentRight;
        self.totalAmountLabel1.minimumScaleFactor = 10;
    self.totalAmountLabel1.adjustsFontSizeToFitWidth = YES;
    posX = self.totalAmountLabel1.frame.origin.x + self.totalAmountLabel1.frame.size.width+kGap;
    
    self.totalAmountLabel2 = [self  createLabelWithRect:CGRectMake(posX, 0, 90, self.frame.size.height) text:@"" bgColor:[UIColor clearColor] font:font];
        self.totalAmountLabel2.minimumScaleFactor = 10;
    self.totalAmountLabel2.adjustsFontSizeToFitWidth = YES;
    self.totalAmountLabel2.textAlignment = NSTextAlignmentRight;
    self.totalAmountLabel2.numberOfLines=3;
    self.totalAmountLabel1.numberOfLines=3;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.totalAmountLabel1];
    [self.contentView addSubview:self.totalAmountLabel2];
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
