//
//  Validator.m
//  MapApp
//


#import "Validator.h"

@implementation Validator

/*
   Tells whether an email id is valid or not;
*/ 
+(BOOL)validateEmailId:(NSString*)emailId
{
	BOOL result = NO;
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if ([emailPredicate evaluateWithObject:emailId])
	{
		result = YES;
	}
	else 
	{
		result = NO;
	}
	return result;
}

+(BOOL)validateNumeric:(NSString*)text
{
    BOOL result = NO;
    NSString *numericRegex = @"^(?:|0|[1-9]\\d*)(?:\\\\d*)?$";
    NSPredicate *numericPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    if ([numericPredicate evaluateWithObject:text]) {
        result = YES;
    }
    return result;
}

+(BOOL)validatePhoneNumber:(NSString*)phoneNumber
{
	BOOL result = NO;
	phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
	if(phoneNumber.length == 10)
	{
		return [Validator validateNumeric:phoneNumber];
	}
	return result;
}

@end
