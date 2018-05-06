//
//  PersonalityDetailViewController.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/29/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "BaseViewController.h"

@class Personality;
@class Landmarks;

@interface PersonalityDetailViewController : BaseViewController

@property (nonatomic,strong) Personality *selectedPersonality;
@property (nonatomic,strong) Landmarks *selectedLandmark;

@end
