//
//  Trips+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Trips.h"
#import "Cities.h"
#import "Landmarks.h"
#import "TripFeatures.h"

NS_ASSUME_NONNULL_BEGIN

@interface Trips (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *extra;
@property (nullable, nonatomic, retain) NSNumber *status;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *tripId;
@property (nullable, nonatomic, retain) NSString *tripType;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) Cities *tripCity;
@property (nullable, nonatomic, retain) NSSet<Landmarks *> *tripLandmarks;
@property (nullable, nonatomic, retain) NSSet<TripFeatures *> *tripFeatures;

@end

@interface Trips (CoreDataGeneratedAccessors)

- (void)addTripLandmarksObject:(Landmarks *)value;
- (void)removeTripLandmarksObject:(Landmarks *)value;
- (void)addTripLandmarks:(NSSet<Landmarks *> *)values;
- (void)removeTripLandmarks:(NSSet<Landmarks *> *)values;

- (void)addTripFeaturesObject:(TripFeatures *)value;
- (void)removeTripFeaturesObject:(TripFeatures *)value;
- (void)addTripFeatures:(NSSet<TripFeatures *> *)values;
- (void)removeTripFeatures:(NSSet<TripFeatures *> *)values;

@end

NS_ASSUME_NONNULL_END
