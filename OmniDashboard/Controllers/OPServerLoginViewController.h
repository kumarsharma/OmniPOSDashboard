//
//  OPServerLoginViewController.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 21/12/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPViewController.h"

@protocol OPServerLoginDelegate <NSObject>

- (void)didFinishSignInProcess;

@end

@interface OPServerLoginViewController : OPViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    __weak id<OPServerLoginDelegate> delegate_;
}

@property (nonatomic, assign) BOOL isSignIn;
@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<OPServerLoginDelegate> delegate;

@end
