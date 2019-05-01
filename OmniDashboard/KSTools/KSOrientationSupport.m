//
//  OPOrientationSupport.m
//  omniPOS
//
//  Created by Kumar Sharma on 14/07/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "KSOrientationSupport.h"

@implementation KSOrientationSupport

+ (BOOL)shouldSupportInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    else
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

@end
