//
//  EXViewController.h
//  ExTunes
//
//  Created by Kumar Sharma on 13/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EXPinViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIView *loginBgView;
    UITextField *txtPIN;
    IBOutlet UIButton *loginBtn;
    IBOutlet UITableView *tableView;
}

- (IBAction)loginBtnAction:(id)sender;
- (IBAction)changeLoginPin:(id)sender;
@end
