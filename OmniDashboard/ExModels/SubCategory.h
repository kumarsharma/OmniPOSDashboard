//
//  SubCategory.h
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategory : NSObject
{
    NSString *sub_cat_id, *sub_cat_name;
    NSMutableArray *products;
    
    float _totalSold, _adjustedSale, total_amount;
}

@property (nonatomic, strong) NSString *sub_cat_id, *sub_cat_name;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, assign) float totalSold, adjustedSale, total_amount;

+ (NSDictionary *)mappingsFromObjectToXML;
+ (NSDictionary *)dataTypesForProperties;
+ (NSDictionary *)classMappings;

- (NSString *)xmlRepresentation;
- (float)adjustedSaleForGST;
@end
