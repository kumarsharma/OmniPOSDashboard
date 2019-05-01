//
//  OPManagedObjectHolder.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 24/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "OPManagedObjectHolder.h"
#import "NSObject+XMLSerializableSupport.h"

@implementation OPManagedObjectHolder
@synthesize availableObjects = availableObjects_;

+(NSString *)primaryKeyAttrName
{
    return nil;
}

+ (OPManagedObjectHolder *)parseXml:(NSData *)xmlData
{
    OPManagedObjectHolder *objectHolder =  (OPManagedObjectHolder *)[self fromXMLData:xmlData mappings:[self mappingsFromObjectToXML] dataTypes:[self dataTypesForProperties] classMappings:[self classMappings]];
    
    return objectHolder;
}

+ (NSDictionary *)mappingsFromObjectToXML
{
    return nil;
}

+ (NSDictionary *)dataTypesForProperties
{
    return nil;     
}

+ (NSDictionary *)classMappings
{
    return nil;
}




#pragma mark Parsing

+ (OPManagedObjectHolder *)parseXml:(NSData *)xmlData rootElementName:(NSString *)rootElementName objectHoldersElementName:(NSString *)objectHoldersElName targetClassName:(NSString *)className
{
    NSDictionary *mappings = [self objectToXMLMappingForClassName:className availObjectsElementName:objectHoldersElName];
    NSDictionary *dataTypes = [self dataTypesForPropertiesForClassName:className availObjectsElementName:objectHoldersElName];
    NSDictionary *classMappings = [self classMappingsForClassName:className rootClassElementName:rootElementName];
    
    OPManagedObjectHolder *objectHolder =  (OPManagedObjectHolder *)[self fromXMLData:xmlData mappings:mappings dataTypes:dataTypes classMappings:classMappings];
    
    return objectHolder;
}

+ (NSDictionary *)objectToXMLMappingForClassName:(NSString *)targetMOClassName availObjectsElementName:(NSString *)objectsElementName
{
    Class targetClass = NSClassFromString(targetMOClassName);
    NSDictionary *mappingsForResTable = [targetClass mappingsFromObjectToXML];
    
    NSArray *objects = [NSArray arrayWithObjects:@"availableObjects", nil];
    
    NSArray *keys = [NSArray arrayWithObjects:objectsElementName, nil];
    
    NSMutableDictionary *mappings = [NSMutableDictionary dictionaryWithObjects:objects forKeys:keys];
    [mappings addEntriesFromDictionary:mappingsForResTable];
    
    return mappings;
}

+ (NSDictionary *)dataTypesForPropertiesForClassName:(NSString *)targetMOClassName availObjectsElementName:(NSString *)objectsElementName
{
    //    AvailableTable *anObject = [[AvailableTable alloc] init];
    Class targetClass = NSClassFromString(targetMOClassName);
    NSMutableDictionary *dataTypes = [NSMutableDictionary dictionary];
    [dataTypes setValue:@"array" forKey:objectsElementName];
    [dataTypes addEntriesFromDictionary:[targetClass dataTypesForProperties]];
    
    return dataTypes;
}

+ (NSDictionary *)classMappingsForClassName:(NSString *)targetMOClassName rootClassElementName:(NSString *)rootElementName
{
    Class targetClass = NSClassFromString(targetMOClassName);
    NSDictionary *classMappingsFromResTable = [targetClass classMappings];
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary] ;//]WithObject:NSStringFromClass(self) forKey:rootElementName];
    [mappings addEntriesFromDictionary:classMappingsFromResTable];
    
    return mappings;
}

@end
