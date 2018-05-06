//
//  TripLandmarks.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "TripLandmarks.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"


@implementation TripLandmarks

+(void)addFromArray:(NSArray *)list
{
    
    for (id currentObject in list) {
        
        
        
        [self addtLId:(int)[[currentObject objectForKey:@"id"] integerValue]
            witTripId:(int)[[currentObject objectForKey:@"trip_id"] integerValue] witLandmarkId:(int)[[currentObject objectForKey:@"landmark_id"] integerValue]
           witOrderBy:(int)[[currentObject objectForKey:@"id"] integerValue]];
        
        
    }
    
    
}


+(void)addtLId:(int)tLId
     witTripId:(int)tripId
     witLandmarkId:(int)landmarkId
    witOrderBy:(int)orderBy
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([TripLandmarks ifRecordAlreadyExistsWithTagName:tLId])
        return;
    
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    TripLandmarks *currentItem = [NSEntityDescription
                               insertNewObjectForEntityForName:@"TripLandmarks"
                               inManagedObjectContext:
                               managedObjectContext];
    
    currentItem.tLId = [NSNumber numberWithInt:tLId];
    currentItem.tripId = [NSNumber numberWithInt:tripId];
    currentItem.landmarkId = [NSNumber numberWithInt:landmarkId];
    currentItem.orderBy = [NSNumber numberWithInt:orderBy];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}



+(id)getByTripId:(NSNumber *)countryId
{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripLandmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tripId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return results;
}

+(TripLandmarks *)getById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripLandmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tLId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [results firstObject];
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripLandmarks"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)tcId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripLandmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"tLId == %@",[NSNumber numberWithInt:tcId]];
    
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"TripLandmarks"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    [managedObjectContext save:&error];
}




@end
