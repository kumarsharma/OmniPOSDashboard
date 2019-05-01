//
//  NSString+Extension.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Extension)

/**
    Returns content of a xml tag
**/
-(NSString*)contentForTag:(NSString*)tagName
{
    NSString *content = nil;	
	NSString *responseXML = self;
    
    if([responseXML rangeOfString:[NSString stringWithFormat:@"<%@>", tagName]].location == NSNotFound){
        
        return nil;
    }
	else{

		NSScanner *scanner = [NSScanner scannerWithString:responseXML];
		
        NSString *startTag = [NSString stringWithFormat:@"<%@>", tagName];
        NSString *endTag = [NSString stringWithFormat:@"</%@>", tagName];
        NSString  *skipString = startTag;
        
        [scanner scanUpToString:startTag intoString:nil];
        int skipLen = [scanner scanLocation] + [skipString length];
        [scanner setScanLocation:skipLen];
        [scanner scanUpToString:endTag intoString:&content];
	}
    return content;
}

- (BOOL)hasTag:(NSString *)tagName
{
    //ErrorMessage
    NSString *responseXML = self;
    if([responseXML rangeOfString:[NSString stringWithFormat:@"<%@>", tagName]].location == NSNotFound){
        
        return NO;
    }
    return YES;
}

- (NSString *)toXMLValue {
    
	NSString *temp = [self gsub:[NSDictionary dictionaryWithObject:@"&amp;" forKey:@"&"]];
	NSDictionary* escapeChars = [NSDictionary dictionaryWithObjectsAndKeys:@"&quot;",@"\"",@"&apos;",@"'",@"&lt;",@"<",@"&gt;",@">",nil];
	return [temp gsub:escapeChars];
}

- (NSString *)gsub:(NSDictionary *)keyValues {
	
	NSMutableString *subbed = [NSMutableString stringWithString:self];
	
	for (NSString *key in keyValues) {
		NSString *value = [NSString stringWithFormat:@"%@", [keyValues objectForKey:key]];
		NSArray *splits = [subbed componentsSeparatedByString:key];
		[subbed setString:[splits componentsJoinedByString:value]];
	}
	return subbed;
}

- (NSString *) stringFromMD5
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)lowercasedFirstLetterString {
    return [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] lowercaseString], [self substringFromIndex:1]];
}


-(NSString*)spaceized
{
    NSString *newString = @"";
    
    for(int i = 0; i < self.length; i++)
    {
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        if(i == 0)
        {
            newString = [NSString stringWithFormat:@"%@%@",newString, str]; 
        }
        else
        {
            if([self isUppercase:str])
                newString = [NSString stringWithFormat:@"%@ %@",newString, str];
            else
                newString = [NSString stringWithFormat:@"%@%@",newString, str]; 
        }
    }
    
    return newString;
}

- (BOOL)isUppercase:(NSString*)charStr
{
    NSString *u = [charStr uppercaseString];
    int c1 = (int)[charStr characterAtIndex:0];
    int c2 = (int)[u characterAtIndex:0];
    
    if(c1 == c2)
        return YES;
    
    return NO;
}

-(NSString *)pluralized
{
    NSString *str = self;
    if([self characterAtIndex:self.length-1] != 's')
        str =[NSString stringWithFormat:@"%@s", self];
    
    return str;
}

- (NSString *)removeFirstSpaces
{
    NSString *s = self;
    if(self.length > 0 && [self characterAtIndex:0] == ' ')
    {
        s = [self stringByReplacingOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, 1)];
        return [s removeFirstSpaces];
    }
    
    return s;
}


+ (NSString *)makeFormatting:(NSString *)str upto:(NSInteger)p align:(OPAlignment)alignment
{
	//allignment is 0 means left allignment
	//allignment is 1 means right allignment
	NSString *returnStr = @"";
	if(alignment == OPAlignmentLeft)
	{
		if(str.length >= p)
		{
			returnStr = [returnStr stringByAppendingString:[str substringToIndex:p]];
		}
		else
		{
			returnStr = [returnStr stringByAppendingString:str];
			for(int i=0;i < (p-str.length);i++)
			{
				returnStr = [returnStr stringByAppendingString:@" "];
			}
		}
	}
	else
	{
		if(str.length >= p)
		{
			returnStr = [returnStr stringByAppendingString:[str substringToIndex:p]];
		}
		else
		{
			for(int i=0;i < (p-str.length);i++)
			{
				returnStr = [returnStr stringByAppendingString:@" "];
			}
			returnStr = [returnStr stringByAppendingString:str];
		}
	}
	return returnStr;
}

- (NSString *)urlencode
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,
                            @"$" , @"," , @"[" , @"]",
                            @"#", @"!", @"'", @"(",
                            @")", @"*", @" ", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
                             @"%3A" , @"%40" , @"%26" ,
                             @"%3D" , @"%2B" , @"%24" ,
                             @"%2C" , @"%5B" , @"%5D",
                             @"%23", @"%21", @"%27",
                             @"%28", @"%29", @"%2A",
                             @"%20", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [self mutableCopy];
    
    int i;
    for(i = 0; i < len; i++)
    {
        
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    return temp;
}



@end
