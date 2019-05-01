//
//  EXSaleView.h
//  ExTunes
//
//  Created by Kumar Sharma on 27/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXSaleView : UITableViewHeaderFooterView
{
    UILabel *_textSaleLabel, *_totalSaleLabel, *_adjSaleLabel;
}

@property (nonatomic, strong) UILabel *textSaleLabel, *totalSaleLabel, *adjSaleLabel;
@end
