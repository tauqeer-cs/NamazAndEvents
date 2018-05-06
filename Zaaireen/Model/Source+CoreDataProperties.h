//
//  Source+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Source.h"

NS_ASSUME_NONNULL_BEGIN

@interface Source (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *detail;
@property (nullable, nonatomic, retain) NSString *extra;
@property (nullable, nonatomic, retain) NSDate *publishedAt;
@property (nullable, nonatomic, retain) NSString *reviewedBy;
@property (nullable, nonatomic, retain) NSNumber *sourceId;
@property (nullable, nonatomic, retain) NSString *sourceUrl;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updatedAt;

@end

NS_ASSUME_NONNULL_END
