//
//  NSMutableString+Spaces.m
//  omniPOS
//
//  Created by Kumar Sharma on 30/08/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "NSMutableString+Spaces.h"
#import "NSString+Extension.h"

#define kSPACE 22

#define kRECEIPT_RIGHT_ALLIGN_POSITION 17


@implementation NSMutableString (Spaces)

- (void)appendString:(NSString *)aString andString:(NSString *)bString
{
    [self appendFormat:@"%@%@%@\n", aString, [self spaceForString:aString], bString];
}

- (NSString *)spaceForString:(NSString *)str
{
    NSMutableString *space = [NSMutableString stringWithString:@" "];
    
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:2.0]];
    NSInteger totalSpace = (kSPACE - size.width) + (13 - size.width);
    if(totalSpace <= 0)
        totalSpace = 0;
    
    for(int i = 0; i< totalSpace; i++)
        [space appendString:@" "];
    
    return space;
}

- (void)startHtmlTableWithTitle:(NSString *)title
{
    NSMutableString *script = [NSMutableString stringWithString:@""];
	[script appendFormat:@"<style>body{font-family: Georgia;font-size: 16pt;padding: 0 2px 0 0;          margin: 5px 18px;line-height: 22pt;color: #330000;background-color: #ffcccc;}</style>"];
    
    NSMutableString *html = [NSMutableString stringWithString:@"<!DOCTYPE html><html><head><meta name = \"viewport\" content = \"initial-scale=1.0\">"];
    
    [html appendFormat:@"%@</head>", script];
    [html appendFormat:@"<body><b>%@</b>", title];
    [self appendString:html];
    
    [self appendString:@"<br><table border=\"1\" style=\"background-color:#0099cc;border:1px dotted black;width:100%;border-collapse:collapse;\"><tr style=\"background-color:orange;color:gray;\">    <th style=\"padding:6px;\">Description 1</th><th style=\"padding:3px;\">Description 2</th></tr>"];
}

- (void)appendHtmlString:(NSString *)aString andString:(NSString *)bString
{
    if(aString && bString)
        [self appendFormat:@"<tr><td style=\"padding:6px;font-size: 14pt;\">%@</td><td style=\"padding:3px;text-align: right;font-size: 14pt;\">%@</td></tr>", aString, bString];
    else if(!bString)
        [self appendFormat:@"<th style=\"padding:12px;\">%@</th>", aString];
}

- (void)extractAndAppendFromString:(NSString *)string
{
    NSArray *saleDetails = [string componentsSeparatedByString:@"\n"];
    for(NSString *str in saleDetails)
    {
        NSArray *cols = [str componentsSeparatedByString:@":"];
        if(cols.count == 2)
        {
            NSString *col1 = [cols objectAtIndex:0];
            NSString *col2 = [cols objectAtIndex:1];
            
            if(![col1 hasPrefix:@"------"])
            {
                if(col2.length > 2)
                    [self appendHtmlString:col1 andString:col2];
                else
                    [self appendHtmlString:col1 andString:nil];
            }
        }
        else if(cols.count == 1)
        {
            NSString *col1 = [cols objectAtIndex:0];
            if(col1.length > 2 && ![col1 hasPrefix:@"------"])
                [self appendHtmlString:col1 andString:nil];
        }
    }
}

- (void)endHtmLTable
{
    [self appendString:@"</table></body></html>"];
}

- (void)appendAllignedString:(NSString *)str1 withString:(NSString *)str2
{
    [self appendString:[NSString makeFormatting:str1 upto:22 align:OPAlignmentLeft]];
    [self appendString:[NSString makeFormatting:str2 upto:kRECEIPT_RIGHT_ALLIGN_POSITION align:OPAlignmentRight]];
}

- (void)appendReceiptAllignedString:(NSString *)str1 withString:(NSString *)str2
{
    [self appendString:[NSString makeFormatting:str1 upto:22 align:OPAlignmentLeft]];
    [self appendString:[NSString makeFormatting:str2 upto:kRECEIPT_RIGHT_ALLIGN_POSITION align:OPAlignmentRight]];
}

- (void)startHtmlWithTitle:(NSString *)title
{
    NSMutableString *script = [NSMutableString stringWithString:@""];
    [script appendFormat:@"<style>body{font-family: Times;font-size: 16pt;padding: 0 2px 0 0;          margin: 5px 18px;line-height: 22pt;color: #330000;}</style>"];
    
    NSMutableString *html = [NSMutableString stringWithString:@"<!DOCTYPE html><html><head><meta name = \"viewport\" content = \"initial-scale=1.0\">"];
    
    [html appendFormat:@"%@</head>", script];
    [html appendFormat:@"<body><b>%@</b>", title];
    [self appendString:html];
}

@end
