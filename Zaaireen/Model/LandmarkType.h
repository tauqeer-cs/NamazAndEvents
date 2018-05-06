//
//  LandmarkType.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface LandmarkType : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callLandmarkTypeWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(LandmarkType *)getLandmarkTypeById:(NSNumber *)landmarkId;


+(void)removeAllObject;
+(void)loadFirstTimeDataFromPlistWithComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

@end

NS_ASSUME_NONNULL_END

#import "LandmarkType+CoreDataProperties.h"
