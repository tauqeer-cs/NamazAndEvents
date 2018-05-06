//
//  Personality.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Asset, PersonalityCharacteristics;

NS_ASSUME_NONNULL_BEGIN

@interface Personality : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callPersonalitiesWithUpperLimit:(NSString *)upperLimit
                        withLowerLimit:(NSString *)lowerLimit
                             withAppId:(NSString *)appId
                 withComplitionHandler:(void(^)(id result))completionHandler
                     withFailueHandler:(void(^)(void))failureHandler;

+(Personality *)getById:(NSNumber *)personalityId;
+(id)getAll;
+(id)searchPersonalityWithKeyWord:(NSString *)keyWord;

+(void)removeAllObject;

@end

NS_ASSUME_NONNULL_END

#import "Personality+CoreDataProperties.h"
