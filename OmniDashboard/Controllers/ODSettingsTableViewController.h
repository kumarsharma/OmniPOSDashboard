//
//  ODSettingsTableViewController.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 27/04/18.
//  Copyright © 2018 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPViewController.h"

@interface ODSettingsTableViewController : OPViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end
