//
//  Landmarks.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "Landmarks.h"
#import "RestCall.h"
#import "Config.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "AssetsDetail.h"
#import "LandmarkPersonalityDetail.h"
#import "Cities.h"
#import "LandmarkType.h"

@implementation Landmarks

// Insert code here to add functionality to your managed object subclass

-(NSString *)largeAddress{
    
    if ([self.address length] > 0) {
        
       return  [NSString stringWithFormat:@"%@, %@ %@",
                                            self.address
                                            ,self.cityDetail.name,
                                            self.cityDetail.cityCountry.name];
        
    }

        
    return  [NSString stringWithFormat:@"%@ %@",
                                            self.cityDetail.name,
                                            self.cityDetail.cityCountry.name];

}

-(NSDictionary *)detaillForPools{
    
id tmp = [RestCall makeObjectFromJSON:self.detail];
    return tmp;
    
    
}

-(NSDictionary *)extraObjectsForPools{
    
    
    id tmp = [RestCall makeObjectFromJSON:self.extra];
    
    return [tmp objectForKey:@"pole_services"];
}


-(BOOL)isWaterAvailable{
    
    if ([[self.extraObjectsForPools objectForKey:@"water"] integerValue] == 1) {
        
        return YES;
    }
    return NO;
}

-(BOOL)isWashroomAvailable{
    
    if ([[self.extraObjectsForPools objectForKey:@"washroom"] integerValue] == 1) {
        
        return YES;
    }
    return NO;
}

-(BOOL)isMedicalAvailable{
    
    if ([[self.extraObjectsForPools objectForKey:@"medical"] integerValue] == 1) {
        
        return YES;
    }
    return NO;
}


-(BOOL)isFoodAvailable{
    
    if ([[self.extraObjectsForPools objectForKey:@"food"] integerValue] == 1) {
        
        return YES;
    }
    return NO;
}

-(BOOL)isCheckPostAvailable{
    
    if ([[self.extraObjectsForPools objectForKey:@"checkpost"] integerValue] == 1) {
        
        return YES;
    }
    return NO;
}

-(BOOL)isBedAvailable{
    
    if ([[self.extraObjectsForPools objectForKey:@"bed"] integerValue] == 1) {
        
        return YES;
    }
    return NO;
}
-(NSString *)englishDetailOfPool{
    return [[self.detaillForPools objectForKey:@"english"] capitalizedString];
}
-(NSArray *)nearByLandmarks{
    
    id all = [[RestCall makeObjectFromJSON:self.extra] objectForKey:@"nearby"];
    
    return all;
}
-(NSArray *)allImages{

    if ([self.imageUrl length] == 0) {
        
        return nil;
        
    }
    return [self.imageUrl componentsSeparatedByString:@","];
}

-(NSString *)giveFirstImage{
    
    return [[self allImages] firstObject];
}

+(void)callLandmarksDetailUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId
withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    
    
    [currentDictionary setObject:@"landmark" forKey:@"type"];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"type",@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/get-ziaraat-description"]
                      withComplitionHandler:^(id result) {
                          
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  
                                  id body = [result objectForKey:@"body"];
                                  [self updateFromArray:body];
                                
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"LandmarksDetailDownloaded"];
                                  
                                  completionHandler(nil);
                                  
                                  
                                }
                              else{
                                 failureHandler();
                              }
                              
                          }
                          @catch (NSException *exception) {
                              
                              failureHandler();
                              
                              
                          }
                          
                      } failureComlitionHandler:^{
                          
                         // failureHandler();
                          failureHandler();
                          
                          
                      }];
}

+(void)callLandmarksWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler
{
    
    NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
    [currentDictionary setObject:upperLimit forKey:@"upper_limit"];
    [currentDictionary setObject:lowerLimit forKey:@"lower_limit"];
    
    [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:
     @[@"upper_limit",@"lower_limit"]
                                 urlCalling:
     [baseServiceUrl stringByAppendingString:@"zaair/all-ziaraat-landmarks"]
                      withComplitionHandler:^(id result) {
                          
                          
                          @try {
                              
                              if ([[[result objectForKey:@"header"] objectForKey:@"code"] integerValue] == 0) {
                                  

                                  
                                  id body = [result objectForKey:@"body"];
                                  
                                  [self addFromArray:body];
                                  
                                  id all = [self getAll];
                                  
                                  NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
                                  [currentUserDefault setObject:@"1" forKey:@"LandmarksDownloaded"];
                                  
                                  completionHandler(all);
                                  
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

+(void)updateById:(NSNumber *)landmarkId withNewDetail:(NSString *)newDetail{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkId == %@",landmarkId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] > 0) {
        Landmarks *currentLandmarks = [results firstObject];
        currentLandmarks.detail = newDetail;
        [managedObjectContext save:&error];
    }
}

+(void)updateFromArray:(NSArray *)list{
    
    for (id currentObject in list) {
        
        [self updateById:[NSNumber numberWithInt:(int)[[currentObject objectForKey:@"id"] integerValue]] withNewDetail:[currentObject objectForKey:@"description"]];
        
            
        
    }
}
+(void)addFromArray:(NSArray *)list{
    
    for (id currentObject in list) {
        
        
        NSLog(@"");
        
        [self addLandmark:(int)[[currentObject objectForKey:@"id"] integerValue]
                withTitle:[currentObject objectForKey:@"title"]
               withDetail:[currentObject objectForKey:@"description"]
               withGeoLat:(double)[[currentObject objectForKey:@"latitude"] doubleValue]
              withGeoLong:(double)[[currentObject objectForKey:@"longitude"] doubleValue]
       withLandmarkTypeId:(int)[[currentObject objectForKey:@"landmark_type_id"] integerValue]
              withAddress:[currentObject objectForKey:@"address"]
               withCityId:(int)[[currentObject objectForKey:@"city_id"] integerValue]
             withImageUrl:[currentObject objectForKey:@"image_url"]
           withIsFeatured:[[currentObject objectForKey:@"is_featured"] integerValue] == 1 ? YES : NO
                withExtra:[currentObject objectForKey:@"extra"]
            withAttribute:@""
              withUpdated:
         [DateFormatter makeDataFromString:[currentObject objectForKey:@"updated_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]
              withCreated:[DateFormatter makeDataFromString:[currentObject objectForKey:@"created_at"] withDateFormate:@"yyyy-MM-dd HH:mm:ss"]];
    }
}

+(id)searchMark:(NSString *)keyWord
{
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    keyWord = [@"" stringByAppendingString:[keyWord stringByAppendingString:@""]];
    keyWord = [keyWord lowercaseString];
    request.predicate = [NSPredicate
                         predicateWithFormat:@"(ANY title CONTAINS[cd] %@ OR ANY detail CONTAINS[cd] %@ OR ANY landmarkTypeDetail.title CONTAINS[cd] %@)",keyWord,keyWord,keyWord];
    
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}

-(NSString *)latLongString{
    
    return [NSString stringWithFormat:@"%@ %@",self.geo_lat,self.geo_long];
    
}

+(id)searchMark:(NSString *)keyWord withCityId:(NSNumber *)cityId
{
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    keyWord = [@"" stringByAppendingString:[keyWord stringByAppendingString:@""]];
    keyWord = [keyWord lowercaseString];
    request.predicate = [NSPredicate
                         predicateWithFormat:@"(ANY title CONTAINS[cd] %@ OR ANY detail CONTAINS[cd] %@ OR ANY landmarkTypeDetail.title CONTAINS[cd] %@) AND cityId = %@",keyWord,keyWord,keyWord,cityId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    return results;
}


+(id)getByCityId:(NSNumber *)cityId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"cityId == %@ AND landmarkTypeDetail.landmarkTypeId != 20",cityId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return results;
}

+(id)getTripPoolsByCityId:(NSNumber *)cityId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    //cityId == %@ AND
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkTypeDetail.landmarkTypeId == 20",cityId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return results;
}



+(id)getById:(NSNumber *)landmarkId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkId == %@",landmarkId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] == 0) {
        return nil;
    }
    return results[0];
}

+(Landmarks *)getCountryById:(NSNumber *)countryId{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"cityId == %@",countryId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    
    return [results firstObject];
}

+(id)getAll{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"isActive == 1"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    return results;
}


+(void)updateAllLandmarkAssetAssosiation{
   
    
    for (Landmarks *currentLandmark in [Landmarks getAll]) {
        
        [Landmarks updateById:currentLandmark.landmarkId];
   }
}
+(void)updateById:(NSNumber *)landmarkId
{
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkId == %@",landmarkId];
    
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    if ([results count] > 0) {
        Landmarks *currentItem = [results firstObject];
        
        id assetDetailList =  [AssetsDetail getWithLandmarkId:[landmarkId intValue]];;
    
        if ([assetDetailList count] > 0) {
            
            
            for (AssetsDetail *kha in assetDetailList) {
                
                Asset *currentAsset = [Asset getWithId:kha.assetId];
                
                [currentItem addAssetsObject:currentAsset];
                
            }
            
        }
        
        [managedObjectContext save:&error];
    
    
    }
}

+(void)addLandmark:(int)landmarkId
      withTitle:(NSString *)title
      withDetail:(NSString *)detail
      withGeoLat:(double)geo_lat
      withGeoLong:(double)geo_long
      withLandmarkTypeId:(int)landmarkTypeId
      withAddress:(NSString *)address
      withCityId:(int)cityId
      withImageUrl:(NSString *)imageUrl
      withIsFeatured:(BOOL )isFeatured
      withExtra:(NSString *)extra
      withAttribute:(NSString *)attribute
      withUpdated:(NSDate *)updatedAt
      withCreated:(NSDate *)createdAt
{
    AppDelegate *tm = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([Landmarks ifRecordAlreadyExistsWithTagName:landmarkId])
        return;
    
    

    
    NSManagedObjectContext *managedObjectContext = tm.managedObjectContext;
    Landmarks *currentCity = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Landmarks"
                           inManagedObjectContext:
                           managedObjectContext];
    
    currentCity.landmarkId = [NSNumber numberWithInt:landmarkId];
    currentCity.title = title;
    
    if (landmarkTypeId == 20) {
        
        NSLog(@"");
        
        
    }
    currentCity.detail = detail;
    
    currentCity.geo_lat = [NSNumber numberWithDouble:geo_lat];
    currentCity.geo_long = [NSNumber numberWithDouble:geo_long];
    currentCity.landmarkTypeId = [NSNumber numberWithInt:landmarkTypeId];
    currentCity.address = address;
    
    currentCity.cityId = [NSNumber numberWithDouble:cityId];
    
    
    currentCity.cityDetail = [Cities getById:[NSNumber numberWithDouble:cityId]];
    if (!currentCity.cityDetail) {
    
        
        
    }
    
    
    currentCity.imageUrl = imageUrl;
    currentCity.isFeatured = [NSNumber numberWithBool:isFeatured];
    currentCity.extra = extra;
    currentCity.attribute = attribute;
    currentCity.createdAt = updatedAt;
    currentCity.createdAt = createdAt;
    if (landmarkTypeId > 0) {
    currentCity.landmarkTypeDetail = [LandmarkType getLandmarkTypeById:[NSNumber numberWithInt:landmarkTypeId]];
    }


    
    id assetDetailList = [AssetsDetail getWithLandmarkId:landmarkId];
    
    if ([assetDetailList count] > 0) {
       

        for (AssetsDetail *kha in assetDetailList) {
            
            Asset *currentAsset = [Asset getWithId:kha.assetId];
            if (currentAsset) {
                [currentCity addAssetsObject:currentAsset];
                
            }

        }
    
    }
    
    id currentLandMarkPersonalities = [LandmarkPersonalityDetail getAllWithLandmarkIdId:landmarkId];
    
    for (LandmarkPersonalityDetail * currentLandmarkPD in currentLandMarkPersonalities) {
        
        Personality *currentPersonality = [Personality getById:currentLandmarkPD.personalityId];
        if (currentPersonality) {
        [currentCity addPersonalitiesObject:currentPersonality];
            
        }
    }
    
    
    NSError *error = nil;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"error saving");
    }
}

+(BOOL)ifRecordAlreadyExistsWithTagName:(int)landmarkId{
    
    
    AppDelegate *tmp = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *managedObjectContext = tmp.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"landmarkId == %@",[NSNumber numberWithInt:landmarkId]];
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
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Landmarks"];
    [request setReturnsObjectsAsFaults:NO];
    
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    
    for (NSManagedObject * record in results) {
        [managedObjectContext deleteObject:record];
    }
    
    
    [managedObjectContext save:&error];
}




@end
