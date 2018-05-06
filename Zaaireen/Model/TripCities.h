//
//  TripCities.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/1/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface TripCities : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+(void)addFromArray:(NSArray *)list;
+(id)getByIdTripId:(NSNumber *)tripId;
+(void)removeAllObject;
@end

NS_ASSUME_NONNULL_END

#import "TripCities+CoreDataProperties.h"
