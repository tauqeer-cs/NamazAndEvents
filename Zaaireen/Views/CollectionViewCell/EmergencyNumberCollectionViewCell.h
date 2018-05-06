//
//  EmergencyNumberCollectionViewCell.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/24/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Emergency;

@interface EmergencyNumberCollectionViewCell : UICollectionViewCell

-(void)setViewFromEmergency:(Emergency *)emergencyItem;

@end
