//
//  EmergencyNumberCollectionViewCell.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/24/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "EmergencyNumberCollectionViewCell.h"
#import "Emergency.h"
#import "Countries.h"

@interface EmergencyNumberCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhoneNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblCategory;
@end

@implementation EmergencyNumberCollectionViewCell

-(void)setViewFromEmergency:(Emergency *)emergencyItem
{
    
    self.lblPlaceName.text = emergencyItem.title;
    self.lblPhoneNumber.text = emergencyItem.phone1;
    self.lblCategory.text = emergencyItem.eType;
    self.lblCategory.text = emergencyItem.country.name;
    
}
@end
