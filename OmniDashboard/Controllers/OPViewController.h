//
//  OPViewController.h
//  omniPOS
//
//  Created by Kumar Sharma on 10/02/16.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OPViewController : UIViewController
{
    UIView *topBarView_;
    UIImageView *logoImageView_, *backImageView_;
    UILabel *versionLabel_;
    BOOL hasNavigatedFromLogin_;
}

@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIImageView *logoImageView, *backImageView;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *viewTitleLabel;
@property (nonatomic, strong) UIButton *backButton, *settingsBtn, *doneBtn, *cancelBtn;

- (float)topBarYorigin;
- (float)yOriginFromView:(UIView *)view;
- (void)addDarkLineOnView:(UIView *)view withFrame:(CGRect)frame;
- (void)needSettingsButton;
- (void)needBackButton;
- (void)hideSettingsButton;
- (void)hideBackButton;
- (void)needDoneButton;
- (void)needCancelButton;
@end
