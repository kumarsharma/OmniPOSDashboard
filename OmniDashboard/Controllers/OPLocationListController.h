//
//  EXLocationListViewController.h
//  ExTunes
//
//  Created by Kumar Sharma on 08/04/14.
//  Copyright (c) 2014 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPViewController.h"

@interface OPLocationListController : OPViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@end
