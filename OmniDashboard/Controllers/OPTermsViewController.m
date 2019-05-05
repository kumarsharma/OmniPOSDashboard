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
    self.viewTitleLabel.text = self.title;
    
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.topBarView.frame.size.height+self.topBarView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-self.topBarView.frame.size.height)];
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
