//
//  LandmarkType.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "LandmarkType.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"

@implementation LandmarkType

+(void)loadFirstTimeDataFromPlistWithComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LandmarkTypePropertyList" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    id body = dict;
    
    [self addFromArray:body];
    id allCountries = [self getAll];
    NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
    [currentUserDefault setObject:@"1" forKey:@"LandmarkTypeDownloaded"];
    completionHandler(allCountries);
}


+(void)callLandmarkTypeWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                         withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    

    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-landmark-types"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  id body = [result objectForKey:@"body"];
                                  [self addFromArray:body];
                                  id allCountries = [self getAll];
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"LandmarkTypeDownloaded"];
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

+(void)addFromArray:(id)list{
    
    for (id currentObject in list) {
        

        if ([currentObject isKindOfClass:[NSString class]]) {
            
            
            [self add:(int)[[[list objectForKey:currentObject] objectForKey:@"id"] integerValue]
            withTitle:[[list objectForKey:currentObject] objectForKey:@"title"]
           withDetail:[[list objectForKey:currentObject] objectForKey:@"description"]
      withCreatedDate:[DateFormatter makeDataFromString:[[list objectForKey:currentObject] objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
        withUpdatedAt:[DateFormatter makeDataFromString:[[list objectForKey:currentObject] objectForKey:@"updated_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
            
            
        }
        else{
        
            [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
    withTitle:[currentObject objectForKey:@"title"]
       withDetail:[currentObject objectForKey:@"description"]
  withCreatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
    withUpdatedAt:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"]
                                    withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        
        }
    }
}


+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkType"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(void)add:(int)landmarkTypeId
withTitle:(NSString *)title
   withDetail:(NSString *)detail
withCreatedDate:(NSDate *)createdAt
withUpdatedAt:(NSDate *)updatedAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([LandmarkType ifRecordAlreadyExistsWithTagName:landmarkTypeId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    LandmarkType *currentItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"LandmarkType"
                         inManagedObjectContext:
                         managedObjectContext];
    
    currentItem.landmarkTypeId = [NSNumber numberWithInt:landmarkTypeId];
    currentItem.title = title;
    currentItem.detail = detail;
    currentItem.createdAt = createdAt;
    currentItem.updatedAt = updatedAt;
    currentItem.createdAt = createdAt;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}




+(LandmarkType *)getLandmarkTypeById:(NSNumber *)landmarkId
{
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkType"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkTypeId == %@",landmarkId];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if ([results count] == 0) {
        return nil;
        
    }
    return results[0];
    
}
+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkType"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkTypeId == %@",[NSNumber numberWithInt:Id]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"LandmarkType"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}


@end
