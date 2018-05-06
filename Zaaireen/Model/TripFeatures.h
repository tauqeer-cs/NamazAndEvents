//
//  TripFeatures.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripFeatures : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callTripFeaturesWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(id)getAll;
+(void)removeAllObject;
@end

NS_ASSUME_NONNULL_END

#import "TripFeatures+CoreDataProperties.h"
