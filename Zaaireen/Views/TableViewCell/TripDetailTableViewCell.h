//
//  TripDetailTableViewCell.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Landmarks;

@interface TripDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblPoleName;

@property (weak, nonatomic) IBOutlet UILabel *lblMiniDetail;

@property (weak, nonatomic) IBOutlet UILabel *lblDistanceCovered;

@property (weak, nonatomic) IBOutlet UILabel *lblDistanceRemaining;

@property (weak, nonatomic) IBOutlet UILabel *lblDetail;

-(void)populateWithLandmark:(Landmarks *)currentLandmark;

@end
