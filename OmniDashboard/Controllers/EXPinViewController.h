//
//  EXViewController.h
//  ExTunes
//
//  Created by Kumar Sharma on 13/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPViewController.h"

@interface EXPinViewController : OPViewController<UITextFieldDelegate>
{
    IBOutlet UIView *loginBgView;
    IBOutlet UITextField *txtPIN;
    IBOutlet UIButton *loginBtn, *forgotPinBtn;
    IBOutlet UIView *pinView;
}

- (IBAction)loginBtnAction:(id)sender;
- (IBAction)changeLoginPin:(id)sender;
- (IBAction)loginNumberBtnAction:(id)sender;
- (IBAction)loginClearBtnAction:(id)sender;
@end
