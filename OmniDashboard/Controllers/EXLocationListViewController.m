//
//  EXLocationListViewController.m
//  ExTunes
//
//  Created by Kumar Sharma on 08/04/14.
//  Copyright (c) 2014 OmniSyems. All rights reserved.
//

#import "EXLocationListViewController.h"
#import "CompanyInfo.h"
#import "RestaurantInfo.h"
#import "EXMenuViewController.h"
#import "ODSettingsTableViewController.h"

@interface EXLocationListViewController ()

@end

@implementation EXLocationListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Locations";
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor darkGrayColor];
    versionLabel.text = @"Omni Dashboard. Version 1.1";
    self.tableView.tableFooterView = versionLabel;
    
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user4"] style:UIBarButtonItemStyleDone target:self action:@selector(settingsAction)];
    self.navigationItem.rightBarButtonItem = settingsBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Locations";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)settingsAction
{
    ODSettingsTableViewController *setVc = [[ODSettingsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:setVc];
//    [self presentViewController:navController animated:YES completion:nil];
    [self.navigationController pushViewController:setVc animated:YES];
}

- (void)logoutBtnAction
{
    [[EXAppDelegate sharedAppDelegate] logoutUser];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    EXAppDelegate *app = [EXAppDelegate sharedAppDelegate];
    return app.company.allLocations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    EXAppDelegate *app = [EXAppDelegate sharedAppDelegate];
    RestaurantInfo *r = [app.company.allLocations objectAtIndex:indexPath.row];
    cell.textLabel.text = r.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EXAppDelegate *app = [EXAppDelegate sharedAppDelegate];
    RestaurantInfo *r = [app.company.allLocations objectAtIndex:indexPath.row];
    app.currentRestaurantId = r.restaurantId;
    app.restaurant = r;
    app.selectedLocationName = r.name;
    
    EXMenuViewController *mc = [[EXMenuViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.navigationController.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:mc animated:YES];
}

@end
