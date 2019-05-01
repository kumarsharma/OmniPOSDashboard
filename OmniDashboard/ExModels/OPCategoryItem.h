//
//  OPCategoryItem.h
//  OmniDashboard
//
//  Created by Kumar Sharma on 01/05/19.
//  Copyright © 2019 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPCategoryItem : NSObject

@property (nonatomic, strong) NSString *uid, *name;
@property (nonatomic, assign) float amount, qty;
@end
