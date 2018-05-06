//
//  Trips.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Trips.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "TripCities.h"
#import "TripLandmarks.h"
#import "Cities.h"

@implementation Trips

+(void)callTripDetailUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    
    NSMutableDictionary *innerDictionary = [NSMutableDictionary new];
    NSMutableDictionary *tmpTripLandmarks = [NSMutableDictionary new];
    [tmpTripLandmarks setObject:@"1" forKey:@"flag"];
    [tmpTripLandmarks setObject:@"" forKey:@"upper_limit"];
    [tmpTripLandmarks setObject:@"" forKey:@"lower_limit"];
    
    [innerDictionary setObject:tmpTripLandmarks forKey:@"trip_landmarks"];
    tmpTripLandmarks  =  [NSMutableDictionary new];

    [tmpTripLandmarks setObject:@"1" forKey:@"flag"];
    [tmpTripLandmarks setObject:@"" forKey:@"upper_limit"];
    [tmpTripLandmarks setObject:@"" forKey:@"lower_limit"];

    
    [innerDictionary setObject:tmpTripLandmarks forKey:@"trips"];

    tmpTripLandmarks  =  [NSMutableDictionary new];
    
    [tmpTripLandmarks setObject:@"1" forKey:@"flag"];
    [tmpTripLandmarks setObject:@"" forKey:@"upper_limit"];
    [tmpTripLandmarks setObject:@"" forKey:@"lower_limit"];
    [innerDictionary setObject:tmpTripLandmarks forKey:@"trip_cities"];
    
    [currentDictionary setObject:[RestCall encodeToJSONStringFromDictionary:innerDictionary]
                          forKey:@"extra"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"extra"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-trip-detail"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  id body = [result objectForKey:@"body"];
                             
                                  id tripCities = [body objectForKey:@"trip_cities"];
                                  
                                  [TripCities addFromArray:tripCities];
                                  
                                  id tripLandmarks = [body objectForKey:@"trip_landmarks"];
                                  [TripLandmarks addFromArray:tripLandmarks];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"TripDetailDownloaded"];
                                  
                                  id trips = [body objectForKey:@"trips"];
                                  [self addFromArray:trips];
                                  
                                  
                                  completionHandler([self getAll]);
                                  
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
        
        
        NSLog(@"%@",currentObject);
        
        [self addTrip:(int)[[currentObject objectForKey:@"id"] integerValue]
    withTitle:[currentObject objectForKey:@"title"]
    withDetail:[currentObject objectForKey:@"description"]
    withType:[currentObject objectForKey:@"trip_type"]
    withExtra:[currentObject objectForKey:@"extra"]
           withStatus:(int)[[currentObject objectForKey:@"status"] integerValue]
          withUpdated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"] withCreated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
    }
    
    id all = [self getAll];

    NSLog(@"%@",all);
    
}






+(void)addTrip:(int)tripId
         withTitle:(NSString *)title
        withDetail:(NSString *)detail
withType:(NSString *)tripType
         withExtra:(NSString *)extra
    withStatus:(int)status
       withUpdated:(NSDate *)updatedAt
       withCreated:(NSDate *)createdAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Trips ifRecordAlreadyExistsWithTagName:tripId])
        return;
    
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    Trips *currentCity = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Trips"
                              inManagedObjectContext:
                              managedObjectContext];
    
    currentCity.tripId = [NSNumber numberWithInt:tripId];
    currentCity.title = title;
    currentCity.detail = detail;
    currentCity.tripType = tripType;
    currentCity.extra = extra;
    currentCity.status = [NSNumber numberWithDouble:status];
    currentCity.createdAt = createdAt;
    currentCity.updatedAt = updatedAt;
    
   TripCities * check = [TripCities getByIdTripId:[NSNumber numberWithInt:tripId]];
    
    currentCity.tripCity = [Cities getById:check.cityId];
    
    
    NSArray *landmarks = [TripLandmarks getByTripId:[NSNumber numberWithInt:tripId]];
    
    
    for (TripLandmarks *currentItem in landmarks) {
        
        [currentCity addTripLandmarksObject:
        [Landmarks getById:currentItem.landmarkId]];
        
        
    }
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}


+(Trips *)getCountryById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Trips"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tripId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [results firstObject];
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Trips"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(id)getTripById:(int)itemId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Trips"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tripId == %@",[NSNumber numberWithInt:itemId]];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];

    if ([results count] >0) {
    return results[0];
    }
    
    return nil;
}


+(BOOL)ifRecordAlreadyExistsWithTagName:(int)landmarkId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Trips"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tripId == %@",[NSNumber numberWithInt:landmarkId]];
    
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Trips"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    [managedObjectContext save:&error];
}





@end
