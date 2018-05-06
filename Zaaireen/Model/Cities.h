//
//  Cities.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cities : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callAllCitiesWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;
+(id)getAll;

+(Cities *)getById:(NSNumber *)countryId;
+(id)getCitiesOfCountryById:(NSNumber *)countryId;
+(Cities *)getCityByName:(NSString *)name;

-(NSString *)cityCommoCountry;

-(NSString *)latLongString;
+(void)addFromArray:(NSArray *)list;
+(void)removeAllObject;
@end

NS_ASSUME_NONNULL_END

#import "Cities+CoreDataProperties.h"
