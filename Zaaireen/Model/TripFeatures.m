//
//  TripFeatures.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "TripFeatures.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "Countries.h"
#import "DateFormatter.h"
#import "Trips.h"


@implementation TripFeatures

// Insert code here to add functionality to your managed object subclass



+(void)callTripFeaturesWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-trip-features"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  
                                  
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addFromArray:body];
                                  
                                  id allCountries = [self getAll];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"TripFeaturesDownloaded"];
                                  
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

/*

 Trips *trip;
 */

+(void)addFromArray:(NSArray *)list
{
    
    for (id currentObject in list) {
        
        
        NSLog(@"%@",currentObject);
        
        
        [self addTfId:(int)[[currentObject objectForKey:@"id"] integerValue] witTripId:(int)[[currentObject objectForKey:@"trip_id"] integerValue] witOrderBy:(int)[[currentObject objectForKey:@"order_by"] integerValue] witCValue:[currentObject objectForKey:@"c_value"] witCName:[currentObject objectForKey:@"c_name"]];
        
    }
    
    id all = [self getAll];
    
    NSLog(@"%@",all);
    
}

+(void)addTfId:(int)tfId
     witTripId:(int)tripId
    witOrderBy:(int)orderBy
    witCValue:(NSString *)cValue
    witCName:(NSString *)cName
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([TripFeatures ifRecordAlreadyExistsWithTagName:tfId])
        return;
    
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    TripFeatures *currentItem = [NSEntityDescription
                               insertNewObjectForEntityForName:@"TripFeatures"
                               inManagedObjectContext:
                               managedObjectContext];
    
    currentItem.tfId = [NSNumber numberWithInt:tfId];
    currentItem.tripId = [NSNumber numberWithInt:tripId];
    currentItem.order_by = [NSNumber numberWithInt:orderBy];
    currentItem.cValue = cValue;
    currentItem.cName = cName;
    

    Trips *trip = [Trips getTripById:tripId];
    
    if (tripId) {
        currentItem.trip = trip;
    }
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(id)getByIdTripId:(NSNumber *)tripId
{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripFeatures"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tfId == %@",tripId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    if ([results count] == 0) {
        
        return nil;
        
    }
    return results[0];
}
+(TripFeatures *)getCountryById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripFeatures"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tfId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [results firstObject];
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripFeatures"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order_by"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)tcId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripFeatures"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tfId == %@",[NSNumber numberWithInt:tcId]];
    
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripFeatures"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    [managedObjectContext save:&error];
}





@end
