//
//  Personality+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/29/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Personality.h"
#import "PersonalityCharacteristics.h"

NS_ASSUME_NONNULL_BEGIN

@interface Personality (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *personality_type;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *data;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSNumber *personalityId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSSet<PersonalityCharacteristics *> *characteristic;
@property (nullable, nonatomic, retain) NSSet<Asset *> *personalityAssets;

@end

@interface Personality (CoreDataGeneratedAccessors)

- (void)addCharacteristicObject:(PersonalityCharacteristics *)value;
- (void)removeCharacteristicObject:(PersonalityCharacteristics *)value;
- (void)addCharacteristic:(NSSet<PersonalityCharacteristics *> *)values;
- (void)removeCharacteristic:(NSSet<PersonalityCharacteristics *> *)values;

- (void)addPersonalityAssetsObject:(Asset *)value;
- (void)removePersonalityAssetsObject:(Asset *)value;
- (void)addPersonalityAssets:(NSSet<Asset *> *)values;
- (void)removePersonalityAssets:(NSSet<Asset *> *)values;

@end

NS_ASSUME_NONNULL_END
