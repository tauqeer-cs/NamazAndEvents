//
//  Asset.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Asset.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "Config.h"
#import "DateFormatter.h"
#import "AssetType.h"
#import "Cities.h"

@implementation Asset


+(void)callGetAssetListWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId
                withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    [currentDictionary setObject:@"" forKey:@"limit"];
    
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
    @[@"upper_limit",@"lower_limit",@"limit"]
    urlCalling:[baseServiceUrl stringByAppendingString:@"zaair/get-asset-list"]
    withComplitionHandler:^(id result)
     {
        @try {
            if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                
                id body = [result objectForKey:@"body"];
                [self addFromArray:body];
                id allCountries = [self getAll];
                NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                [currentUserDefault setObject:@"1" forKey:@"AssetsDownloaded"];
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
       
        @try {
            
            
          
            AssetType *assetType = [AssetType getAssetTypeById:[NSNumber numberWithInt:(int)[[currentObject objectForKey:@"assets_type_id"] integerValue]]];
            
            Cities *currentCity = [Cities getById:[NSNumber numberWithInt:(int)[[currentObject objectForKey:@"city_id"] integerValue]]];
            
            
            if(!currentCity)
            {
                currentCity = nil;
            }
            if (!assetType) {
                assetType = nil;
                
            }
            [self add:(int)[[currentObject objectForKey:@"id"] integerValue]
            withTitle:[currentObject objectForKey:@"title"]
           withDetail:[currentObject objectForKey:@"description"]
      withAssetTypeId:(int)[[currentObject objectForKey:@"assets_type_id"] integerValue]
         withAssetUrl:[currentObject objectForKey:@"assets_url"]
            withExtra:[currentObject objectForKey:@"extra"]
      withCreatedDate:
             [DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"] withAttribute:@""
           withStatus:[[currentObject objectForKey:@"is_status"] integerValue] == 1 ? YES : NO
          withUpdated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"]
                                        withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
           withCityId:(int)[[currentObject objectForKey:@"city_id"] integerValue]
        withAssetType:assetType
             withCity:currentCity withAssetSize:(int)[[currentObject objectForKey:@"asset_size"] integerValue] withMediaType:[currentObject objectForKey:@"media_type"]];
        }
        @catch (NSException *exception) {
         
            NSLog(@"Error in Asset");
        
        }
    }
    
    

}

+(id)getWithId:(NSNumber *)itemId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Asset"];
    request.predicate = [NSPredicate predicateWithFormat:@"assetId == %@",itemId];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
 
    if ([results count] == 0) {
        return nil;
        
    }
    return results[0];
}

+(id)getAllWithId:(int)itemId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Asset"];
    request.predicate = [NSPredicate predicateWithFormat:@"assetId == %@",[NSNumber numberWithInt:itemId]];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] > 0 ) {
       return  [results firstObject];
    }
    return nil;
}

+(id)getAllWithCityId:(NSNumber *)cityId
{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Asset"];
    request.predicate = [NSPredicate predicateWithFormat:@"cityDetail.cityId == %@",cityId];
    
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Asset"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}

+(void)updateById:(NSNumber *)assetId isDownload:(BOOL)isDownload
{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Asset"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"assetId == %@",assetId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] > 0) {
        Asset *currentItem = [results firstObject];
        if (isDownload) {
        currentItem.isDowloaded = [NSNumber numberWithInt:1];
        }
        else
        currentItem.isDowloaded = [NSNumber numberWithInt:0];
        
        
        

        [managedObjectContext save:&error];
    }
}

+(void)add:(int)itemId
    withTitle:(NSString *)title
   withDetail:(NSString *)detail
withAssetTypeId:(int)assetTypeId
withAssetUrl:(NSString *)assetUrl
withExtra:(NSString *)extra
withCreatedDate:(NSDate *)createdAt
withAttribute:(NSString *)attribute
withStatus:(BOOL)status
withUpdated:(NSDate *)updatedAt
withCityId:(int)cityId
withAssetType:(AssetType *)assetType
withCity:(Cities *)city
withAssetSize:(int)size
withMediaType:(NSString *)mediaTypee
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Asset ifRecordAlreadyExistsWithTagName:itemId])
        return;
    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    Asset *currentItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Asset"
                         inManagedObjectContext:
                         managedObjectContext];
    
    currentItem.assetId= [NSNumber numberWithInteger:itemId];
    currentItem.title = title;
    currentItem.detail = detail;
    currentItem.assetTypeId = [NSNumber numberWithInt:itemId];
        currentItem.isDowloaded = [NSNumber numberWithInt:0];
    

    currentItem.assetUrl = assetUrl;
    
    currentItem.createdAt = createdAt;
    currentItem.extra = extra;
    currentItem.isStatus = [NSNumber numberWithBool:status];
    currentItem.attribute = attribute;
    currentItem.updatedAt = updatedAt;
    currentItem.cityId = [NSNumber numberWithInt:cityId];
    currentItem.assetSize = [NSNumber numberWithInt:size];
    currentItem.mediaType = mediaTypee;
    
    if (assetType) {
    currentItem.assetType =assetType;
    }
    
    if (city) {
    currentItem.cityDetail = city;
    }
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}


+(BOOL)ifRecordAlreadyExistsWithTagName:(int)Id{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Asset"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"assetId == %@",[NSNumber numberWithInt:Id]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Asset"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}

@end
