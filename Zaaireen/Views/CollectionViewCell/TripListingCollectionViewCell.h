//
//  TripListingCollectionViewCell.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripListingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTripName;

@property (weak, nonatomic) IBOutlet UILabel *lblWalk;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfLandmarks;
@end
