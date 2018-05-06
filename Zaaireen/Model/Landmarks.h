//
//  Landmarks.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Landmarks : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callLandmarksWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(void)callLandmarksDetailUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId
               withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;


+(id)getByCityId:(NSNumber *)cityId;

+(id)searchMark:(NSString *)keyWord withCityId:(NSNumber *)cityId;
+(id)getById:(NSNumber *)landmarkId;
-(NSString *)largeAddress;
-(NSArray *)allImages;
-(NSString *)giveFirstImage;
-(NSArray *)nearByLandmarks;
+(id)getAll;

-(NSString *)latLongString;
+(id)searchMark:(NSString *)keyWord;
+(void)updateAllLandmarkAssetAssosiation;
+(id)getTripPoolsByCityId:(NSNumber *)cityId;

-(NSDictionary *)detaillForPools;
-(NSString *)englishDetailOfPool;
-(NSDictionary *)extraObjectsForPools;
-(BOOL)isBedAvailable;
-(BOOL)isCheckPostAvailable;
-(BOOL)isFoodAvailable;
-(BOOL)isMedicalAvailable;
-(BOOL)isWashroomAvailable;
-(BOOL)isWaterAvailable;
+(void)removeAllObject;

@end

NS_ASSUME_NONNULL_END

#import "Landmarks+CoreDataProperties.h"
