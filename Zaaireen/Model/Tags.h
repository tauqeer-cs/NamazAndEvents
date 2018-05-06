//
//  Tags.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tags : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+(void)callGetTagsWithUpperLimit:(NSString *)upperLimit withLowerLimit:(NSString *)lowerLimit withAppId:(NSString *)appId withComplitionHandler:(void(^)(id result))completionHandler withFailueHandler:(void(^)(void))failureHandler;
+(id)tagSearchLandmark:(NSString *)keyWord;
+(id)getAll;
+(void)removeAllObject;

@end

NS_ASSUME_NONNULL_END

#import "Tags+CoreDataProperties.h"
