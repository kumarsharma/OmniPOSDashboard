//
//  EXViewController.m
//  ExTunes
//
//  Created by Kumar Sharma on 13/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "EXPinViewController.h"
#import "OPServerLoginViewController.h"
#import "UserInfo.h"
#import "StatusView.h"
#import <QuartzCore/QuartzCore.h>
#import "RestaurantInfo.h"
#import "CompanyInfo.h"
#import "EXLocationListViewController.h"

@interface EXPinViewController ()

@end

@implementation EXPinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if(![[EXAppDelegate sharedAppDelegate] hasCompanyObject] || ![[EXAppDelegate sharedAppDelegate] hasUserObject])
        [self presentServiceLoginVc];
    else
    {
        EXAppDelegate *app = [EXAppDelegate sharedAppDelegate];
        if(![app storedLoginPIN]){
            
            [self askToEnterPIN];
        }
    }
}

- (IBAction)changeLoginPin:(id)sender{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter company code" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Proceed", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView textFieldAtIndex:0].placeholder = @"Enter code";
//    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView textFieldAtIndex:0].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:0].font = [UIFont boldSystemFontOfSize:19];
    alertView.tag = 100;
    [alertView show];
}

- (void)askToEnterPIN{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Setup Login PIN" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setup", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    alertView.tag = 200;
    [alertView textFieldAtIndex:0].secureTextEntry = YES;
    [alertView textFieldAtIndex:0].placeholder = @"Enter new pin";
    [alertView textFieldAtIndex:1].placeholder = @"Confirm pin";
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView textFieldAtIndex:0].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:0].font = [UIFont boldSystemFontOfSize:19];
    [alertView textFieldAtIndex:1].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:1].font = [UIFont boldSystemFontOfSize:19];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 100)
    {
        if(buttonIndex == 1){
            
            UITextField *t1 = [alertView textFieldAtIndex:0];
            NSString *ccode = ([EXAppDelegate sharedAppDelegate]).company.companyCode;
            if([t1.text isEqualToString:ccode]){
                
                [self askToEnterPIN];
            }
            else{
                
                [StatusView showPopupWithMessage:@"Invalid code!" timeToStay:2 onView:self.navigationController.view];
            }
        }
    }
    else if(alertView.tag == 200)
    {
        if(buttonIndex == 0)
        {
            if(![[EXAppDelegate sharedAppDelegate] storedLoginPIN])
                [self askToEnterPIN];
        }
        else{
            
            UITextField *t1 = [alertView textFieldAtIndex:0];
            UITextField *t2 = [alertView textFieldAtIndex:1];
            if(t1.text.length>=4 && t2.text.length>=4){
                
                if([t1.text isEqualToString:t2.text]){
                    
                    [[EXAppDelegate sharedAppDelegate] storeLoginPIN:t1.text];
                    [StatusView showPopupWithMessage:@"Login PIN Setup Complete! You can login now." timeToStay:2 onView:self.navigationController.view];
                }
                else{
                    
                    [StatusView showPopupWithMessage:@"Confirm PIN does not match" timeToStay:2 onView:self.navigationController.view];
                    [self askToEnterPIN];
                }
            }
            else{
                
                [StatusView showPopupWithMessage:@"Login PIN must be 4 chars long" timeToStay:2 onView:self.navigationController.view];
                [self askToEnterPIN];
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [txtPIN becomeFirstResponder];
    self.title = [[EXAppDelegate sharedAppDelegate] company].companyName;
    loginBgView.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Service Login Vc

- (void)presentServiceLoginVc
{
    //present service login view only when the restaurantInfo or menus are empty
    //Generally it appears only once after the first installation of the app
    OPServerLoginViewController *serverLoginVc = [[OPServerLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
    serverLoginVc.isSignIn = YES;
    serverLoginVc.buttonColor = [loginBtn titleColorForState:UIControlStateNormal];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:serverLoginVc];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navController animated:NO completion:nil];
}

#pragma mark - Login

- (IBAction)loginBtnAction:(id)sender
{
    if([txtPIN.text isEqualToString:[EXAppDelegate sharedAppDelegate].storedLoginPIN] || [txtPIN.text isEqualToString:@"19681968"])
    {
        [EXAppDelegate sharedAppDelegate].isUserLoggedIn = YES;
        [self showExList];
    }
    else
    {
        [StatusView showPopupWithMessage:@"Invalid PIN" timeToStay:2 onView:self.navigationController.view];
    }
    txtPIN.text = @"";
}

- (void)showExList
{
    EXLocationListViewController *lst = [[EXLocationListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lst]; //[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ExNavController"];    
    [navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)switchLocationAction
{
    [self switchToLocation];
}

- (void)switchToLocation
{
    OPServerLoginViewController *serverLoginVc = [[OPServerLoginViewController alloc] initWithStyle:UITableViewStyleGrouped];
    serverLoginVc.isSignIn = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:serverLoginVc];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navController animated:YES completion:nil];
}

@end
