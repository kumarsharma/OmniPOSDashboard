//
//  OPViewController.m
//  omniPOS
//
//  Created by Kumar Sharma on 10/02/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import "OPViewController.h"
#import "ODSettingsTableViewController.h"

@interface OPViewController ()

@end

@implementation OPViewController
@synthesize topBarView = topBarView_;
@synthesize logoImageView = logoImageView_;
@synthesize versionLabel = versionLabel_;
@synthesize viewTitleLabel;
@synthesize backButton, settingsBtn;

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


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showTitle
{
    if(nil == self.viewTitleLabel)
    {
        UILabel *lbl = [[UILabel alloc] init];
        CGRect lframe = CGRectMake(0, 21, self.view.frame.size.width, 21);
        lbl.font = [UIFont systemFontOfSize:17];
        lbl.frame = lframe;
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.adjustsFontSizeToFitWidth = YES;
        self.viewTitleLabel = lbl;
        [self.topBarView addSubview:lbl];
    }
}

- (void)needBackButton
{
    if(!self.backButton)
    {
        UIButton *backOrMainMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        backOrMainMenu.frame = CGRectMake(1, 19, 61, 23);
        [backOrMainMenu setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backOrMainMenu setBackgroundImage:[UIImage imageNamed:@"back_hl"] forState:UIControlStateHighlighted];
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
        userBtn.frame = CGRectMake(self.topBarView.frame.size.width-35, 19, 29, 23);
        [userBtn setBackgroundImage:[UIImage imageNamed:@"settings2"] forState:UIControlStateNormal];
        [userBtn setBackgroundImage:[UIImage imageNamed:@"settings2_hl"] forState:UIControlStateHighlighted];
        [self.topBarView addSubview:userBtn];
        self.settingsBtn = userBtn;
        [userBtn addTarget:self action:@selector(settingsAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)settingsAction
{
    ODSettingsTableViewController *setVc = [[ODSettingsTableViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
}

#pragma mark - 

- (void)initializeSubViews
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height-65)];
    UIImageView *lImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,0, 111, 23)];

    UIImageView *topBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    lImageView.image = [UIImage imageNamed:@"omnipos_logo"];
    UIView *tView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44)];
    self.view.backgroundColor = [UIColor darkGrayColor];
    bgImageView.image = [UIImage imageNamed:@"bg_iphone"];
    topBgImageView.image = [UIImage imageNamed:@"bg_line_iphone"];
    tView.backgroundColor = [UIColor lightTextColor];
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
