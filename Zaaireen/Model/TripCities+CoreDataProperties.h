//
//  TripCities+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TripCities.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripCities (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *tcId;
@property (nullable, nonatomic, retain) NSNumber *tripId;
@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSNumber *orderBy;

@end

NS_ASSUME_NONNULL_END
