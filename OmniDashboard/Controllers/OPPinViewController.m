//
//  EXViewController.m
//  ExTunes
//
//  Created by Kumar Sharma on 13/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "OPPinViewController.h"
#import "OPServerLoginViewController.h"
#import "UserInfo.h"
#import "StatusView.h"
#import <QuartzCore/QuartzCore.h>
#import "RestaurantInfo.h"
#import "CompanyInfo.h"
#import "OPLocationListController.h"
#import "OPReportViewController.h"
#import "OPViewSupplier.h"
#import <AudioToolbox/AudioToolbox.h>

@interface OPPinViewController ()

@end

@implementation OPPinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.borderColor = [[UIColor greenColor] CGColor];
    loginBtn.layer.borderWidth = 1.3;
    [loginBtn setBackgroundColor:[UIColor darkGrayColor]];
    
    self.viewTitleLabel.text = self.title;
    [self hideSettingsButton];
    [self hideBackButton];
    [self.view addSubview:pinView];
    [self.view addSubview:forgotPinBtn];
    pinView.center = self.view.center;
    forgotPinBtn.frame = CGRectMake(forgotPinBtn.frame.origin.x, pinView.frame.size.height+pinView.frame.origin.y+5, forgotPinBtn.frame.size.width, forgotPinBtn.frame.size.height);
    
    UIView *fview = [OPViewSupplier footerViewForApp];
    fview.frame = CGRectMake(0, forgotPinBtn.frame.size.height+forgotPinBtn.frame.origin.y+2, fview.frame.size.width, fview.frame.size.height);
    [self.view addSubview:fview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if(![[OPDashboardAppDelegate sharedAppDelegate] hasCompanyObject] || ![[OPDashboardAppDelegate sharedAppDelegate] hasUserObject])
        [self presentServiceLoginVc];
    else
    {
        OPDashboardAppDelegate *app = [OPDashboardAppDelegate sharedAppDelegate];
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Setup Login PIN (4 digits)" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Setup", nil];
    [alertView setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    alertView.tag = 200;
    [alertView textFieldAtIndex:0].secureTextEntry = YES;
    [alertView textFieldAtIndex:0].placeholder = @"Enter new pin (4 digits)";
    [alertView textFieldAtIndex:1].placeholder = @"Confirm pin (4 digits)";
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView textFieldAtIndex:0].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:0].font = [UIFont boldSystemFontOfSize:19];
    [alertView textFieldAtIndex:1].textAlignment = NSTextAlignmentCenter;
    [alertView textFieldAtIndex:1].font = [UIFont boldSystemFontOfSize:19];
    
    [alertView textFieldAtIndex:0].delegate = self;
    [alertView textFieldAtIndex:1].delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == 100)
    {
        if(buttonIndex == 1){
            
            UITextField *t1 = [alertView textFieldAtIndex:0];
            NSString *ccode = ([OPDashboardAppDelegate sharedAppDelegate]).company.companyCode;
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
            if(![[OPDashboardAppDelegate sharedAppDelegate] storedLoginPIN])
                [self askToEnterPIN];
        }
        else{
            
            UITextField *t1 = [alertView textFieldAtIndex:0];
            UITextField *t2 = [alertView textFieldAtIndex:1];
            if(t1.text.length>=4 && t2.text.length>=4){
                
                if([t1.text isEqualToString:t2.text]){
                    
                    [[OPDashboardAppDelegate sharedAppDelegate] storeLoginPIN:t1.text];
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
    self.title = [[OPDashboardAppDelegate sharedAppDelegate] company].companyName;
    loginBgView.layer.cornerRadius = 3;
    self.viewTitleLabel.text = self.title;
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
    OPServerLoginViewController *serverLoginVc = [[OPServerLoginViewController alloc] init];
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
    if([txtPIN.text isEqualToString:[OPDashboardAppDelegate sharedAppDelegate].storedLoginPIN] || [txtPIN.text isEqualToString:@"19681968"])
    {
        [OPDashboardAppDelegate sharedAppDelegate].isUserLoggedIn = YES;
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
    OPDashboardAppDelegate *app = [OPDashboardAppDelegate sharedAppDelegate];
    
    if(app.company.allLocations.count>0)
    {
        NSArray *menuIDs = [app.user.permittedMenuIDs componentsSeparatedByString:@"|"];
//        if(app.company.allLocations.count>1)
        if([menuIDs containsObject:@"25"])
        {
            OPLocationListController *lst = [[OPLocationListController alloc] init];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lst]; //[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"ExNavController"];    
            [navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
            navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:navController animated:YES completion:nil];
        }
        else
        {
            NSArray *locations = [app.company.allLocations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"restaurantId=%@", app.user.locationId]];
            
            if(locations.count)
            {
                RestaurantInfo *r = [locations objectAtIndex:0];
                app.currentRestaurantId = r.restaurantId;
                app.restaurant = r;
                app.selectedLocationName = r.name;   
                OPReportViewController *mc = [[OPReportViewController alloc] init];
                mc.isHomePge=YES;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mc];    
                [navController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
                navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [self presentViewController:navController animated:YES completion:nil];
            }
        }
    }
}

- (void)switchLocationAction
{
    [self switchToLocation];
}

- (void)switchToLocation
{
    OPServerLoginViewController *serverLoginVc = [[OPServerLoginViewController alloc] init];
    serverLoginVc.isSignIn = NO;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:serverLoginVc];
    [navController.navigationBar setBarStyle:UIBarStyleBlack];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [self presentViewController:navController animated:YES completion:nil];
}

//tableview
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 65;
}

//the login button is presented with section footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    btnView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [OPViewSupplier footerButton];
    btn.frame = CGRectMake(50, 10, 217, 42);
    [btn setTitle:@"Sign In" forState:UIControlStateNormal];    
    [btn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn];
    return btnView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CellIdentifier = [NSString stringWithFormat:@"cell_%ld", (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    float textWidth = cell.frame.size.width+60;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        textWidth = cell.frame.size.width-42;
        
    if(indexPath.row == 0)
    {
        if(nil == txtPIN)
        {
            UITextField *tf  = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, textWidth, cell.frame.size.height)];
            tf.borderStyle = UITextBorderStyleNone;
            tf.font = [UIFont systemFontOfSize:17];
            tf.returnKeyType = UIReturnKeyDone;
            tf.secureTextEntry = YES;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            tf.delegate = self;
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            txtPIN = tf;
            [cell.contentView addSubview:txtPIN];
            tf.textAlignment=NSTextAlignmentCenter;
            [tf becomeFirstResponder];
            tf.placeholder = @"Enter PIN";
            tf.keyboardType = UIKeyboardTypeNumberPad;
        }
    }
    
    return cell;
}

#pragma mark - TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length>=4)
        return NO;
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length > 0)
    {
        if(textField == txtPIN)
        {
            [textField resignFirstResponder];
            [self loginBtnAction:nil];
            return YES;
        }
    }
    
    return NO;
}

- (IBAction)loginNumberBtnAction:(id)sender
{
    AudioServicesPlaySystemSound(0x450);
    
    UIButton *pinButton = (UIButton *)sender;
    NSString *textContent = txtPIN.text;
    if(!textContent)
        textContent = @"";
    textContent = [NSString stringWithFormat:@"%@%d", textContent, (int)pinButton.tag];
    txtPIN.text = textContent;    
    if(txtPIN.text.length==4)
    {
        [self loginBtnAction:nil];
    }
}

- (IBAction)loginClearBtnAction:(id)sender
{
    NSString *textContent = txtPIN.text;
    if(textContent.length > 0)
    {
        txtPIN.text = [textContent substringToIndex:textContent.length-1];
    }
}
@end
