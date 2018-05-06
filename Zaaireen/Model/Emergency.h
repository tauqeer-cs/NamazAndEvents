//
//  Emergency.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/24/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Countries;

NS_ASSUME_NONNULL_BEGIN

@interface Emergency : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+(void)callAllEmergencyNumbersWithUpperLimit:(NSString *)upperLimit
                              withLowerLimit:(NSString *)lowerLimit
                                   withAppId:(NSString *)appId
                       withComplitionHandler:(void(^)(id result))completionHandler
                           withFailueHandler:(void(^)(void))failureHandler;

+(id)getById:(Countries *)countryGiven;
+(id)getAll;
+(void)removeAllObject;
@end

NS_ASSUME_NONNULL_END

#import "Emergency+CoreDataProperties.h"
