//
//  NSObject+MBExtensions.m
//  myAds
//
//  Created by Farhan Yousuf on 12/08/16.
//  Copyright © 2016 mykingdom. All rights reserved.
//

#import "NSObject+MBExtensions.h"

@implementation NSObject (MBExtensions)

- (void)showError:(NSError * _Nullable)error {
    [self showErrorWithTitle:@"Error" message:error.localizedDescription];
}

- (void)showErrorWithTitle:( NSString * _Nullable )title message:( NSString * _Nullable )message {
    
    [self showErrorWithTitle:title message:message cancelHandler:nil];
    
}
- (void)showErrorWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message cancelHandler:(void (^ __nullable)(void))cancelHandler {
    
    [self showErrorWithTitle:title message:message primaryActionTitle:nil cancelActionTitle:@"Okay" primaryActionHandler:nil cancelActionHandler:cancelHandler];
}

- (void)showErrorWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message primaryActionTitle:(NSString * _Nullable)primaryTitle  cancelActionTitle:(NSString *_Nullable )cancelTitle primaryActionHandler:(void (^ __nullable)(void))primaryActionHandler cancelActionHandler:(void (^ __nullable)(void))cancelHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (primaryTitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:primaryTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor];
            
            if (primaryActionHandler) {
                primaryActionHandler();
            }
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
            
        }]];
    }
    
    if (cancelTitle) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor];
            
            if (cancelHandler) {
                cancelHandler();
            }
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
    }
    
    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor blackColor];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)showErrorWithTitle:(NSString * _Nullable)title message:(NSString * _Nullable)message actionTitle:(NSString * _Nullable)actionTitle  actionHandler:(void (^ __nullable)(void))actionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (actionTitle) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor whiteColor];
            
            if (actionHandler) {
                actionHandler();
            }
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
    }
    
    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor blackColor];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
