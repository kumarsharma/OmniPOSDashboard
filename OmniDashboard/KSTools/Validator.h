//
//  Validator.h
//  MapApp
//


#import <Foundation/Foundation.h>


@interface Validator : NSObject {

}

+(BOOL)validateEmailId:(NSString*)emailId;
+(BOOL)validateNumeric:(NSString*)text;
+(BOOL)validatePhoneNumber:(NSString*)phoneNumber;

@end
