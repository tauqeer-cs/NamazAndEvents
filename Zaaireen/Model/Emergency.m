//
//  Emergency.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/24/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Emergency.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "Countries.h"
@implementation Emergency

/*
 NSNumber *emgencyId;
 NSString *title;
 NSString *phone1;
 NSString *imageurl;
 NSString *eType;
 NSDate *createdAt;
 NSDate *updatedAt;
 Countries *country;
 */

+(void)callAllEmergencyNumbersWithUpperLimit:(NSString *)upperLimit
                              withLowerLimit:(NSString *)lowerLimit
                                   withAppId:(NSString *)appId
                       withComplitionHandler:(void(^)(id result))completionHandler
                           withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    [currentDictionary setObject:@""
                          forKey:@"total"];
    
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit",@"total"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-emergency-contacts"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  NSLog(@"Called");
                                  
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addFromArray:body];
                                  
                                  id allCountries = [self getAll];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"EmergencyListDownloaded"];
                                  
                                  completionHandler(allCountries);
                                  
                              }
                              else{
                                  failureHandler();
                              }
                              
                          }
                          
                          @catch (NSException *exception) {
                              
                              failureHandler();
                              
                          }
                          
                          
                          // completionHandler(result);
                          
                          
                      } failureComlitionHandler:^{
                          
                          failureHandler();
                          
                      }];
}


+(void)addFromArray:(NSArray *)list{
    
    for (id currentObject in list) {
        
        NSLog(@"%@",currentObject);
        
        
       Countries *toAddCountry = [Countries getCountryById:[NSNumber numberWithInt:(int)[[currentObject objectForKey:@"country_id"] integerValue]]];
        
        
        [self addItemId:(int)[[currentObject objectForKey:@"id"] integerValue]
    withTitle:[currentObject objectForKey:@"title"]
    withEtype:[currentObject objectForKey:@"e_type"]
    withImgUrl:[currentObject objectForKey:@"imageurl"]
    withCountry:toAddCountry
    withPhone1:[currentObject objectForKey:@"phone1"]
          withCreatedAt:
         [DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
          withUpdatedAt:
         [DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        

    }
}


+(id)getById:(Countries *)countryGiven
{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Emergency"];
    request.predicate = [NSPredicate predicateWithFormat:@"country.countryId == %@",countryGiven.countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
    
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Emergency"];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(void)addItemId:(int)ItemId
       withTitle:(NSString *)title
       withEtype:(NSString *)Etype
       withImgUrl:(NSString *)imageUrl
     withCountry:(Countries *)country
withPhone1:(NSString *)phone1
    withCreatedAt:(NSDate *)createdAt
    withUpdatedAt:(NSDate *)updatedAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([self ifRecordAlreadyExistsWithTagName:ItemId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    
    Emergency *currentCity = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Emergency"
                           inManagedObjectContext:
                           managedObjectContext];
    
    currentCity.emgencyId = [NSNumber numberWithInt:ItemId];
    currentCity.title = title;
    currentCity.eType = Etype;
    currentCity.imageurl = imageUrl;
    currentCity.country = country;
    currentCity.phone1 = phone1;
    currentCity.createdAt = createdAt;
    currentCity.updatedAt = updatedAt;
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)itemId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Emergency"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"emgencyId == %@",[NSNumber numberWithInt:itemId]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Emergency"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}




@end
