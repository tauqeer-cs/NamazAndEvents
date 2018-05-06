//
//  Countries+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/30/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Countries.h"
#import "Emergency.h"
#import "Cities.h"


NS_ASSUME_NONNULL_BEGIN

@interface Countries (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSNumber *countryId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *flagUrl;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSSet<Cities *> *cities;
@property (nullable, nonatomic, retain) NSSet<Emergency *> *emergencyNumbers;

@end

@interface Countries (CoreDataGeneratedAccessors)

- (void)addCitiesObject:(Cities *)value;
- (void)removeCitiesObject:(Cities *)value;
- (void)addCities:(NSSet<Cities *> *)values;
- (void)removeCities:(NSSet<Cities *> *)values;

- (void)addEmergencyNumbersObject:(Emergency *)value;
- (void)removeEmergencyNumbersObject:(Emergency *)value;
- (void)addEmergencyNumbers:(NSSet<Emergency *> *)values;
- (void)removeEmergencyNumbers:(NSSet<Emergency *> *)values;

@end

NS_ASSUME_NONNULL_END
