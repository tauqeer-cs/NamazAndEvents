//
//  AssetType+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/30/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AssetType.h"
#import "Asset.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetType (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *assetTypeId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSSet<Asset *> *assets;

@end

@interface AssetType (CoreDataGeneratedAccessors)

- (void)addAssetsObject:(Asset *)value;
- (void)removeAssetsObject:(Asset *)value;
- (void)addAssets:(NSSet<Asset *> *)values;
- (void)removeAssets:(NSSet<Asset *> *)values;

@end

NS_ASSUME_NONNULL_END
