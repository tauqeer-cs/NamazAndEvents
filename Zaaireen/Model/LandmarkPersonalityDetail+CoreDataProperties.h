//
//  LandmarkPersonalityDetail+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LandmarkPersonalityDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface LandmarkPersonalityDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *extra;
@property (nullable, nonatomic, retain) NSNumber *landmarkId;
@property (nullable, nonatomic, retain) NSNumber *landmarkPersonalityDetailId;
@property (nullable, nonatomic, retain) NSNumber *personalityId;

@end

NS_ASSUME_NONNULL_END
