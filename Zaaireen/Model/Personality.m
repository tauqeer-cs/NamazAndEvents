//
//  Personality.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Personality.h"
#import "Asset.h"
#import "PersonalityCharacteristics.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "AssetsDetail.h"

@implementation Personality

// Insert code here to add functionality to your managed object subclass

+(void)callPersonalitiesWithUpperLimit:(NSString *)upperLimit
                        withLowerLimit:(NSString *)lowerLimit
                             withAppId:(NSString *)appId
                 withComplitionHandler:(void(^)(id result))completionHandler
                     withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];

    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-all-personalities"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  NSLog(@"Called");
                                  
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addFromArray:body];
                                  
                                  id allCountries = [self getAll];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"PersonalityDownloaded"];
                                  
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
        
        
        [self addWithPersonalityId:(int)[[currentObject objectForKey:@"id"] integerValue]
                         withTitle:[currentObject objectForKey:@"title"]
                        withDetail:[currentObject objectForKey:@"description"]
                          withData:[currentObject objectForKey:@"personality_data"]
                    withPersonalityType:[currentObject objectForKey:@"personality_type"]
                       withCreated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                      withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
                       withUpdated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"]
                                                     withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        
        

    }
}

+(Personality *)getById:(NSNumber *)personalityId{

    @try {
        AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Personality"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"personalityId == %@",personalityId];
        
        [request setReturnsObjectsAsFaults:NO];
        
        NSError *error = nil;
        
        NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
        
        
        return [results firstObject];
    }
    @catch (NSException *exception) {
     
        return nil;
    }
}

+(id)searchPersonalityWithKeyWord:(NSString *)keyWord{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Personality"];
    
    request.predicate = [NSPredicate
                         predicateWithFormat:@"(ANY title CONTAINS[cd] %@ OR ANY detail CONTAINS[cd] %@ OR ANY data CONTAINS[cd] %@ OR ANY personality_type CONTAINS[cd] %@)",keyWord,keyWord,keyWord,keyWord];
    
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Personality"];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"isActive == 1"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(void)addWithPersonalityId:(int)personalityId
                  withTitle:(NSString *)title
                 withDetail:(NSString *)detail
                   withData:(NSString *)data
             withPersonalityType:(NSString *)personalityType
                withCreated:(NSDate *)createdAt
                withUpdated:(NSDate *)updatedAt
{
    @try {
        AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
        if ([Personality ifRecordAlreadyExistsWithTagName:personalityId])
            return;

        NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
        Personality *currentCity = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Personality"
                                    inManagedObjectContext:
                                    managedObjectContext];
        
        currentCity.personalityId = [NSNumber numberWithInt:personalityId];
        currentCity.title = title;
        currentCity.detail = detail;
        currentCity.data = data;
        currentCity.personality_type = personalityType;
        currentCity.updatedAt = updatedAt;
        currentCity.createdAt = createdAt;
        
        id currentCharecterisTics = [PersonalityCharacteristics getAllWithPersonalityId:personalityId];
        
        if([currentCharecterisTics count] > 0){
            [currentCity addCharacteristic:[NSSet setWithArray:currentCharecterisTics]];
        }
        
        id assetDetailList = [AssetsDetail getWithPersonalityId:personalityId];
        
        
        
        
        if ([assetDetailList count] > 0) {
            
            for (AssetsDetail *kha in assetDetailList) {
                
                Asset *currentAsset = [Asset getWithId:kha.assetId];
                
                
                [currentCity addPersonalityAssetsObject:currentAsset];
                
                
            }
            
            
            
            NSLog(@"");
            
        }
        
        NSError *error = nil;
        if (![managedObjectContext save:&error])
        {
            NSLog(@"error saving");
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"");
    }
    
    
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)personalityId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Personality"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"personalityId == %@",[NSNumber numberWithInt:personalityId]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Personality"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}



@end
