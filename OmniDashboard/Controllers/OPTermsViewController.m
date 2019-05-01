//
//  OPTermsViewController.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 29/04/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPTermsViewController.h"

@interface OPTermsViewController ()

@end

@implementation OPTermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Terms & Conditions";
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.omniposweb.com/terms"]]];
    [self.view addSubview:webview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
