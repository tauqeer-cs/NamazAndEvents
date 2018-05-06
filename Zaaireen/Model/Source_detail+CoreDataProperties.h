//
//  Source_detail+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Source_detail.h"
#import "Source.h"

NS_ASSUME_NONNULL_BEGIN

@interface Source_detail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *sourceId;
@property (nullable, nonatomic, retain) NSNumber *target_id;
@property (nullable, nonatomic, retain) NSString *targetType;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSNumber *sourceDetailId;
@property (nullable, nonatomic, retain) Source *source;

@end

NS_ASSUME_NONNULL_END
