//
//  OPManagedObjectHolder.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 24/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OPManagedObject;
@interface OPManagedObjectHolder : NSObject
{
    NSMutableArray *availableObjects_;
}

@property (nonatomic, strong) NSMutableArray *availableObjects;

+(NSString *)primaryKeyAttrName;
+ (OPManagedObjectHolder *)parseXml:(NSData *)xmlData;

+ (OPManagedObjectHolder *)parseXml:(NSData *)xmlData rootElementName:(NSString *)rootElementName objectHoldersElementName:(NSString *)objectHoldersElName targetClassName:(NSString *)className;
+ (NSDictionary *)mappingsFromObjectToXML;
+ (NSDictionary *)dataTypesForProperties;
+ (NSDictionary *)classMappings;

+ (NSDictionary *)objectToXMLMappingForClassName:(NSString *)targetMOClassName availObjectsElementName:(NSString *)objectsElementName;
+ (NSDictionary *)dataTypesForPropertiesForClassName:(NSString *)targetMOClassName availObjectsElementName:(NSString *)objectsElementName;

+ (NSDictionary *)classMappingsForClassName:(NSString *)targetMOClassName rootClassElementName:(NSString *)rootElementName; 

@end
