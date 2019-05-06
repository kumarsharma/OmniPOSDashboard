//
//  OPReportItemCell.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 29/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPReportItemCell.h"

@implementation OPReportItemCell
@synthesize titleLabel, totalAmountLabel, countField;

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
//    self.contentView.backgroundColor = [UIColor grayColor];
//    self.contentView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
//    self.contentView.layer.borderWidth = 1.0;
    
    NSInteger kGap = 3;
    UIFont *font = [UIFont systemFontOfSize:14.0];
    self.titleLabel = [self  createLabelWithRect:CGRectMake(5, 0, 160, self.frame.size.height) text:@"" bgColor:[UIColor clearColor] font:font];
//    self.titleLabel.minimumScaleFactor = 10;
//    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
    float posX = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width+kGap;
    
    self.countField = [self  createLabelWithRect:CGRectMake(posX, 0, 60, self.frame.size.height) text:@"" bgColor:[UIColor clearColor] font:font];
    self.countField.textAlignment = NSTextAlignmentCenter;
//    self.countField.minimumScaleFactor = 10;
    self.countField.adjustsFontSizeToFitWidth = YES;
    posX = self.countField.frame.origin.x + self.countField.frame.size.width+kGap;
    
    self.totalAmountLabel = [self  createLabelWithRect:CGRectMake(posX, 0, 80, self.frame.size.height) text:@"" bgColor:[UIColor clearColor] font:font];
//    self.totalAmountLabel.minimumScaleFactor = 10;
    self.totalAmountLabel.adjustsFontSizeToFitWidth = YES;
    self.totalAmountLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.countField];
    [self.contentView addSubview:self.totalAmountLabel];
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
