//
//  TripCities.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "TripCities.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"

@implementation TripCities


+(void)addFromArray:(NSArray *)list
{
    
    for (id currentObject in list) {
        
        
        NSLog(@"%@",currentObject);
        

        [self addTcId:(int)[[currentObject objectForKey:@"id"] integerValue] witTripId:(int)[[currentObject objectForKey:@"trip_id"] integerValue] witCityId:(int)[[currentObject objectForKey:@"city_id"] integerValue] witOrderBy:(int)[[currentObject objectForKey:@"order_by"] integerValue]];
        
        
        
    }
    
    id all = [self getAll];
    
    NSLog(@"%@",all);
    
}

+(void)addTcId:(int)tcId
    witTripId:(int)tripId
    witCityId:(int)cityId
    witOrderBy:(int)orderBy
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([TripCities ifRecordAlreadyExistsWithTagName:tripId])
        return;
    
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    TripCities *currentItem = [NSEntityDescription
                          insertNewObjectForEntityForName:@"TripCities"
                          inManagedObjectContext:
                          managedObjectContext];
    
    currentItem.tcId = [NSNumber numberWithInt:tcId];
   currentItem.tripId = [NSNumber numberWithInt:tripId];
    currentItem.cityId = [NSNumber numberWithInt:cityId];
    currentItem.orderBy = [NSNumber numberWithInt:orderBy];
    
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
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripCities"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tripId == %@",tripId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    if ([results count] == 0) {
        
        return nil;
        
    }
    return results[0];
}

+(TripCities *)getCountryById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripCities"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tcId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [results firstObject];
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripCities"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)tcId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripCities"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tcId == %@",[NSNumber numberWithInt:tcId]];
    
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripCities"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    [managedObjectContext save:&error];
}




@end
