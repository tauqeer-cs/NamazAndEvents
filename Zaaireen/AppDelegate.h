//
//  AppDelegate.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SlideNavigationController.h"

@class Cities;

typedef enum locationStatus
{
    LocationEnable,
    LocationDisabled,
    LocationCanNotFind
} LocationState;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) SlideNavigationController* sideMenuRefrence;
@property (nonatomic) LocationState *currentLocationState;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;

@property (nonatomic,strong) Cities *myCurrentCity;
@property (nonatomic) BOOL firstSlideDone;
@property (nonatomic) BOOL usingCurrentLocation;
@property (nonatomic,strong) NSArray *nearLoctionLandmarks;


@property (nonatomic,strong) id audioPlayerPlaying;

@end

