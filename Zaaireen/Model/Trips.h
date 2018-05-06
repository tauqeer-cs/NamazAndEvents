//
//  Trips.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Trips : NSManagedObject

+(void)callTripDetailUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                      withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(id)getAll;
+(id)getTripById:(int)itemId;
+(void)removeAllObject;


@end

NS_ASSUME_NONNULL_END

#import "Trips+CoreDataProperties.h"
