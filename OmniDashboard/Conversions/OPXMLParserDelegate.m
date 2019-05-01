

#import "OPXMLParserDelegate.h"
#import "XMLSerializableSupport.h"

@implementation OPXMLParserDelegate
@synthesize unclosedElements;
@synthesize targetClass;
@synthesize parsedObject = parsedObject_;
@synthesize currentPropertyName = currentPropertyName_;
@synthesize contentOfCurrentProperty = contentOfCurrentProperty_;
@synthesize mappings = mappings_, dataTypes = dataTypes_, classMappings = classMappings_;
@synthesize localManagedObjectContext = localManagedObjectContext_;

+ (OPXMLParserDelegate *)delegateForClass:(Class)targetClass mappings:(NSDictionary*)inMappings dataTypes:(NSDictionary*)inDataTypes classMappings:(NSDictionary *)inClassMappings
{
    OPXMLParserDelegate *delegate = [[self alloc] init];
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
        id po = [[self.targetClass alloc] init];
        self.parsedObject = po;
        
        [self.unclosedElements addObject:[NSDictionary dictionaryWithObject:self.parsedObject forKey:elementName]];
    }
    else if([[self.dataTypes valueForKey:elementName] isEqualToString:@"array"])
    {
        NSMutableArray *propertyValue = [NSMutableArray array];
        
        [self.unclosedElements addObject:[NSDictionary dictionaryWithObject:propertyValue forKey:elementName]];
    }
    else if([[self.dataTypes valueForKey:elementName] isEqualToString:@"set"])
    {
        NSMutableSet *propertyValue = [NSMutableSet set];
        
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
            [((NSMutableArray*)[prevElement valueForKey:prevElementName]) addObject:value];
        }
        else if([[prevElement valueForKey:prevElementName] isKindOfClass:[NSSet class]])
        {
            if(![value isKindOfClass:[NSString class]])
                [((NSMutableSet*)[prevElement valueForKey:prevElementName]) addObject:value];
        }
        else
        {
            id objectHolder = [prevElement valueForKey:prevElementName];
            
            if(nil != [self.mappings valueForKey:elementName] && nil != value && ![objectHolder isKindOfClass:[NSString class]])
            {
                [[prevElement valueForKey:prevElementName] setValue:value forKey:[self.mappings valueForKey:elementName]];
            }
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
            else if([[prevElement valueForKey:prevElementName] isKindOfClass:[NSSet class]])
            {
                if(![[lastElement valueForKey:lastElementName] isKindOfClass:[NSString class]]) 
                    [((NSMutableSet*)[prevElement valueForKey:prevElementName]) addObject:[lastElement valueForKey:lastElementName]];
            }
            else
            {
                id objectHolder = [prevElement valueForKey:prevElementName];

                if(nil != [self.mappings valueForKey:elementName] && nil != [lastElement valueForKey:lastElementName] && ![objectHolder isKindOfClass:[NSString class]])
                {
                    id objectValue = [lastElement valueForKey:lastElementName];
                    
                    if([objectValue isKindOfClass:[NSString class]])
                        objectValue = [self convertProperty:objectValue toType:[self.dataTypes valueForKey:elementName]];
                    
                    NSString *key = [self.mappings valueForKey:elementName];
                    
                    [objectHolder setValue:objectValue forKey:key];
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
    
//    NSLog(@"Found String: %@", string);
    
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
	else if ([type isEqualToString:@"boolean"]) 
    {
        if(!propertyValue || propertyValue.length <= 0)
            return [NSNumber numberWithBool:NO];
        else
            return [NSNumber numberWithBool:
				[[propertyValue lowercaseString] isEqualToString:@"true"] ||
				[propertyValue isEqualToString:@"1"]];
	}
	
	else if ([type isEqualToString:@"float"]) {
		return [NSNumber numberWithFloat:[propertyValue floatValue]];
	}
	
	else {
		return [NSString fromXmlString:propertyValue];
	}
}


@end
