//
//  PersonalityCharacteristics+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/29/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PersonalityCharacteristics.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalityCharacteristics (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *characteristicId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *personalityId;
@property (nullable, nonatomic, retain) NSString *value;
@property (nullable, nonatomic, retain) NSNumber *orderBy;

@end

NS_ASSUME_NONNULL_END
