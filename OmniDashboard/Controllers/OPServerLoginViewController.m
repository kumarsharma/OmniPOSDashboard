//
//  OPServerLoginViewController.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 21/12/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

/*
    Initially user is ask to login using omnipos registered userid/password.
    After a successful login the app receives the restaurantInfo which is the top restaurant data.
    Based on the restaurantInfo data the finishedLoginWithResponse: method asks OPDataFetchHelper to download 
    the menu details and the related information
*/

#import "OPServerLoginViewController.h"
#import "RestaurantInfo.h"
#import "LoadingIndicatorView.h"
#import "OPDataFetchHelper.h"
#import "Reachability.h"
#import "NSString+Extension.h"
#import "CompanyInfo.h"
#import "OPViewSupplier.h"

@interface OPServerLoginViewController ()

@property (nonatomic, strong) UITextField *userNameTxtField, *passwordTxtField, *baseURLTxtField;
@property (nonatomic, strong) LoadingIndicatorView *indicatorView;

@end

@implementation OPServerLoginViewController
@synthesize userNameTxtField, passwordTxtField, baseURLTxtField;
@synthesize indicatorView;
@synthesize isSignIn;
@synthesize buttonColor;
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.isSignIn)
        self.title = @"Sign In";
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
        self.title = @"Switch Company";
    }
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topBarView.frame.size.height+self.topBarView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-(self.topBarView.frame.size.height+self.topBarView.frame.origin.y)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.viewTitleLabel.text = self.title;
    self.tableView.tableFooterView = [OPViewSupplier footerViewForApp];
    [self hideBackButton];
    [self hideSettingsButton];
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    [btn addTarget:self action:@selector(fetchRestaurantInfo) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:btn];
    
    return btnView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    
    NSString *uname = nil, *password = nil;
    
    if(indexPath.row == 1)
    {
        if(nil == self.userNameTxtField)
        {
            UITextField *tf  = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, textWidth, cell.frame.size.height)];
            tf.borderStyle = UITextBorderStyleNone;
            tf.font = [UIFont systemFontOfSize:17];
            tf.returnKeyType = UIReturnKeyNext;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            tf.delegate = self;
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            self.userNameTxtField = tf;
            [cell.contentView addSubview:self.userNameTxtField];            
        }
        
        if(uname.length > 0)
            self.userNameTxtField.text = uname;
        else
            self.userNameTxtField.placeholder = @"User Name";
    }
    else if(indexPath.row == 2)
    {
        if(nil == self.passwordTxtField)
        {
            UITextField *tf  = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, textWidth, cell.frame.size.height)];
            tf.borderStyle = UITextBorderStyleNone;
            tf.font = [UIFont systemFontOfSize:17];
            self.passwordTxtField = tf;
            tf.returnKeyType = UIReturnKeyNext;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            tf.delegate = self;
            self.passwordTxtField.secureTextEntry = YES;
            [cell.contentView addSubview:self.passwordTxtField];
        }
        
        if(password.length > 0)
            self.passwordTxtField.text = password;
        else
            self.passwordTxtField.placeholder = @"Password";
    }
    else if(indexPath.row == 0)
    {
        if(nil == self.baseURLTxtField)
        {
            UITextField *tf  = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, textWidth, cell.frame.size.height)];
            tf.borderStyle = UITextBorderStyleNone;
            tf.font = [UIFont systemFontOfSize:17];
            tf.returnKeyType = UIReturnKeyGo;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            tf.delegate = self;
            tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
            tf.keyboardType = UIKeyboardTypeEmailAddress;
            self.baseURLTxtField = tf;
            self.baseURLTxtField.placeholder = @"Company Code";
        } 
        [cell.contentView addSubview:self.baseURLTxtField];
    }

    return cell;
}

#pragma mark - TextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length > 0)
    {
        if(textField == self.userNameTxtField)
        {
            [self.passwordTxtField becomeFirstResponder];
            [textField resignFirstResponder];
            return YES;
        }
        else if(textField == self.passwordTxtField)
        {
            [self.baseURLTxtField becomeFirstResponder];
            [textField resignFirstResponder];
            return YES;
        }
        else if(textField == baseURLTxtField)
        {
            [self fetchRestaurantInfo];
            return YES;
        }
    }
    
    return YES;
}

#pragma mark - Remote fetch

- (void)fetchRestaurantInfo
{
    if(self.userNameTxtField.text.length <= 0 || self.passwordTxtField.text.length <= 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Missing Fields" message:@"Please enter both username and password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if(self.baseURLTxtField.text.length <= 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Empty Base URL" message:@"You must provide base URL in order to connect with web server!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if([[Reachability sharedManager] currentReachabilityStatus] == NotReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"You are not connected to the Internet. Please check your network connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    if(self.userNameTxtField.text.length > 0 && self.passwordTxtField.text.length > 0)
    {
        __weak OPServerLoginViewController *loginView = self;
        
        [self.userNameTxtField resignFirstResponder];
        [self.passwordTxtField resignFirstResponder];
        [self.baseURLTxtField resignFirstResponder];
        
        self.indicatorView = [LoadingIndicatorView showLoadingIndicatorInView:self.view withMessage:@""];
        
        [CompanyInfo signInUsingUsername:self.userNameTxtField.text andPassword:self.passwordTxtField.text withCompanyCode:self.baseURLTxtField.text withExecutionBlock:^(BOOL success, Response *response)
         {
             if(success)
             {
                 [NetworkConfig setBaseURL:self.baseURLTxtField.text];
                 [loginView finishedLoginWithResponse:response];
             }
             else
             {
                 [loginView errorAlertWithReason:response.failureMessage];
             }
         }
         ];
    }
}

- (void)finishedLoginWithResponse:(Response *)response
{
    NSLog(@"Login Response: %@", response.responseString);
    [NetworkConfig setUserName:self.userNameTxtField.text withPassword:self.passwordTxtField.text];    
    NSString *failedReason = [response.responseString contentForTag:@"RestInfo"];
    [LoadingIndicatorView removeLoadingIndicator:self.indicatorView];
    if(failedReason == nil)
    {
        CompanyInfo *comp = (CompanyInfo *)[CompanyInfo parseXml:response.responseData];
        comp.companyCode = self.baseURLTxtField.text;
        
        if(comp && comp.companyName)
        {
            [[EXAppDelegate sharedAppDelegate] storeCompany:comp];
            
            [[EXAppDelegate sharedAppDelegate] storeUser:comp.user];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishDownloadingInitialData:) name:kDidFinishActiveNetworkOperations object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidFinishActiveNetworkOperations object:nil];
        }
        else
        {
            [self errorAlertWithReason:response.responseString];
        }
    }
    else
    {
        NSString *reason = [response.responseString contentForTag:@"RestInfo"];
        [self errorAlertWithReason:reason];
    }
}


- (void)errorAlertWithReason:(NSString *)reason
{
    [self removeIndicatorView];
    [LoadingIndicatorView removeLoadingIndicator:self.indicatorView];
    NSString *title = @"Invalid user name or password";
    NSString *msg = @"Please retry.";
    
    if([reason isEqualToString:@"The request timed out."])
    {
        title = @"Connection error";
        msg = @"Please check you network connection";
    }
    else if([reason isEqualToString:@"No Data"])
    {
        title = @"No Data";
        msg = @"No data found for this credential, please enter valid credentials!";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alertView show];
}


#pragma mark Indicator View
#pragma mark -

- (void)showIndicatorView:(NSString *)message
{
    if(!self.indicatorView)
    {
        LoadingIndicatorView *lvc = [[LoadingIndicatorView alloc] initWithFrame:CGRectZero];
        self.indicatorView = lvc;
        
        self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        
        [self.indicatorView setCenter:CGPointMake(self.view.bounds.size.width/2-10,(self.view.bounds.size.height/2 - 60))];
        [self.view addSubview:self.indicatorView];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    
    [self.indicatorView updateStatusMessage:message];
}

- (void)removeIndicatorView
{
    if(self.indicatorView)
        [self.indicatorView removeFromSuperview];
    self.indicatorView = nil;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

#pragma mark - Notifications

- (void)didFinishDownloadingInitialData:(NSNotification *)notification
{
    [self removeIndicatorView];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidFinishActiveNetworkOperations object:nil];
}

@end
