

#import "OPRemoteXMLParserDelegate.h"
#import "XMLSerializableSupport.h"
#import "OPManagedObjectHolder.h"

@implementation OPRemoteXMLParserDelegate
@synthesize unclosedElements;
@synthesize targetClass;
@synthesize parsedObject = parsedObject_;
@synthesize currentPropertyName = currentPropertyName_;
@synthesize contentOfCurrentProperty = contentOfCurrentProperty_;
@synthesize mappings = mappings_, dataTypes = dataTypes_, classMappings = classMappings_;

+ (OPRemoteXMLParserDelegate *)delegateForClass:(Class)targetClass mappings:(NSDictionary*)inMappings dataTypes:(NSDictionary*)inDataTypes classMappings:(NSDictionary *)inClassMappings
{
    OPRemoteXMLParserDelegate *delegate = [[self alloc] init];
    delegate.targetClass = targetClass;
    delegate.mappings = inMappings;
    delegate.dataTypes = inDataTypes;
    delegate.classMappings = inClassMappings;
    return delegate;
}

- (id)init
{
    self = [super init];
    self.unclosedElements = [NSMutableArray array];
    return self;
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
	
}		
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Parser error: %@", [parseError description]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if(self.unclosedElements.count == 0)
    {
        self.parsedObject = [[self.targetClass alloc] init];
        
        [self.unclosedElements addObject:[NSDictionary dictionaryWithObject:self.parsedObject forKey:elementName]];
        
        if([self.targetClass isSubclassOfClass:[OPManagedObjectHolder class]])
        {
            NSMutableArray *propertyValue = [NSMutableArray array];
            [self.unclosedElements addObject:[NSDictionary dictionaryWithObject:propertyValue forKey:elementName]];
        }
    }
    else if([[self.dataTypes valueForKey:elementName] isEqualToString:@"array"])
    {
        NSMutableArray *propertyValue = [NSMutableArray array];
        
        [self.unclosedElements addObject:[NSDictionary dictionaryWithObject:propertyValue forKey:elementName]];
    }
    else
    {
        NSString *classAsString = [self.mappings valueForKey:elementName];
        classAsString =  ([self.classMappings valueForKey:classAsString] != nil ? [self.classMappings valueForKey:classAsString] : [self.classMappings valueForKey:elementName]);
        Class elementClass = NSClassFromString(classAsString);

        id anObject = [[elementClass alloc] init];
        if(!anObject)
            anObject = [[NSString alloc] init];
        [self.unclosedElements addObject:[NSDictionary dictionaryWithObject:anObject forKey:elementName]];
        
        self.contentOfCurrentProperty = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName     
{	
    NSDictionary *lastElement = [self.unclosedElements lastObject];
    
    if(self.contentOfCurrentProperty.length > 0)
    {
        id value = [self convertProperty:self.contentOfCurrentProperty toType:[self.dataTypes valueForKey:elementName]];
        
        [self.unclosedElements removeObject:lastElement];
        NSDictionary *prevElement = [self.unclosedElements lastObject];
        NSString *prevElementName = [[prevElement allKeys] objectAtIndex:0];
        
        if([[prevElement valueForKey:prevElementName] isKindOfClass:[NSArray class]])
        {
            if(value)
                [((NSMutableArray*)[prevElement valueForKey:prevElementName]) addObject:value];
        }
        else
        {
            if(nil != [self.mappings valueForKey:elementName] && nil != value)
                [[prevElement valueForKey:prevElementName] setValue:value forKey:[self.mappings valueForKey:elementName]];
        }
    }
    else
    {
        [self.unclosedElements removeObject:lastElement];
        NSDictionary *prevElement = [self.unclosedElements lastObject];
        NSString *prevElementName = [[prevElement allKeys] objectAtIndex:0];
        
        NSString *lastElementName = [[lastElement allKeys] objectAtIndex:0];
        
        if(prevElement != nil)
        {
            if([[prevElement valueForKey:prevElementName] isKindOfClass:[NSArray class]])
            {
                [((NSMutableArray*)[prevElement valueForKey:prevElementName]) addObject:[lastElement valueForKey:lastElementName]];
            }
            else
            {
                NSObject *nextHolder = [prevElement valueForKey:prevElementName];
                NSObject *nextParsedObject = [lastElement valueForKey:lastElementName];
                NSString *objectKey = [self.mappings valueForKey:elementName];
                
                @try {
                    
                    if([nextHolder isKindOfClass:[NSMutableArray class]])
                        [((NSMutableArray *)nextHolder)  addObject:nextParsedObject];
                    else
                        [nextHolder setValue:nextParsedObject forKey:objectKey];
                }
                @catch (NSException *exception) {
                    
                }
            }
        }
    }
    
    self.contentOfCurrentProperty = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(self.contentOfCurrentProperty)
		[self.contentOfCurrentProperty appendString:string];
    
}

//Basic type conversion based on the ObjectiveResource "type" attribute
- (id) convertProperty:(NSString *)propertyValue toType:(NSString *)type 
{    
	if ([type isEqualToString:@"datetime" ]) {
		return [NSDate fromXMLDateTimeString:propertyValue];
	}
	else if ([type isEqualToString:@"date"]) {
		return [NSDate fromXMLDateString:propertyValue];
	}
	
	// uncomment this if you what to support NSNumber and NSDecimalNumber
	// if you do your classId must be a NSNumber since rails will pass it as such
	else if ([type isEqualToString:@"decimal"]) {
		return [NSDecimalNumber decimalNumberWithString:propertyValue];
	}
	else if ([type isEqualToString:@"integer"]) {
		return [NSNumber numberWithInt:[propertyValue intValue]];
	}
	else if ([type isEqualToString:@"boolean"]) {
        
        BOOL b = false;
        
        if([[propertyValue lowercaseString] isEqualToString:@"true"] || [[propertyValue lowercaseString] isEqualToString:@"True"] || [propertyValue isEqualToString:@"1"])
            b = true;
        else if([[propertyValue lowercaseString] isEqualToString:@"false"] || [[propertyValue lowercaseString] isEqualToString:@"False"] || [propertyValue isEqualToString:@"0"])
            b = NO;
        
        return [NSNumber numberWithBool:b];
	}
	
	else if ([type isEqualToString:@"float"]) {
		return [NSNumber numberWithFloat:[propertyValue floatValue]];
	}
	
	else {
		return [NSString fromXmlString:propertyValue];
	}
}


@end
