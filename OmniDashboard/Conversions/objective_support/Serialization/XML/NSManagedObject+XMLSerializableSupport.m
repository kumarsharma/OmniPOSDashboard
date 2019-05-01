//
//  NSManagedObject+XMLSerializableSupport.m
//  TestSerialize
//
//  Created by Kumar Sharma on 20/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "NSManagedObject+XMLSerializableSupport.h"
#import "NSObject+XMLSerializableSupport.h"
#import "NSDictionary+XMLSerializableSupport.h"
#import "CoreSupport.h"
#import "FromXMLElementDelegate.h"
#import "OPRemoteXMLParserDelegate.h"

@implementation NSManagedObject (XMLSerializableSupport)

# pragma mark XML utility methods

/**
 * Get the appropriate xml type, if any, for the given value.
 * I.e. "integer" or "decimal" etc... for use in element attributes:
 *
 *   <element-name type="integer">1</element-name>
 */
+ (NSString *)xmlTypeFor:(NSObject *)value {
	
	// Can't do this with NSDictionary w/ Class keys.  Explore more elegant solutions.
	// TODO: Account for NSValue native types here?
	if ([value isKindOfClass:[NSDate class]]) {
		return @"datetime";
	} else if ([value isKindOfClass:[NSDecimalNumber class]]) {
		return @"decimal";
	} else if ([value isKindOfClass:[NSNumber class]]) {
		if (0 == strcmp("f",[(NSNumber *)value objCType]) ||
			0 == strcmp("d",[(NSNumber *)value objCType])) 
		{
			return @"decimal";
		}
		else {
			return @"integer";
		}
	} else if ([value isKindOfClass:[NSArray class]]) {
		return @"array";
	} else {
		return nil;
	}
}

+ (NSString *)buildXmlElementAs:(NSString *)rootName withInnerXml:(NSString *)value andType:(NSString *)xmlType{
	NSString *dashedName = [rootName dasherize];
	
	if (xmlType != nil) {
		return [NSString stringWithFormat:@"<%@ type=\"%@\">%@</%@>", dashedName, xmlType, value, dashedName];
	} else {
		return [NSString stringWithFormat:@"<%@>%@</%@>", dashedName, value, dashedName];
	}	
}

+ (NSString *)buildXmlElementAs:(NSString *)rootName withInnerXml:(NSString *)value {
	return [[self class] buildXmlElementAs:rootName withInnerXml:value andType:nil];
}

+ (NSString *)buildXMLElementAs:(NSString *)rootName withValue:(NSObject *)value {
	return [[self class] buildXmlElementAs:rootName withInnerXml:[value toXMLValue] andType:[self xmlTypeFor:value]];
}

+ (NSString *)xmlElementName {
	NSString *className = NSStringFromClass(self);
    NSString *elementName = [[className stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[className substringToIndex:1] lowercaseString]] dasherize];
	return elementName;
}

# pragma mark XMLSerializable implementation methods

- (NSString *)toXMLElement {
	return [self toXMLElementAs:[[self class] xmlElementName] excludingInArray:[NSArray array] withTranslations:[NSDictionary dictionary]];
}

- (NSString *)toXMLElementExcluding:(NSArray *)exclusions {
	return [self toXMLElementAs:[[self class] xmlElementName] excludingInArray:exclusions withTranslations:[NSDictionary dictionary]];  
}

- (NSString *)toXMLElementAs:(NSString *)rootName {
	return [self toXMLElementAs:rootName excludingInArray:[NSArray array] withTranslations:[NSDictionary dictionary]];
}

- (NSString *)toXMLElementAs:(NSString *)rootName excludingInArray:(NSArray *)exclusions {
	return [self toXMLElementAs:rootName excludingInArray:exclusions withTranslations:[NSDictionary dictionary]];
}

- (NSString *)toXMLElementAs:(NSString *)rootName withTranslations:(NSDictionary *)keyTranslations {
	return [self toXMLElementAs:rootName excludingInArray:[NSArray array] withTranslations:keyTranslations];
}

/**
 * Override in complex objects to account for nested properties
 **/
- (NSString *)toXMLElementAs:(NSString *)rootName excludingInArray:(NSArray *)exclusions
			withTranslations:(NSDictionary *)keyTranslations {
	return [[self properties] toXMLElementAs:rootName excludingInArray:exclusions withTranslations:keyTranslations andType:[[self class] xmlTypeFor:self]];
}

# pragma mark XML Serialization convenience methods

/**
 * Override in objects that need special formatting before being printed to XML
 **/
- (NSString *)toXMLValue {
	return [NSString stringWithFormat:@"%@", self];
}

# pragma mark XML Serialization input methods

+ (id)fromXMLData:(NSData *)data {
	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	FromXMLElementDelegate *delegate = [FromXMLElementDelegate delegateForClass:self];
    [parser setDelegate:delegate];
	
    // Turn off all those XML nits
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
	// Let'er rip
    [parser parse];
	return delegate.parsedObject;
}

+ (id)fromXMLData:(NSData *)data mappings:(NSDictionary*)inMappings dataTypes:(NSDictionary*)inDataTypes classMappings:(NSDictionary *)inClassMappings
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];    
  	OPRemoteXMLParserDelegate *delegate = [OPRemoteXMLParserDelegate delegateForClass:self mappings:inMappings dataTypes:inDataTypes classMappings:inClassMappings];
    [parser setDelegate:delegate];
	
    // Turn off all those XML nits
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
	// Let'er rip
    [parser parse];
	return delegate.parsedObject;
}

+ (NSArray *)allFromXMLData:(NSData *)data {
	return [self fromXMLData:data];
}
@end

