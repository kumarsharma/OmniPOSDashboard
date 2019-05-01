//
//  NSString+Extension.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 19/06/12.
//  Copyright (c) 2012 Home. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface NSString (Extension)

-(NSString*)contentForTag:(NSString*)tagName;
-(NSString *)gsub:(NSDictionary *)keyValues ;
-(NSString *)toXMLValue;
-(NSString *) stringFromMD5;
- (NSString *)lowercasedFirstLetterString;
- (NSString*)spaceized;
- (BOOL)isUppercase:(NSString*)charStr;
-(NSString *)pluralized;
- (NSString *)removeFirstSpaces;
- (BOOL)hasTag:(NSString *)tagName;
+ (NSString *)makeFormatting:(NSString *)str upto:(NSInteger)p align:(OPAlignment)alignment;
- (NSString *)urlencode;
@end
