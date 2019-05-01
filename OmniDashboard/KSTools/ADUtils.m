//
//  ADUtil.m
//  iOmniPOS
//
//  Created by Kumar Sharma on 11/06/12.
//  Copyright (c) 2012 Omni Systems pty. Ltd.. All rights reserved.
//

/*
   Note: ADUtils provides date utility functions.
*/

#import "ADUtils.h"

@implementation ADUtils

+ (NSString *)getRequiredDateString:(NSDate*)date {
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY, HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getMmDdYyyyHhTzDateString:(NSDate*)date
{
    if(nil == date)
        return nil;
    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY HH:mm:ss Z"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    char ch = [stringFromDate characterAtIndex:stringFromDate.length-2];
    if(ch != ':')
    {
        NSMutableString *str = [NSMutableString stringWithString:stringFromDate];
        [str insertString:@":" atIndex:str.length - 2];
        [str replaceOccurrencesOfString:@"+" withString:@"p" options:1 range:NSMakeRange(0, str.length-1)];
        [str replaceOccurrencesOfString:@"-" withString:@"m" options:1 range:NSMakeRange(0, str.length-1)];
        
        stringFromDate = str;
    }
    
    return stringFromDate;
}

+ (NSString *)getShortDateString:(NSDate*)date 
{    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a, (dd/MM/YYYY)"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getShortDateTimeString:(NSDate*)date 
{    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY, hh:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getShortDateOnlyString:(NSDate*)date 
{    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}


+ (NSString *)getDateOnlyInYYYYMMDDFormat:(NSDate*)date 
{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getShortDateOnlyStringInMMddYYYY:(NSDate*)date 
{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getShortTimeOnlyString:(NSDate*)date
{    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getLongTimeOnlyString:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getShortTimeOnly:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getTimeOnly:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh.mm"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getRequiredDateFormat:(NSString *)dateFormat fromDate:(NSDate*)date 
{    
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getDayMonthString:(NSDate*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMM"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+(long)getTimeDiffBetweenDate1:(NSDate *)date1 andDate2:(NSDate *)date2
{
    if(nil == date1 || nil == date2)
        return 0;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSUInteger unitFlags = NSSecondCalendarUnit;
    
    NSDateComponents *components = [gregorian components:unitFlags                                                fromDate:date1 toDate:date2 options:0];
    
    long secs = [components second];
    
    return secs;
}

+ (int)daysBetweenFirstDate:(NSDate *)dt1 secndDate:(NSDate *)dt2 
{
    if(nil == dt1 || nil == dt2)
        return 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return (int)[components day]+1;
}

+ (int)actualDaysBetweenFirstDate:(NSDate *)dt1 secndDate:(NSDate *)dt2
{
    if(nil == dt1 || nil == dt2)
        return 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:dt1 toDate:dt2 options:0];
    return (int)[components day];
}

+ (BOOL)hasDigitsAfterDecimal:(float)value
{
    int x = value;
    float z = value - x;
    
    if(z > 0)
        return YES;
    
    return NO;
}

+ (NSString *)digitPaymentType:(NSString *)paymentType
{
    NSString *digType = nil;
   
    
    return digType;
}

+ (NSDate *)getTomorrow
{
    return [self getDayIsNextDay:YES];
}

+ (NSDate *)getYesterday
{
    return [self getDayIsNextDay:NO];
}

+ (NSDate *)getDayIsNextDay:(BOOL)isNextDay
{
    NSInteger d = 0;
    if(isNextDay)
        d = 1;
    else
        d = -1;
    
    return [self getDateByAddingDays:d];
}

+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

+ (NSString *)getNext7DayText
{
    NSDate *date = [self getDateByAddingDays:7];
    
    NSString *str = [self getDayMonthString:date];
    
    return str;
}

#pragma mark - Julian Date

+ (NSString *)julianDay
{
	NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    cal.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComps = [cal components:units fromDate:[NSDate date]];
    
    NSInteger month  = [dateComps month];
    NSInteger year   = [dateComps year];
    NSInteger day    = [dateComps day];
	
    NSInteger daysLeft = 0;
    for(int monthLeft = 1; monthLeft <= month-1; monthLeft++)
        daysLeft += [self daysForMonth:monthLeft withYear:year];
    
    daysLeft += day;
    
    NSString *julday = [NSString stringWithFormat:@"%d%d", (int)year, (int)daysLeft];
    
	return julday;
}

+ (NSString *)julianDayLong
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    cal.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComps = [cal components:units fromDate:[NSDate date]];
    
    NSInteger month  = [dateComps month];
    NSInteger year   = [dateComps year];
    NSInteger day    = [dateComps day];
    
    NSInteger h  = [dateComps hour];
    NSInteger m   = [dateComps minute];
    NSInteger s    = [dateComps second];
    
    NSInteger daysLeft = 0;
    for(int monthLeft = 1; monthLeft <= month-1; monthLeft++)
        daysLeft += [self daysForMonth:monthLeft withYear:year];
    
    daysLeft += day;
    
    NSString *julday = [NSString stringWithFormat:@"%d%d-%d%d%d", (int)year, (int)daysLeft, (int)h, (int)m ,(int)s];
    
    return julday;
}

+ (NSInteger)daysForMonth:(NSInteger)month withYear:(NSInteger)year{
    
    NSInteger days = 0;
    switch (month) {
            
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            days = 31;
            break;
            
        case 2:
            days = (year % 4 == 0 ? 29 : 28);
            break;
            
        case 4:
        case 6:
        case 9:
        case 11:
            days = 30;
            break;
            
        default:
            break;
    }
    
    return days;
}

+ (NSDate *)getDateByAddingDays:(NSInteger)daysToBeAdded
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *todayComponents = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    NSInteger theDay = [todayComponents day];
    NSInteger theMonth = [todayComponents month];
    NSInteger theYear = [todayComponents year];
    
    // now build a NSDate object for yourDate using these components
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:theDay];
    [components setMonth:theMonth];
    [components setYear:theYear];
    NSDate *thisDate = [gregorian dateFromComponents:components];
    
    // now build a NSDate object for the next day
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    
    [offsetComponents setDay:daysToBeAdded];

    NSDate *date = [gregorian dateByAddingComponents:offsetComponents toDate:thisDate options:0];
    
    return date;
}

+ (NSArray *)getWeekDays
{
    NSArray *days = nil;
    
    
    
    return days;
}

+ (NSString *)getTodaysDayName
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate;
}

+ (BOOL)isDate:(NSDate*)nowdate isBetweenDate:(NSDate*)startDate andDate:(NSDate*)endDate
{
    if (nil == startDate || [nowdate compare:startDate] == NSOrderedAscending)
        return NO;
    
    if (nil == endDate || [nowdate compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (NSDate *)getDateOnlyDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *d = [calendar dateFromComponents:components];
    
    return d;
}

+ (NSString *)getMonthNameAndDay:(NSDate *)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd (EEEE)"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSDate *)getDateFromString:(NSString*)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/YYYY, hh:mm a"];
    NSDate *d = [formatter dateFromString:date];
    return d;
}

+ (NSString *)getCurrrentDateInUniqueStyle {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMddyyyy'T'HHmmssSSS"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate;
}

+ (NSString *)getCurrrentShortDateInUniqueStyle {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MdyyHHmmssSSS"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate;
}

+ (NSString *)getMonthDayYearName:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd (EEEE)"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (NSString *)getMonthDayYear:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, YYYY"];
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

+ (BOOL)isCurrentTimeFallsBetweenTime1:(NSString *)startTimeString andTime2:(NSString *)endTimeString
{
//    
//    NSString *startTimeString = @"08:00 AM";
//    NSString *endTimeString = @"06:00 PM";
//    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh:mm a"];
    
    NSString *nowTimeString = [formatter stringFromDate:[NSDate date]];
    
    int startTime   = [self minutesSinceMidnight:[formatter dateFromString:startTimeString]];
    int endTime  = [self minutesSinceMidnight:[formatter dateFromString:endTimeString]];
    int nowTime     = [self minutesSinceMidnight:[formatter dateFromString:nowTimeString]];;
    
    
    if (startTime <= nowTime && nowTime <= endTime)
        return YES;
    else
        return NO;
    
    return NO;
}


+ (int) minutesSinceMidnight:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    return 60 * (int)[components hour] + (int)[components minute];
}

+ (NSString*) getCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    return yearString;
}

+ (BOOL)doesTodayFallInDays:(NSArray *)days
{
    NSString *today = [ADUtils getTodaysDayName];
    if(!days.count || ![days containsObject:today])
        return NO;
    else if([days containsObject:today])
        return YES;
    
    return NO;
}

+ (NSString *)getCurrrentDateInShortUniqueStyle
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMddyyyyHHmmss"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    return stringFromDate;
}

+ (NSString *)getTimeStringFromSeconds:(double)seconds
{
    NSDateComponentsFormatter *dcFormatter = [[NSDateComponentsFormatter alloc] init];
    dcFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    dcFormatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute;
    dcFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    return [dcFormatter stringFromTimeInterval:seconds];
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval
{
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}
@end
