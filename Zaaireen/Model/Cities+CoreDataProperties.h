//
//  Cities+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cities.h"
#import "Countries.h"
#import "Asset.h"
#import "Trips.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cities (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSNumber *countryId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSNumber *lat;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *time_zone;
@property (nullable, nonatomic, retain) NSString *woeid;
@property (nullable, nonatomic, retain) NSSet<Asset *> *assets;
@property (nullable, nonatomic, retain) Countries *cityCountry;
@property (nullable, nonatomic, retain) NSSet<Trips *> *trips;

@end

@interface Cities (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet<Asset *> *)values;
- (void)removeAssets:(NSSet<Asset *> *)values;

- (void)addTripsObject:(Trips *)value;
- (void)removeTripsObject:(Trips *)value;
- (void)addTrips:(NSSet<Trips *> *)values;
- (void)removeTrips:(NSSet<Trips *> *)values;

@end

NS_ASSUME_NONNULL_END
