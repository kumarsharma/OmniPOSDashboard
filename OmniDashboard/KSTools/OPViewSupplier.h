//
//  OPViewSupplier.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 01/05/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OPViewSupplier : NSObject

+ (UIView *)footerViewForApp;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIButton *)footerButton;
@end
