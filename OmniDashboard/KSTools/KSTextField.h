//
//  KSTextField.h
//  ExTunes
//
//  Created by Kumar Sharma on 26/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSTextField : UITextField
{
    NSIndexPath *_tagIndexPath;
}

@property (nonatomic, strong) NSIndexPath *tagIndexPath;
@end
