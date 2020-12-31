//
//  UIViewController+MBExtensions.h
//  myAds
//
//  Created by Farhan Yousuf on 12/08/16.
//  Copyright © 2016 mykingdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (MBExtensions)

- (void)showError:(NSError * _Nullable)error;

- (void)showErrorWithTitle:( NSString * _Nullable )title message:( NSString * _Nullable )message;

- (void)showErrorWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message cancelHandler:(void (^ __nullable)(void))cancelHandler;

- (void)showErrorWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message primaryActionTitle:(NSString * _Nullable)primaryTitle  cancelActionTitle:(NSString *_Nullable )cancelTitle primaryActionHandler:(void (^ __nullable)(void))primaryActionHandler cancelActionHandler:(void (^ __nullable)(void))cancelHandler;
- (void)showErrorWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message actionTitle:(NSString * _Nullable)actionTitle  actionHandler:(void (^ __nullable)(void))actionHandler;
@end
