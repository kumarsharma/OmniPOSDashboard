//
//  OPViewSupplier.m
//  OmniDashboard
//
//  Created by Kumar Sharma on 01/05/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import "OPViewSupplier.h"

@implementation OPViewSupplier

+ (UIView *)footerViewForApp{
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 170, 100, 44)];
    imgView.image = [UIImage imageNamed:@"omnipos_logo"];
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor blackColor];
    versionLabel.text = [NSString stringWithFormat:@"OmniPOS Dashboard. Version %@ (%@)", version, build];
    versionLabel.font = [UIFont italicSystemFontOfSize:12];
    
//    [footerView addSubview:imgView];
    [footerView addSubview:versionLabel];
    
    CGSize imageSize = imgView.image.size;
    [imgView sizeThatFits:imageSize];
    CGPoint imageViewCenter = imgView.center;
    imageViewCenter.x = CGRectGetMidX(footerView.frame);
    [imgView setCenter:imageViewCenter];
    
    return footerView;
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    noHashString = [noHashString stringByReplacingOccurrencesOfString:@"    " withString:@""];
    
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    UIColor *c = [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
    
    return c;
}

+ (UIButton *)footerButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 4, 217, 42);
    [btn setTitle:@"Submit" forState:UIControlStateNormal];    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btn.layer.cornerRadius = 2;
    btn.layer.borderColor = [[UIColor blackColor] CGColor];
    btn.layer.borderWidth = 0.1;
    [btn setBackgroundColor:[OPViewSupplier colorWithHexString:@"#98AFC7"]];
    return btn;
}
@end
