//
//  Landmarks+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Landmarks.h"
#import "LandmarkType.h"
#import "Asset.h"
#import "Personality.h"
#import "Trips.h"

NS_ASSUME_NONNULL_BEGIN

@interface Landmarks (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *attribute;
@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *extra;
@property (nullable, nonatomic, retain) NSNumber *geo_lat;
@property (nullable, nonatomic, retain) NSNumber *geo_long;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSNumber *isFeatured;
@property (nullable, nonatomic, retain) NSNumber *landmarkId;
@property (nullable, nonatomic, retain) NSNumber *landmarkTypeId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSSet<Asset *> *assets;
@property (nullable, nonatomic, retain) Cities *cityDetail;
@property (nullable, nonatomic, retain) LandmarkType *landmarkTypeDetail;
@property (nullable, nonatomic, retain) NSSet<Personality *> *personalities;
@property (nullable, nonatomic, retain) Trips *trip;

@end

@interface Landmarks (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet<Asset *> *)values;
- (void)removeAssets:(NSSet<Asset *> *)values;

- (void)addPersonalitiesObject:(Personality *)value;
- (void)removePersonalitiesObject:(Personality *)value;
- (void)addPersonalities:(NSSet<Personality *> *)values;
- (void)removePersonalities:(NSSet<Personality *> *)values;

@end

NS_ASSUME_NONNULL_END
