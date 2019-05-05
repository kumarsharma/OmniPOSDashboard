//
//  OPServerLoginViewController.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 21/12/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPViewController.h"
@interface OPServerLoginViewController : OPViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, assign) BOOL isSignIn;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UITableView *tableView;

@end
