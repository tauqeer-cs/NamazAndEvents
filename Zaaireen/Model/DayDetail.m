//
//  DayDetail.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "DayDetail.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "Config.h"
#import "DateFormatter.h"

@implementation DayDetail


+(void)callDayDetailListWithUpperLimit:(NSString *)upperLimit
                       withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId
                withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-day-detail-list"]
                      withComplitionHandler:^(id result)
     {
         @try {
             
             if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                 
                 id body = [result objectForKey:@"body"];
                 [self addFromArray:body];
                 id allCountries = [self getAll];
                 NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                 [currentUserDefault setObject:@"1" forKey:@"DayDetailDownloaded"];
                 completionHandler(allCountries);
                 
             }
             else{
                 failureHandler();
             }
             
         }
         @catch (NSException *exception) {
             
             failureHandler();
         }
         
         
     } failureComlitionHandler:^{
         
         failureHandler();
         
     }];
    
    
}

+(void)addFromArray:(NSArray *)list{
    
    for (id currentObject in list) {
        

        
        [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
    withTitle:[currentObject objectForKey:@"title"]
         withText:[currentObject objectForKey:@"detail"]
    withRefrences:[currentObject objectForKey:@"refer"]
    withDisplayDate:[currentObject objectForKey:@"display_date"]
withDisplayCalender:[currentObject objectForKey:@"date_calendar"]
  withCreatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                                    withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
      withUpdated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"]
                                    withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
      withDayType:[currentObject objectForKey:@"day_type"]];

    }
}

+(id)getWeekDetailFromArray:(NSArray *)dates{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"DayDetail"];
    
    //date = [@"*" stringByAppendingString:[date stringByAppendingString:@""]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"display_date LIKE %@ OR display_date LIKE %@ OR display_date LIKE %@ OR display_date LIKE %@ OR display_date LIKE %@ OR display_date LIKE %@ OR display_date LIKE %@ OR display_date LIKE %@"
                         ,
                         [dates[0] stringByAppendingString:@"*"],
                         [dates[1] stringByAppendingString:@"*"],
                         [dates[2] stringByAppendingString:@"*"],
                         [dates[3] stringByAppendingString:@"*"],
                         [dates[4] stringByAppendingString:@"*"],
                         [dates[5] stringByAppendingString:@"*"],
                         [dates[6] stringByAppendingString:@"*"],
                         [dates[7] stringByAppendingString:@"*"]
                         ];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}


+(id)getWeekDetail:(NSString *)date{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"DayDetail"];
    
    date = [@"*" stringByAppendingString:[date stringByAppendingString:@""]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"display_date LIKE %@",date];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}


+(id)getAllWithId:(int)itemId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"DayDetail"];
    request.predicate = [NSPredicate predicateWithFormat:@"dayDetailId == %@",[NSNumber numberWithInt:itemId]];
    [request setReturnsObjectsAsFaults:YES];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}



+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"DayDetail"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(void)add:(int)itemId
 withTitle:(NSString *)title
   withText:(NSString *)text
   withRefrences:(NSString *)refrences
   withDisplayDate:(NSString *)displayDate
   withDisplayCalender:(NSString *)displayCalender
   withCreatedDate:(NSDate *)createdAt
   withUpdated:(NSDate *)updatedAt
withDayType:(NSString *)datType

{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([DayDetail ifRecordAlreadyExistsWithTagName:itemId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    DayDetail *currentItem = [NSEntityDescription
                          insertNewObjectForEntityForName:@"DayDetail"
                          inManagedObjectContext:
                          managedObjectContext];
    
    currentItem.dayDetailId= [NSNumber numberWithInteger:itemId];
    currentItem.title = title;
    currentItem.text = text;
    currentItem.refrences = refrences;
    currentItem.display_date = displayDate;
    currentItem.date_calender = displayCalender;
    currentItem.created_at = createdAt;
    currentItem.updatedAt = updatedAt;
    currentItem.dayType = datType;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}


+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"DayDetail"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"dayDetailId == %@",[NSNumber numberWithInt:Id]];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    if ([results count] > 0) {
        
        return YES;
    }
    return NO;
}
+(void)removeAllObject{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"DayDetail"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}
+(NSString *)islamicMonthName:(int)month{
    
    month--;
    
    NSArray *months = @[@"Muharram", @"Safar", @"Rabi I", @"Rabi II", @"Jumada I", @"Jumada II",
                        @"Rajab", @"Shaban", @"Ramadan", @"Shawwal", @"Dhul-Qadah", @"Dhul-Hijjah"];
    
    return months[month];
}
@end
