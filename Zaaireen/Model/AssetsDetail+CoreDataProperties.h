//
//  AssetsDetail+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AssetsDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetsDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *assetDetailId;
@property (nullable, nonatomic, retain) NSNumber *assetId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *targetId;
@property (nullable, nonatomic, retain) NSString *targetType;
@property (nullable, nonatomic, retain) NSDate *updatedAt;

@end

NS_ASSUME_NONNULL_END
