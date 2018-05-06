//
//  Countries.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Countries.h"
#import "Config.h"
#import "RestCall.h"
#import "AppDelegate.h"
#import "DateFormatter.h"

@implementation Countries

/*
 @dynamic countryId;
 @dynamic name;
 @dynamic flagUrl;
 @dynamic code;
 @dynamic createdAt;
 @dynamic updatedAt;
 */

// Insert code here to add functionality to your managed object subclass

+(void)loadFirstTimeDataFromPlistWithComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CoutriesPropertyList" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    id body = dict;
    
    [self addCountriesFromArray:body];
    id allCountries = [self getAllCountries];
    NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
    [currentUserDefault setObject:@"1" forKey:@"CountryListDownloaded"];
    completionHandler(allCountries);
    
}

+(void)callAllCountriesWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
   
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
   
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-all-countries-list"]
                      withComplitionHandler:^(id result) {
                          
                          @try {

                        if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                               
                            
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addCountriesFromArray:body];
                                
                                  id allCountries = [self getAllCountries];
                            
                            
                                 [currentUserDefault setObject:@"1" forKey:@"CountryListDownloaded"];
                            
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
};


+(void)addCountriesFromArray:(id)list{

    for (id currentObject in list) {
        
        
        NSLog(@"Check");
        
        if ([currentObject isKindOfClass:[NSString class]]) {

            NSLog(@"%@",list);
            
            [self addCountry:(int)[[[list objectForKey:currentObject] objectForKey:@"id"]
                                   integerValue]
                    withName:[[list objectForKey:currentObject] objectForKey:@"name"]
                 withFlagUrl:[[list objectForKey:currentObject] objectForKey:@"flag_url"]
                    withCode:(int)[[[list objectForKey:currentObject] objectForKey:@"code"] integerValue]
                 withCreated:[DateFormatter makeDataFromString:[[list objectForKey:currentObject]
                                                                objectForKey:@"created_at"]
                                               withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
               withUpdatedAt:[DateFormatter makeDataFromString:[[list objectForKey:currentObject] objectForKey:@"updated_at"]
                                               withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
            
        }
        else{
            [self addCountry:(int)[[currentObject objectForKey:@"id"] integerValue]
                    withName:[currentObject objectForKey:@"name"]
                 withFlagUrl:[currentObject objectForKey:@"flag_url"]
                    withCode:(int)[[currentObject objectForKey:@"code"] integerValue]
                 withCreated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                                               withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
               withUpdatedAt:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
            
        }
        
        
        
        
        

    
        
        
    }
}

+(Countries *)getCountryByName:(NSString *)name{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Countries"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@",name];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [results firstObject];
}

+(Countries *)getCountryById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Countries"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"countryId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [results firstObject];
}

+(id)getAllCountries{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Countries"];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"isActive == 1"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
    
}

+(void)addCountry:(int)countyId
         withName:(NSString *)name
      withFlagUrl:(NSString *)flagUrl
         withCode:(int)code
      withCreated:(NSDate *)createdAt
    withUpdatedAt:(NSDate *)updatedAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Countries ifRecordAlreadyExistsWithTagName:countyId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    Countries *currentCountry = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Countries"
                                 inManagedObjectContext:
                                 managedObjectContext];
    
    currentCountry.countryId = [NSNumber numberWithInt:countyId];
    currentCountry.flagUrl = flagUrl;
    currentCountry.code = [NSString stringWithFormat:@"%d",code];
    currentCountry.createdAt = createdAt;
    currentCountry.updatedAt = updatedAt;
    currentCountry.name = name;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
    
    
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)countryId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Countries"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"countryId == %@",[NSNumber numberWithInt:countryId]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Countries"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}



@end
