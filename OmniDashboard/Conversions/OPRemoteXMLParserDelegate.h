

#import <Foundation/Foundation.h>

@interface OPRemoteXMLParserDelegate : NSObject <NSXMLParserDelegate>
{
	NSMutableString *contentOfString;
    
    NSMutableArray *unclosedElements_;
    Class targetClass_;
    id parsedObject_;
	NSString *currentPropertyName_;
    NSMutableString *contentOfCurrentProperty_;
    
    NSDictionary *mappings_, *dataTypes_, *classMappings_;
}

@property (nonatomic, strong)  NSMutableArray *unclosedElements;
@property (nonatomic, strong) Class targetClass;
@property (nonatomic, strong) id parsedObject;
@property (nonatomic, strong) NSString *currentPropertyName;
@property (nonatomic, strong) NSMutableString *contentOfCurrentProperty;

@property (nonatomic, strong) NSDictionary *mappings, *dataTypes, *classMappings;

+ (OPRemoteXMLParserDelegate *)delegateForClass:(Class)targetClass mappings:(NSDictionary*)inMappings dataTypes:(NSDictionary*)inDataTypes classMappings:(NSDictionary *)inClassMappings;

- (id) convertProperty:(NSString *)propertyValue toType:(NSString *)type ;
@end
