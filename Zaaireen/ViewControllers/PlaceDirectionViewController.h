//
//  PlaceDirectionViewController.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/11/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "BaseViewController.h"

@class Landmarks;

@interface PlaceDirectionViewController : BaseViewController

@property (strong, nonatomic) UIImageView *compass;

@property (nonatomic,strong) Landmarks *currentLandmarkToShow;


@end
