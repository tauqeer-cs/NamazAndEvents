//
//  Asset.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Asset : NSManagedObject
+(void)updateById:(NSNumber *)assetId isDownload:(BOOL)isDownload;
+(void)callGetAssetListWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit
                            withAppId:(NSString *)appId
                withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;
+(id)getAllWithId:(int)itemId;
+(id)getWithId:(NSNumber *)itemId;
+(id)getAllWithCityId:(NSNumber *)cityId;
+(id)getAll;

+(void)addFromArray:(NSArray *)list;
+(void)removeAllObject;
@end

NS_ASSUME_NONNULL_END

#import "Asset+CoreDataProperties.h"
