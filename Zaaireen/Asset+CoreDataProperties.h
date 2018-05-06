//
//  Asset+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Asset.h"
#import "AssetType.h"
#import "Personality.h"
#import "Cities.h"

NS_ASSUME_NONNULL_BEGIN

@interface Asset (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *assetId;
@property (nullable, nonatomic, retain) NSNumber *assetTypeId;
@property (nullable, nonatomic, retain) NSString *assetUrl;
@property (nullable, nonatomic, retain) NSString *attribute;
@property (nullable, nonatomic, retain) NSNumber *cityId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *extra;
@property (nullable, nonatomic, retain) NSNumber *isStatus;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) AssetType *assetType;
@property (nullable, nonatomic, retain) Cities *cityDetail;
@property (nullable, nonatomic, retain) Personality *newRelationship;

@end

NS_ASSUME_NONNULL_END
