//
//  ItemSoldReport.h
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemSoldReport : NSObject
{
    NSMutableArray *_subCategories;
}

@property (nonatomic, strong) NSMutableArray *subCategories;

+ (NSDictionary *)mappingsFromObjectToXML;
+ (NSDictionary *)dataTypesForProperties;
+ (NSDictionary *)classMappings;

- (NSString *)xmlRepresentation;
@end
