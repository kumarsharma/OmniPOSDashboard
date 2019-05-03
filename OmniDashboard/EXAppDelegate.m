//
//  EXAppDelegate.m
//  ExTunes
//
//  Created by Kumar Sharma on 13/05/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "EXAppDelegate.h"
#import "KSObjectStore.h"
#import "RestaurantInfo.h"
#import "CompanyInfo.h"

@implementation EXAppDelegate
@synthesize currentRestaurantId;
@synthesize restaurant;
@synthesize user;
@synthesize isUserLoggedIn;
@synthesize company;
@synthesize currentCompanyCode;
@synthesize selectedLocationName;

+ (EXAppDelegate *)sharedAppDelegate
{
    return (EXAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIToolbar appearance] setTintColor:[UIColor whiteColor]];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self logoutUser];
}

- (void)logoutUser
{
    if(self.isUserLoggedIn)
    {
        self.isUserLoggedIn = NO;
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Store Object

- (BOOL)hasRestaurantObject
{
    RestaurantInfo *rest = [KSObjectStore getStoredObjectForKey:kRestaurantObject];
   if(rest)
   {
       self.currentRestaurantId = rest.restaurantId;
       self.restaurant = rest;
       return YES;
   }
    
    return NO;
}

- (void)storeRestaurant:(RestaurantInfo *)rest
{
    [KSObjectStore storeObject:rest forKey:kRestaurantObject];
}

- (BOOL)hasCompanyObject
{
    CompanyInfo *c = [KSObjectStore getStoredObjectForKey:kCompanyObject];
    if(c)
    {
        self.company = c;
        return YES;
    }
    
    return NO;
}

- (void)storeCompany:(CompanyInfo *)c
{
    [KSObjectStore storeObject:c forKey:kCompanyObject];
}

- (BOOL)hasUserObject
{
    UserInfo *usr = [KSObjectStore getStoredObjectForKey:kUserObject];
    if(usr)
    {
        self.user = usr;
        return YES;
    }
    
    return NO;
}

- (void)storeUser:(UserInfo *)usr
{
    [KSObjectStore storeObject:usr forKey:kUserObject];
}

- (NSString *)storedLoginPIN
{
    
    NSString *pin = [KSObjectStore getStoredObjectForKey:kLoginPIN];
    return pin;
}

- (void)storeLoginPIN:(NSString *)pin
{
    
    [KSObjectStore storeObject:pin forKey:kLoginPIN];
}

@end
