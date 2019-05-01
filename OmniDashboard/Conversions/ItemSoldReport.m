//
//  ItemSoldReport.m
//  ExTunes
//
//  Created by Kumar Sharma on 25/07/13.
//  Copyright (c) 2013 OmniSyems. All rights reserved.
//

#import "ItemSoldReport.h"
#import "NSObject+PropertySupport.h"
#import "SubCategory.h"

@implementation ItemSoldReport
@synthesize subCategories = _subCategories;

#pragma mark - Xml

- (void)setSubCategories:(NSMutableArray *)subCategories{
    
    if([subCategories isKindOfClass:[NSArray class]]){
        
        _subCategories = subCategories;
    }
}

- (NSString *)xmlRepresentation
{
    NSMutableString *xmlString = [NSMutableString string];
    
    [xmlString appendFormat:@"<categories>\n"];
    
    int catsCount = 0;
    for(SubCategory *subCat in self.subCategories)
    {
        NSString *xml = [subCat xmlRepresentation];
        if(nil != xml)
        {
            [xmlString appendFormat:@"%@", xml];
            catsCount++;
        }
    }
    [xmlString appendFormat:@"</categories>\n"];
    
    if(0 == catsCount)
        return nil;
    
    return xmlString;
}


+ (NSDictionary *)mappingsFromObjectToXML
{
    NSArray *objects = [NSArray arrayWithObjects:@"subCategories", NSStringFromClass(self), nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"subCategories", @"ItemSoldReport", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableDictionary *p_mappings = [NSMutableDictionary dictionaryWithDictionary:[SubCategory mappingsFromObjectToXML]];    
    [p_mappings addEntriesFromDictionary:mappings];
    
    return p_mappings;
}

+ (NSDictionary *)dataTypesForProperties
{
    NSArray *objects = [NSArray arrayWithObjects: @"array", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"subCategories", nil];
    
    NSDictionary *mappings = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableDictionary *p_mappings = [NSMutableDictionary dictionaryWithDictionary:[SubCategory dataTypesForProperties]];
    [p_mappings addEntriesFromDictionary:mappings];
    
    return p_mappings;
}

+ (NSDictionary *)classMappings
{
    NSDictionary *propertyAndTypes = [self propertyNamesAndTypes];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    
    [mappings setValue:NSStringFromClass(self) forKey:NSStringFromClass(self)];
    [mappings addEntriesFromDictionary:propertyAndTypes];
    
    NSMutableDictionary *p_mappings = [NSMutableDictionary dictionaryWithDictionary:[SubCategory classMappings]];
    [p_mappings addEntriesFromDictionary:mappings];
    
    return p_mappings;
}

@end
