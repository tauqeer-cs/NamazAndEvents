//
//  DayDetail+CoreDataProperties.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/21/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DayDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface DayDetail (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSString *date_calender;
@property (nullable, nonatomic, retain) NSNumber *dayDetailId;
@property (nullable, nonatomic, retain) NSString *display_date;
@property (nullable, nonatomic, retain) NSString *refrences;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSString *dayType;


@end

NS_ASSUME_NONNULL_END
