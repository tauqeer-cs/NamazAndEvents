//
//  AssetType.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetType : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callAssetTypeWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                         withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;

+(AssetType *)getAssetTypeById:(NSNumber *)assetTypeId;

+(void)loadFirstTimeDataFromPlistWithComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;
+(void)removeAllObject;

@end

NS_ASSUME_NONNULL_END

#import "AssetType+CoreDataProperties.h"
