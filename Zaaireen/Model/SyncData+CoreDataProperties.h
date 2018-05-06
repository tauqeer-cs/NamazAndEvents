//
//  SyncData+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SyncData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SyncData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *syncData;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSString *extra;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSDate *updatedAt;

@end

NS_ASSUME_NONNULL_END
