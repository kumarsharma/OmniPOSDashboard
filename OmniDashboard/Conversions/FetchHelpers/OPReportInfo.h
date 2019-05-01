//
//  OPReportInfo.h
//  omniPOS
//
//  Created by Kumar Sharma on 11/04/13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OPReportInfo : NSObject
{
    NSString *objId, *name;
    float amount, cashSale, cardSale, voucherSale;
}

@property (nonatomic, strong) NSString *objId, *name;
@property (nonatomic, assign) float amount, cashSale, cardSale, voucherSale;

+ (NSDictionary *)mappingsFromObjectToXML;
+ (NSDictionary *)dataTypesForProperties;
+ (NSDictionary *)classMappings;
@end
