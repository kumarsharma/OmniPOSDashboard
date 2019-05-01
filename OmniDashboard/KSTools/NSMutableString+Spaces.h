//
//  NSMutableString+Spaces.h
//  omniPOS
//
//  Created by Kumar Sharma on 30/08/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Spaces)
- (NSString *)spaceForString:(NSString *)str;
- (void)appendString:(NSString *)aString andString:(NSString *)bString;
- (void)appendHtmlString:(NSString *)aString andString:(NSString *)bString;

- (void)startHtmlTableWithTitle:(NSString *)title;
- (void)endHtmLTable;
- (void)extractAndAppendFromString:(NSString *)string;
- (void)appendAllignedString:(NSString *)str1 withString:(NSString *)str2;

- (void)appendReceiptAllignedString:(NSString *)str1 withString:(NSString *)str2;
//- (void)startHtmlWithTitle:(NSString *)title;
- (void)startHtmlWithTitle:(NSString *)title;
@end
