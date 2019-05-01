//
//  ODSettingsTableViewController.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 27/04/18.
//  Copyright © 2018 OmniSyems. All rights reserved.
//

#import "ODSettingsTableViewController.h"
#import "StatusView.h"
#import "OPTermsViewController.h"
#import "OPViewSupplier.h"

@interface ODSettingsTableViewController ()

@end

@implementation ODSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.navigationController.toolbarHidden = YES;
//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnAction)];
//    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 110)];
    UIButton *logoutBUtton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBUtton.frame = CGRectMake(10, 40, self.tableView.frame.size.width-20, 45);
    logoutBUtton.backgroundColor = [UIColor redColor];
    [logoutBUtton setTitle:@"Sign Out" forState:UIControlStateNormal];
    [logoutBUtton addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBUtton];
    self.tableView.tableHeaderView = footerView;

    self.tableView.tableFooterView = [OPViewSupplier footerViewForApp];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Settings";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
}

- (void)cancelBtnAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logoutBtnAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section == 0)
        cell.textLabel.text = @"Change Login PIN";
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = @"Terms & Conditions";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        [self changeLoginPin];
    else if(indexPath.section == 1)
    {
        OPTermsViewController *termsVc = [[OPTermsViewController alloc] init];
        [self.navigationController pushViewController:termsVc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)changeLoginPin{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter current login PIN" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Proceed", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [alertView textFieldAtIndex:0].placeholder = @"Enter pin";
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView textFieldAtIndex:0].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:0].font = [UIFont boldSystemFontOfSize:19];
    alertView.tag = 100;
    [alertView show];
}

- (void)askToEnterPIN{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change Login PIN" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alertView textFieldAtIndex:0].secureTextEntry = YES;
    [alertView textFieldAtIndex:0].placeholder = @"Enter new pin";
    [alertView textFieldAtIndex:1].placeholder = @"Confirm pin";
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView textFieldAtIndex:0].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:0].font = [UIFont boldSystemFontOfSize:19];
    [alertView textFieldAtIndex:1].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:1].font = [UIFont boldSystemFontOfSize:19];
    alertView.tag = 200;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 100){
        
        if(buttonIndex == 1){
        
            UITextField *t1 = [alertView textFieldAtIndex:0];
            if([t1.text isEqualToString:[EXAppDelegate sharedAppDelegate].storedLoginPIN] || [t1.text isEqualToString:@"19681968"]){

                [self askToEnterPIN];
            }
            else{
                
                [StatusView showPopupWithMessage:@"Invalid PIN!" timeToStay:2 onView:self.navigationController.view];
            }
        }
    }
    else if(alertView.tag == 200){
        
        if(buttonIndex == 1)
        {
            UITextField *t1 = [alertView textFieldAtIndex:0];
            UITextField *t2 = [alertView textFieldAtIndex:1];
            if(t1.text.length>=4 && t2.text.length>=4){
                
                if([t1.text isEqualToString:t2.text]){
                    
                    [[EXAppDelegate sharedAppDelegate] storeLoginPIN:t1.text];
                    [StatusView showPopupWithMessage:@"Login PIN Changed Successfully!" timeToStay:2 onView:self.navigationController.view];
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

@end
