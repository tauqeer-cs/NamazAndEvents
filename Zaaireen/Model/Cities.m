//
//  Cities.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Cities.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "Countries.h"
#import "DateFormatter.h"

@implementation Cities


-(NSString *)latLongString{
    
    return
    [NSString stringWithFormat:@"%@ %@",self.lat,self.longitude];
    
}

-(NSString *)cityCommoCountry{
    
    return [NSString stringWithFormat:@"%@, %@",self.name,self.cityCountry.name];
}

+(void)callAllCitiesWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-all-cities-list"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  

                                  
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addFromArray:body];
                                  
                                  id allCountries = [self getAll];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"CityListDownloaded"];
                                  
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
        
        Countries *toAddCountry = [Countries getCountryById:[NSNumber numberWithInt:(int)[[currentObject objectForKey:@"country_id"] integerValue]]];
        
        
        if (!toAddCountry) {
            
            NSLog(@"Country Not Found");
        }
        
        [self addCity:(int)[[currentObject objectForKey:@"id"] integerValue]
        withCountryId:(int)[[currentObject objectForKey:@"country_id"] integerValue]
             withName:[currentObject objectForKey:@"name"]
             withWoid:[currentObject objectForKey:@"woeid"]
          withCreated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
         withLatitude:(double)[[currentObject objectForKey:@"latitude"] doubleValue]
             withLong:(double)[[currentObject objectForKey:@"longitude"] doubleValue]
         withTimeZone:[currentObject objectForKey:@"time_zone"] withCountry:toAddCountry
         withDetail:[currentObject objectForKey:@"description"]];
        

        
    }
    
    
    
    
    
    
}



+(id)getCitiesOfCountryById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Cities"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"countryId == %@",countryId];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return results;
}

+(Cities *)getCityByName:(NSString *)name{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Cities"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@",name];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];

    return [results firstObject];
}

+(Cities *)getById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Cities"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"cityId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] == 0) {
        
        return nil;
        
    }
    
    return [results firstObject];
}


+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Cities"];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"isActive == 1"];
    [request setReturnsObjectsAsFaults:YES];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(void)addCity:(int)cityId
 withCountryId:(int)countryId
         withName:(NSString *)name
        withWoid:(NSString *)woid
      withCreated:(NSDate *)createdAt
  withLatitude:(double)lat
      withLong:(double)longitude
  withTimeZone:(NSString *)givenTimeZone
   withCountry:(Countries *)country
    withDetail:(NSString *)detail
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Cities ifRecordAlreadyExistsWithTagName:cityId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    
    Cities *currentCity = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Cities"
                                 inManagedObjectContext:
                                 managedObjectContext];
    
    currentCity.cityId = [NSNumber numberWithInt:cityId];
    currentCity.countryId = [NSNumber numberWithInt:countryId];
    currentCity.woeid = woid;
    currentCity.name = name;
    currentCity.createdAt = createdAt;
    currentCity.lat = [NSNumber numberWithDouble:lat];
    currentCity.longitude = [NSNumber numberWithDouble:longitude];
    currentCity.time_zone =  givenTimeZone;
    currentCity.cityCountry = country;
    currentCity.detail = detail;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)countryId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Cities"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"cityId == %@",[NSNumber numberWithInt:countryId]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Cities"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}



@end
