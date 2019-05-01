//
//  Product.h
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
{
    NSString *prod_id, *prod_name;
    float _qtyOriginal, _qtyAdjusted, unitPrice, totalPrice, adjustedPrice;
    float _lastAdjustedValue;
    BOOL _wasRowSelected;
    NSString *hasGST;
}

@property (nonatomic, strong) NSString *prod_id, *prod_name;
@property (nonatomic, assign) float qtyOriginal, qtyAdjusted, unitPrice, adjustedPrice, totalPrice;
@property (nonatomic, assign) BOOL wasRowSelected;
@property (nonatomic, assign) float lastAdjustedValue;
@property (nonatomic, strong) NSString *hasGST;

+ (NSDictionary *)mappingsFromObjectToXML;
+ (NSDictionary *)dataTypesForProperties;
+ (NSDictionary *)classMappings;

- (NSString *)xmlRepresentation;
- (float)adjustedPriceForGST;
@end
