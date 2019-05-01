//
//  UnderLineLabel.m
//  omniPOS
//
//  Created by Kumar Sharma on 15/04/11.
//  Copyright 2011 MSIT. All rights reserved.
//

#import "ULButton.h"


@implementation ULButton

- (void)drawRect:(CGRect)rect 
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0.0f/255.0f,0.0f/255.0f, 0.8f, 1.0f); // RGBA
    CGContextSetLineWidth(ctx, 1.0f);
	
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 1);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
	
    CGContextStrokePath(ctx);
	
    [super drawRect:rect]; 
}


@end
