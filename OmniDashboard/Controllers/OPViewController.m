//
//  OPViewController.m
//  omniPOS
//
//  Created by Kumar Sharma on 10/02/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "OPViewController.h"
#import "OPSettingsViewController.h"

@interface OPViewController ()

@end

@implementation OPViewController
@synthesize topBarView = topBarView_;
@synthesize logoImageView = logoImageView_;
@synthesize versionLabel = versionLabel_;
@synthesize viewTitleLabel;
@synthesize backButton, settingsBtn, doneBtn, cancelBtn;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeSubViews];
    [self setNeedsStatusBarAppearanceUpdate];
    [self showTitle];
    self.navigationController.navigationBarHidden = YES;
    
    if(self.navigationController.viewControllers.count==1)
        [self needSettingsButton];
    else
        [self needBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)hideBackButton
{
    self.backButton.hidden = YES;
}

- (void)hideSettingsButton
{
    self.settingsBtn.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showTitle
{
    if(nil == self.viewTitleLabel)
    {
        UILabel *lbl = [[UILabel alloc] init];
        CGRect lframe = CGRectMake(35, 18, 245, 27);
        lbl.font = [UIFont boldSystemFontOfSize:15];
        lbl.frame = lframe;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
//        lbl.adjustsFontSizeToFitWidth = YES;
        self.viewTitleLabel = lbl;
        [self.topBarView addSubview:lbl];
    }
}

- (void)needBackButton
{
    if(!self.backButton)
    {
        UIButton *backOrMainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        backOrMainMenu.frame = CGRectMake(5, 20, 25, 22);
        [backOrMainMenu setBackgroundImage:[UIImage imageNamed:@"back_iphone_hl"] forState:UIControlStateNormal];
        [backOrMainMenu setBackgroundImage:[UIImage imageNamed:@"back_iphone"] forState:UIControlStateHighlighted];
        [self.topBarView addSubview:backOrMainMenu];
        self.backButton = backOrMainMenu;
        [backOrMainMenu addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)needSettingsButton
{
    if(!self.settingsBtn)
    {
        UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        userBtn.frame = CGRectMake(self.topBarView.frame.size.width-35, 20, 25, 22);
        [userBtn setBackgroundImage:[UIImage imageNamed:@"settings2_hl"] forState:UIControlStateNormal];
        [userBtn setBackgroundImage:[UIImage imageNamed:@"settings2"] forState:UIControlStateHighlighted];
        [self.topBarView addSubview:userBtn];
        self.settingsBtn = userBtn;
        [userBtn addTarget:self action:@selector(settingsAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)needDoneButton
{
    if(!self.doneBtn)
    {
        UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        userBtn.frame = CGRectMake(self.topBarView.frame.size.width-35, 20, 25, 22);
        [userBtn setBackgroundImage:[UIImage imageNamed:@"done_iphone_hl"] forState:UIControlStateNormal];
        [userBtn setBackgroundImage:[UIImage imageNamed:@"done_iphone"] forState:UIControlStateHighlighted];
        [self.topBarView addSubview:userBtn];
        self.doneBtn = userBtn;
//        [userBtn addTarget:self action:@selector(settingsAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)needCancelButton
{
    if(!self.cancelBtn)
    {
        UIButton *userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        userBtn.frame = CGRectMake(5, 20, 25, 22);
        [userBtn setBackgroundImage:[UIImage imageNamed:@"cancel_iphone_hl"] forState:UIControlStateNormal];
        [userBtn setBackgroundImage:[UIImage imageNamed:@"cancel_iphone"] forState:UIControlStateHighlighted];
        [self.topBarView addSubview:userBtn];
        self.cancelBtn = userBtn;
        [userBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)backAction
{
    if(self.navigationController.viewControllers.count>1)   
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)settingsAction
{
    OPSettingsViewController *setVc = [[OPSettingsViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

#pragma mark - 

- (void)initializeSubViews
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height-65)];
    UIImageView *lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,-5, 75, 33)];
    UIImageView *topBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    lImageView.image = [UIImage imageNamed:@"omnipos_logo"];
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    self.view.backgroundColor = [UIColor darkGrayColor];
    bgImageView.image = [UIImage imageNamed:@"bg_iphone"];
    topBgImageView.image = [UIImage imageNamed:@"bg_line_iphone"];
    tView.backgroundColor = [UIColor darkGrayColor];
    self.backImageView = bgImageView;
    self.topBarView = tView;
    self.logoImageView = lImageView;
    [tView addSubview:topBgImageView];
    [tView addSubview:self.logoImageView];
    [self.view addSubview:bgImageView];
    [self.view addSubview:self.topBarView];
}


- (float)topBarYorigin
{
    return self.topBarView.frame.size.height+self.topBarView.frame.origin.y+1;
}

- (float)yOriginFromView:(UIView *)view
{
    return view.frame.size.height+view.frame.origin.y;
}

- (void)addDarkLineOnView:(UIView *)view withFrame:(CGRect)frame
{
    UILabel *lineLbl = [[UILabel alloc] initWithFrame:frame];
    lineLbl.backgroundColor = [UIColor darkGrayColor];
    [view addSubview:lineLbl];
}

@end
