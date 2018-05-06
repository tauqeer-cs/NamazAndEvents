//
//  Countries.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Countries : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callAllCountriesWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(void)addCountry:(int)countyId
         withName:(NSString *)name
      withFlagUrl:(NSString *)flagUrl
         withCode:(int)code
      withCreated:(NSDate *)createdAt
    withUpdatedAt:(NSDate *)updatedAt;

+(id)getAllCountries;
+(Countries *)getCountryById:(NSNumber *)countryId;

+(Countries *)getCountryByName:(NSString *)name;

+(void)loadFirstTimeDataFromPlistWithComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(void)removeAllObject;


@end

NS_ASSUME_NONNULL_END

#import "Countries+CoreDataProperties.h"
