//
//  EXSaleView.m
//  ExTunes
//
//  Created by Kumar Sharma on 27/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "EXSaleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EXSaleView
@synthesize textSaleLabel = _textSaleLabel, totalSaleLabel = _totalSaleLabel, adjSaleLabel = _adjSaleLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 128, 30)];
        lbl.textAlignment = UITextAlignmentRight;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.textColor = [UIColor whiteColor];
        lbl.adjustsFontSizeToFitWidth = YES;
        self.textSaleLabel = lbl;
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(136, 0, 66, 30)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.adjustsFontSizeToFitWidth = YES;
        self.totalSaleLabel = lbl;
        
        lbl = [[UILabel alloc] initWithFrame:CGRectMake(216, 0, 66, 30)];
        lbl.textAlignment = UITextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = [UIFont systemFontOfSize:16];
        lbl.textColor = [UIColor whiteColor];
        lbl.adjustsFontSizeToFitWidth = YES;
        self.adjSaleLabel = lbl;
        
        [self addSubview:self.textSaleLabel];
        [self addSubview:self.totalSaleLabel];
        [self addSubview:self.adjSaleLabel];
        
        self.layer.borderWidth = 1;
        
        UIView *bview = [[UIView alloc] initWithFrame:self.frame];
        bview.backgroundColor = [UIColor clearColor];
        self.backgroundView = bview;
    }
    return self;
}

@end
