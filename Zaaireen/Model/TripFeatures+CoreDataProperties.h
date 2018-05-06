//
//  TripFeatures+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TripFeatures.h"
#import "Trips.h"

NS_ASSUME_NONNULL_BEGIN

@interface TripFeatures (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cName;
@property (nullable, nonatomic, retain) NSString *cValue;
@property (nullable, nonatomic, retain) NSNumber *order_by;
@property (nullable, nonatomic, retain) NSNumber *tfId;
@property (nullable, nonatomic, retain) NSNumber *tripId;
@property (nullable, nonatomic, retain) Trips *trip;

@end

NS_ASSUME_NONNULL_END
