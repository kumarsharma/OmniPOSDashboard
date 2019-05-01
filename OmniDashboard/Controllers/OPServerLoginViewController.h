//
//  OPServerLoginViewController.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 21/12/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPServerLoginViewController : UITableViewController<UITextFieldDelegate>
{
    
}

@property (nonatomic, assign) BOOL isSignIn;
@property (nonatomic, strong) UIColor *buttonColor;

@end
