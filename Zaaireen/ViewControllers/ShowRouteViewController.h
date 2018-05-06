//
//  ShowRouteViewController.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/11/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "BaseViewController.h"
@class Landmarks;

@interface ShowRouteViewController : BaseViewController

@property (nonatomic,strong) Landmarks *currentLandmark;


@property (nonatomic) double myLat;
@property (nonatomic) double myLong;


@end
