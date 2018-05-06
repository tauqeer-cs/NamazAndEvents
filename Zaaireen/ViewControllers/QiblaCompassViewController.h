//
//  QiblaCompassViewController.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/9/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "BaseViewController.h"

@interface QiblaCompassViewController : BaseViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) UIImageView *compass;

@end
