//
//  StatusView.h
//  TwoThumbsUp
//
//  Created by Kumar Sharma on 22/04/12.
//  Copyright (c) 2012 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatusView : UIView {
    UILabel *titleLabel;
    NSInteger totalSecs, duration;
    NSTimer *countDownTimer;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic,assign) NSInteger totalSecs;

-(void)disappearAfter:(NSInteger)duration_;
- (void)removeByForce;
+ (StatusView *)showPopupWithMessage:(NSString *)message timeToStay:(NSInteger)secs viewColor:(UIColor *)color textColor:(UIColor *)textColor onView:(UIView *)view;
+ (StatusView *)showPopupWithMessage:(NSString *)message timeToStay:(NSInteger)secs onView:(UIView *)view;
+ (StatusView *)showLargePopupWithMessage:(NSString *)message timeToStay:(NSInteger)secs viewColor:(UIColor *)color textColor:(UIColor *)textColor onView:(UIView *)view;
@end
