//
//  EXAppDelegate.h
//  ExTunes
//
//  Created by Kumar Sharma on 13/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RestaurantInfo;
@class UserInfo, CompanyInfo;
@interface EXAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSString *currentRestaurantId, *currentCompanyCode, *selectedLocationName;
@property (nonatomic, strong) RestaurantInfo *restaurant;
@property (nonatomic, strong) CompanyInfo *company;
@property (nonatomic, strong) UserInfo *user;
@property (nonatomic, assign) BOOL isUserLoggedIn;


+ (EXAppDelegate *)sharedAppDelegate;
- (BOOL)hasRestaurantObject;
- (void)storeRestaurant:(RestaurantInfo *)rest;
- (BOOL)hasUserObject;
- (void)storeUser:(UserInfo *)usr;
- (void)logoutUser;
- (BOOL)hasCompanyObject;
- (void)storeCompany:(CompanyInfo *)c;
- (NSString *)storedLoginPIN;
- (void)storeLoginPIN:(NSString *)pin;
@end
