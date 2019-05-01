//
//  StatusView.h
//  TwoThumbsUp
//
//  Created by Kumar Sharma on 22/04/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import "StatusView.h"
#import <QuartzCore/QuartzCore.h>

@interface StatusView (Private)
-(void)addSubviews;
-(void)disappearSelf;
@end

@implementation StatusView
@synthesize titleLabel;
@synthesize totalSecs;
-(id)initWithFrame:(CGRect)frame{
    
    //frame = CGRectMake(0, 0, 160, 20);
    
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 20;
        self.alpha = 0.75;
        totalSecs = 0;
        [self addSubviews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)didTap
{
    [self disappearAfter:2];
}

-(void)addSubviews{
    UILabel *lbl = [[UILabel alloc] init];
    
    lbl.frame = self.bounds;//CGRectMake(0, 2, 160, self.frame.size.height - 4.0);
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor greenColor];
    lbl.font = [UIFont boldSystemFontOfSize:21];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.numberOfLines = 3;
    self.titleLabel = lbl;
    
    
    [self addSubview:self.titleLabel];
}

-(void)disappearAfter:(NSInteger)duration_
{
    duration = duration_;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self
                                                    selector:@selector(disappearSelf) userInfo:nil repeats:YES];
}

-(void)disappearSelf
{
    totalSecs++;
    self.alpha = self.alpha - 0.10;
    if(totalSecs >= duration)
    {
        totalSecs = 0;
        if(countDownTimer)
        {
            [countDownTimer invalidate];
            countDownTimer = nil;
        }
        [self removeFromSuperview];
    }
}

- (void)removeByForce
{
    if([countDownTimer isValid])
    {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    
    [self removeFromSuperview];
}

-(void)dealloc
{
    if(countDownTimer)
    {
        [countDownTimer invalidate];
        countDownTimer = nil;
    }
    self.titleLabel = nil;
}

+ (StatusView *)showPopupWithMessage:(NSString *)message timeToStay:(NSInteger)secs onView:(UIView *)view
{
    return [self showPopupWithMessage:message timeToStay:secs viewColor:nil textColor:nil onView:view];
}

+ (StatusView *)showPopupWithMessage:(NSString *)message timeToStay:(NSInteger)secs viewColor:(UIColor *)color textColor:(UIColor *)textColor onView:(UIView *)view
{
    StatusView *sv = [[StatusView alloc] initWithFrame:CGRectMake(95.0, 350.0, 290.0, 94.0)];
    sv.center = view.center;
    sv.titleLabel.text = message;
    
    if(color)
        sv.titleLabel.backgroundColor = color;
    else
        sv.titleLabel.backgroundColor = [UIColor clearColor];
    
    if(textColor)
        sv.titleLabel.textColor = textColor;
    else
        sv.titleLabel.textColor = [UIColor greenColor];
    
    [sv disappearAfter:secs];
    [view addSubview:sv];
    
    return sv;
}

+ (StatusView *)showLargePopupWithMessage:(NSString *)message timeToStay:(NSInteger)secs viewColor:(UIColor *)color textColor:(UIColor *)textColor onView:(UIView *)view
{
    StatusView *sv = [[StatusView alloc] initWithFrame:CGRectMake(95.0, 350.0, 340, 144.0)];
    sv.alpha = 1;
    sv.center = view.center;
    sv.titleLabel.text = message;
    sv.titleLabel.numberOfLines = 4;
    sv.titleLabel.font = [UIFont boldSystemFontOfSize:27]; //[UIFont fontWithName:[OPFontManager
    
    if(color)
        sv.titleLabel.backgroundColor = color;
    else
        sv.titleLabel.backgroundColor = [UIColor clearColor];
    
    if(textColor)
        sv.titleLabel.textColor = textColor;
    else
        sv.titleLabel.textColor = [UIColor greenColor];
    
    [sv disappearAfter:secs];
    [view addSubview:sv];
    
    return sv;
}

@end
