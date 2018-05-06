//
//  Emergency+CoreDataProperties.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/24/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Emergency.h"
#import "Countries.h"

NS_ASSUME_NONNULL_BEGIN

@interface Emergency (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *emgencyId;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *phone1;
@property (nullable, nonatomic, retain) NSString *imageurl;
@property (nullable, nonatomic, retain) NSString *eType;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) Countries *country;

@end

NS_ASSUME_NONNULL_END
