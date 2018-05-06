//
//  AssetsDetail.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetsDetail : NSManagedObject



+(void)callGetAssetDetailWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(id)getWithPersonalityId:(int)personalityId;
+(id)getAll;
+(id)getWithLandmarkId:(int)landmarkId;
+(void)addFromArray:(NSArray *)list;

+(void)removeAllObject;
@end

NS_ASSUME_NONNULL_END

#import "AssetsDetail+CoreDataProperties.h"
