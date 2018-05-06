//
//  LandmarkPersonalityDetail.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "LandmarkPersonalityDetail.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "Cities.h"
#import "Asset.h"
#import "AssetsDetail.h"
@implementation LandmarkPersonalityDetail

/*
@property (nullable, nonatomic, retain) NSNumber *landmarkPersonalityDetailId;
@property (nullable, nonatomic, retain) NSNumber *landmarkId;
@property (nullable, nonatomic, retain) NSNumber *personalityId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *extra;

 //api/zaair/
 
 */


+(void)callAll:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-all-data"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  NSLog(@"Called");
                                  
                                  //id body = [[result objectForKey:@"body"] objectForKey:@"landmark_personality_detail"];
                                  

                                    [Cities addFromArray:[[result objectForKey:@"body"] objectForKey:@"cities"]];
                                  
                                  
                                    [AssetsDetail addFromArray:[[result objectForKey:@"body"] objectForKey:@"asset_detail"]];
                                  
                                  
                                  id allCountries = [self getAll];
                                  
                                  //NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  
                                  
                                [Asset addFromArray:[[result objectForKey:@"body"] objectForKey:@"assets"]];
                                 
                                  
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




+(void)callLandmarkPersonalityDetailsWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-landmarks-personality-list"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  NSLog(@"Called");
                                  
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addFromArray:body];
                                  
                                  id allCountries = [self getAll];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"LandmarkPersonalityDetailDownloaded"];
                                  
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
        
        NSLog(@"Check");
        
        
[self addItem:(int)[[currentObject objectForKey:@"id"] integerValue]
withLandmarkId:(int)[[currentObject objectForKey:@"landmarks_id"] integerValue]
withPersonalityId:(int)[[currentObject objectForKey:@"personality_id"] integerValue]
  withCreated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"] withExtra:[currentObject objectForKey:@"extra"]];
        

    }


    NSLog(@"We are done here");
}

+(id)getAllWithPersonalityId:(int)personalityId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkPersonalityDetail"];
    request.predicate = [NSPredicate predicateWithFormat:@"personalityId == %@",[NSNumber numberWithInt:personalityId]];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(id)getAllWithLandmarkIdId:(int)landmarkId
{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkPersonalityDetail"];
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkId == %@",[NSNumber numberWithInt:landmarkId]];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}





+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkPersonalityDetail"];
    //request.predicate = [NSPredicate predicateWithFormat:@"isActive == 1"];
    [request setReturnsObjectsAsFaults:YES];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

//landmarkPersonalityDetailId,landmarkId,personalityId,createdAt,EXTRA

+(void)addItem:(int)itemId
    withLandmarkId:(int)landmarkId
    withPersonalityId:(int)personalityId
   withCreated:(NSDate *)createdAt
     withExtra:(NSString *)extra
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([LandmarkPersonalityDetail ifRecordAlreadyExistsWithTagName:itemId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    LandmarkPersonalityDetail *currentCity = [NSEntityDescription
                           insertNewObjectForEntityForName:@"LandmarkPersonalityDetail"
                           inManagedObjectContext:
                           managedObjectContext];

    
    currentCity.landmarkPersonalityDetailId = [NSNumber numberWithInteger:itemId];
    currentCity.landmarkId = [NSNumber numberWithInteger:landmarkId];
    currentCity.personalityId = [NSNumber numberWithInteger:personalityId];
    currentCity.createdAt = createdAt;
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkPersonalityDetail"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkPersonalityDetailId == %@",[NSNumber numberWithInt:Id]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkPersonalityDetail"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}



@end
