//
//  AssetsDetail.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "AssetsDetail.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "Config.h"
#import "DateFormatter.h"

@implementation AssetsDetail

// Insert code here to add functionality to your managed object subclass
/*
NSNumber *assetDetailId;
NSString *assetId;
NSNumber *targetId;
NSString *targetType;
NSDate *createdAt;
NSDate *updatedAt;
 */


+(void)callGetAssetDetailWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
  @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-asset-detail-list"]
                      withComplitionHandler:^(id result) {
                          
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  id body = [result objectForKey:@"body"];
                                  [self addFromArray:body];
                                  id allCountries = [self getAll];
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"AssetsDetailDownloaded"];
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
      withAssetId:(int)[[currentObject objectForKey:@"assets_id"] integerValue]
    withTargetId:(int)[[currentObject objectForKey:@"target_id"]  integerValue]
   withTargetType:[currentObject objectForKey:@"target_type"]
  withCreatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                                    withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
    withUpdatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"]
                                      withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        
        

        
    }
    
    NSLog(@"%@",[self getAll]);
}

+(id)getAllWithPersonalityId:(int)assetDetailId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetsDetail"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"assetDetailId == %@",[NSNumber numberWithInt:assetDetailId]];
    
    
    [request setReturnsObjectsAsFaults:YES];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetsDetail"];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"isActive == 1"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(id)getWithPersonalityId:(int)personalityId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetsDetail"];
    

    //
    request.predicate = [NSPredicate predicateWithFormat:@"targetType == %@ AND targetId == %@",@"personality",[NSNumber numberWithInt:personalityId]];
    
    
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(id)getWithLandmarkId:(int)landmarkId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetsDetail"];
    
    
    //
    request.predicate = [NSPredicate predicateWithFormat:@"targetType == %@ AND targetId == %@",@"landmarks",[NSNumber numberWithInt:landmarkId]];
    
    
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}






+(void)add:(int)ItemId
    withAssetId:(int)assetId
    withTargetId:(int)targetId
  withTargetType:(NSString *)TargetType
 withCreatedDate:(NSDate *)createdAt
withUpdatedDate:(NSDate *)updatedAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([AssetsDetail ifRecordAlreadyExistsWithTagName:ItemId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    AssetsDetail *currentItem = [NSEntityDescription
                                               insertNewObjectForEntityForName:@"AssetsDetail"
                                               inManagedObjectContext:
                                               managedObjectContext];
    
    
    
    currentItem.assetDetailId = [NSNumber numberWithInteger:ItemId];
    currentItem.assetId = [NSNumber numberWithInteger:assetId];
    currentItem.targetId = [NSNumber numberWithInteger:targetId];
    currentItem.createdAt = createdAt;
    currentItem.updatedAt = updatedAt;
    currentItem.targetType = TargetType;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetsDetail"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"assetDetailId == %@",[NSNumber numberWithInt:Id]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetsDetail"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}

@end
