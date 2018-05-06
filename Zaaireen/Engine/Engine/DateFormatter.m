//
//  DateFormatter.m
//  IamKarachi
//
//  Created by Tauqeer on 2015-01-26.
//  Copyright (c) 2015 Tauqeer. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

+(NSString *)showDate:(NSDate *)givenDate inStringFormate:(NSString *)stringFormate
{

    if (!stringFormate) {
        stringFormate =@"yyyy-MM-dd HH:mm:ss";
        
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:stringFormate];
    
    return [formatter stringFromDate:givenDate];
    
}

+(NSString *)getCurrentDate{
    
    NSDate *date = [NSDate new];
    
    NSString *check = [DateFormatter showDate:date inStringFormate:@"yyyy-MM-dd HH:mm:ss"];
    
    return check;
}

+(BOOL)isDateOfFurtue:(NSDate *)givenDate
{
    if (NSOrderedAscending) {
        return YES;
        
        
    }
    return NO;
}


+(NSDate *)makeDataFromString:(NSString *)dateGiven withDateFormate:(NSString *)format
{
    
    if ([format length] == 0) {
        format = @"yyyy-MM-dd";
    }
    
    if([dateGiven isKindOfClass:[NSNull class] ]){
        
        return [NSDate new];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateGiven];
}

+(void)stringTimeDiffernceBetweenDate1:(NSDate *)date1 andSecondDate:(NSDate *)date2{

    
}

+(BOOL)hasMinutesPass:(int)noOfNumer sinceTime:(NSDate *)time{
    
    float countdown = [time timeIntervalSinceNow];
    
    if (countdown < 0) {
        countdown = countdown * -1;
        
    }
    int hh = (countdown/3600);
    int mm = ((countdown-(hh*3600))/60);
    
    
    //int ss = countdown-(hh*3600+mm*60);

    
    if (mm >= noOfNumer) {
        
        return YES;
        
    }
    return NO;
    
}
+(NSDate *)convertGMTtoLocal:(NSString *)gmtDateStr
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:gmt];
    NSDate *GMTTime = [formatter dateFromString:gmtDateStr];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSLog(@"%@",tz);
    NSInteger seconds = [tz secondsFromGMTForDate: GMTTime];
    NSLog(@"%ld",(long)seconds);
    NSLog(@"%@",[NSDate dateWithTimeInterval: seconds sinceDate: GMTTime]);
    return [NSDate dateWithTimeInterval: seconds sinceDate: GMTTime];
    
}

+(NSDate *)convertLocalToGmt
{
    NSDate *localDate = [NSDate new];// get the date
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    NSTimeInterval gmtTimeInterval = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    
    return gmtDate;
    
    
}


+(NSString *)timeSinceDateWithGMT:(NSDate *)givenDate{
    
    
    
    
    
    float countdown = [givenDate timeIntervalSinceDate:[self convertLocalToGmt]];
    
    
    if (countdown < 0) {
        countdown = countdown * -1;
        
    }
    int hh = (countdown/3600);
    int mm = ((countdown-(hh*3600))/60);
    
    
    
    if (hh >= 24 ) {
        
        int days = hh/24;
        
        NSString *daysMessage = [NSString stringWithFormat:@"%d days ago",days];
        
        if (hh < 48) {
            
            daysMessage =  [daysMessage stringByReplacingOccurrencesOfString:@"days" withString:@"day"];
            
            
        }
        
        
        
        
        
        return daysMessage;
        
    }
    else if(hh >=1){
        
        NSString *hours = [NSString stringWithFormat:@"%d hours ago",hh];
        
        if (hh == 1) {
            hours = [hours stringByReplacingOccurrencesOfString:@"hours" withString:@"hour"];
            
        }
        return hours;
        
        
    }
    else {
        NSString *minutes = [NSString stringWithFormat:@"%d mins ago",mm];
        
        if (mm == 1) {
            
            minutes = [minutes stringByReplacingOccurrencesOfString:@"mins" withString:@"mins"];
            
        }
        return  minutes;
        
    }
    
    return @"";
    
}

+(NSString *)timeSinceDate:(NSDate *)givenDate{
    
    
    
    
    
    float countdown = [givenDate timeIntervalSinceNow];
    
    if (countdown < 0) {
        countdown = countdown * -1;
        
    }
    int hh = (countdown/3600);
    int mm = ((countdown-(hh*3600))/60);
    
    
    
    if (hh >= 24 ) {
        
        int days = hh/24;
        
        NSString *daysMessage = [NSString stringWithFormat:@"%d days ago",days];
        
        if (hh < 48) {
           
            daysMessage =  [daysMessage stringByReplacingOccurrencesOfString:@"days" withString:@"day"];
            
            
        }
        
        
        
        
        
        return daysMessage;
        
    }
    else if(hh >=1){
        
        NSString *hours = [NSString stringWithFormat:@"%d hours ago",hh];
        
        if (hh == 1) {
            hours = [hours stringByReplacingOccurrencesOfString:@"hours" withString:@"hour"];
            
        }
        return hours;
        
        
    }
    else {
     NSString *minutes = [NSString stringWithFormat:@"%d mins ago",mm];
        
        if (mm == 1) {
            
             minutes = [minutes stringByReplacingOccurrencesOfString:@"mins" withString:@"mins"];
            
        }
        return  minutes;
        
    }

    return @"";
    
}

+(NSString *)dayOfTheWeek:(int)dayNumber
{

    dayNumber = dayNumber - 1;
    
    NSArray *days = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thurs",@"Fri",@"Sat"];
return days[dayNumber];
}
@end
