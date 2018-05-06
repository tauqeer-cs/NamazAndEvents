//
//  PersonalityCharacteristics.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonalityCharacteristics : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+(void)callPersonalityCharacteristicsWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;
+(id)getAllWithPersonalityId:(int)personalityId;
+(void)removeAllObject;
@end

NS_ASSUME_NONNULL_END

#import "PersonalityCharacteristics+CoreDataProperties.h"
