//
//  AssetType.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "AssetType.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "Config.h"
#import "DateFormatter.h"

@implementation AssetType


+(void)loadFirstTimeDataFromPlistWithComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
 
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AssetTypeList" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
 
    
    id body = dict;
    
    [self addFromArray:body];
    id allCountries = [self getAll];
    NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
    [currentUserDefault setObject:@"1" forKey:@"AssetTypeDownloaded"];
    completionHandler(allCountries);
    
    NSLog(@"c");
    
}


+(void)callAssetTypeWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];

    
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-assets-types"]
                      withComplitionHandler:^(id result) {
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  id body = [result objectForKey:@"body"];
                                  [self addFromArray:body];
                                  id allCountries = [self getAll];
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"AssetTypeDownloaded"];
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
    
    
    NSDictionary *tmpDict = list;
    
    for (id currentObject in list) {
        
        
        if ([currentObject isKindOfClass:[NSString class]]) {

            [self add:(int)[[[tmpDict objectForKey:currentObject] objectForKey:@"id"] integerValue]
            withTitle:[[tmpDict objectForKey:currentObject] objectForKey:@"title"]
           withDetail:[[tmpDict objectForKey:currentObject] objectForKey:@"description"]
      withCreatedDate:[DateFormatter makeDataFromString:[[tmpDict objectForKey:currentObject] objectForKey:@"created_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
        withUpdatedAt:[DateFormatter makeDataFromString:[[tmpDict objectForKey:currentObject] objectForKey:@"created_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
            
        }
        else{
            
            [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
            withTitle:[currentObject objectForKey:@"title"]
           withDetail:[currentObject objectForKey:@"description"]
      withCreatedDate:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
        withUpdatedAt:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
        }
    }
}


+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetType"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

/*

 */

+(void)add:(int)assetTypeId
 withTitle:(NSString *)title
withDetail:(NSString *)detail
withCreatedDate:(NSDate *)createdAt
withUpdatedAt:(NSDate *)updatedAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([AssetType ifRecordAlreadyExistsWithTagName:assetTypeId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    AssetType *currentItem = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"AssetType"
                                 inManagedObjectContext:
                                 managedObjectContext];
    
    currentItem.assetTypeId = [NSNumber numberWithInt:assetTypeId];
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

+(AssetType *)getAssetTypeById:(NSNumber *)assetTypeId
{
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetType"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"assetTypeId == %@",assetTypeId];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] == 0) {
        return nil;
        
    }
    return results[0];
    
}

+(void)removeAllObject{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetType"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}
+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"AssetType"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"assetTypeId == %@",[NSNumber numberWithInt:Id]];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    if ([results count] > 0) {
        
        return YES;
    }
    return NO;
}

@end
