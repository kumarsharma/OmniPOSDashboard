//
//  ADUtil.h
//  iOmniPOS
//
//  Created by Kumar Sharma on 11/06/12.
//  Copyright (c) 2012 Omni Systems pty. Ltd.. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ADUtils : NSObject

+ (NSString *)getRequiredDateString:(NSDate*)date;
+ (NSString *)getRequiredDateFormat:(NSString *)dateFormat fromDate:(NSDate*)date;
+ (NSString *)getShortDateString:(NSDate*)date ;
+ (NSString *)getShortDateTimeString:(NSDate*)date;
+(long)getTimeDiffBetweenDate1:(NSDate *)date1 andDate2:(NSDate *)date2;
+ (NSString *)getShortDateOnlyString:(NSDate*)date;
+ (NSString *)getShortTimeOnlyString:(NSDate*)date ;
+ (int)daysBetweenFirstDate:(NSDate *)dt1 secndDate:(NSDate *)dt2 ;
+ (BOOL)hasDigitsAfterDecimal:(float)value;
+ (NSString *)digitPaymentType:(NSString *)paymentType;
+ (NSString *)getMmDdYyyyHhTzDateString:(NSDate*)date;

+ (NSString *)getNext7DayText;

+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate;
+ (NSString *)julianDay;
+ (NSDate *)getTomorrow;
+ (NSDate *)getYesterday;
+ (NSDate *)getDateByAddingDays:(NSInteger)daysToBeAdded;
+ (NSArray *)getWeekDays;
+ (NSString *)getTodaysDayName;
+ (BOOL)isDate:(NSDate*)nowdate isBetweenDate:(NSDate*)startDate andDate:(NSDate*)endDate;
+ (NSDate *)getDateOnlyDate:(NSDate*)date;
+ (NSString *)getDayMonthString:(NSDate*)date;
+ (NSString *)getMonthNameAndDay:(NSDate *)date;
+ (NSDate *)getDateFromString:(NSString*)date;
+ (NSString *)getTimeOnly:(NSDate*)date;
+ (NSString *)getShortTimeOnly:(NSDate*)date;
+ (NSString *)getCurrrentDateInUniqueStyle ;
+ (NSString *)julianDayLong;

+ (NSString *)getMonthDayYearName:(NSDate *)date;
+ (BOOL)isCurrentTimeFallsBetweenTime1:(NSString *)startTimeString andTime2:(NSString *)endTimeString;
+ (NSString*) getCurrentYear;
+ (BOOL)doesTodayFallInDays:(NSArray *)days;
+ (int) minutesSinceMidnight:(NSDate *)date;
+ (NSString *)getLongTimeOnlyString:(NSDate*)date;
+ (NSString *)getCurrrentDateInShortUniqueStyle;
+ (int)actualDaysBetweenFirstDate:(NSDate *)dt1 secndDate:(NSDate *)dt2;
+ (NSString *)getTimeStringFromSeconds:(double)seconds;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
+ (NSString *)getMonthDayYear:(NSDate *)date;
+ (NSString *)getCurrrentShortDateInUniqueStyle;
+ (NSString *)getShortDateOnlyStringInMMddYYYY:(NSDate*)date;
+ (NSString *)getDateOnlyInYYYYMMDDFormat:(NSDate*)date;
@end
