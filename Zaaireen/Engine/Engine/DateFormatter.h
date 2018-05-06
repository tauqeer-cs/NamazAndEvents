//
//  DateFormatter.h
//  IamKarachi
//
//  Created by Tauqeer on 2015-01-26.
//  Copyright (c) 2015 Tauqeer. All rights reserved.
//

#import <Foundation/Foundation.h>


//"hh:mm a"

@interface DateFormatter : NSObject

+(NSString *)showDate:(NSDate *)givenDate inStringFormate:(NSString *)stringFormate;
+(NSDate *)makeDataFromString:(NSString *)dateGiven withDateFormate:(NSString *)format;

+(NSString *)timeSinceDate:(NSDate *)givenDate;
+(NSString *)getCurrentDate;
+(BOOL)isDateOfFurtue:(NSDate *)givenDate;


+(NSString *)dayOfTheWeek:(int)dayNumber;
+(BOOL)hasMinutesPass:(int)noOfNumer sinceTime:(NSDate *)time;
+(NSDate *)convertGMTtoLocal:(NSString *)gmtDateStr;
+(NSString *)timeSinceDateWithGMT:(NSDate *)givenDate;

@end
