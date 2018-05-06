//
//  PoolListCollectionViewCell.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/3/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "PoolListCollectionViewCell.h"
#import "Landmarks.h"

@implementation PoolListCollectionViewCell

-(void)populateDataFrom:(Landmarks *)currentLandMark
{
    self.lblTitle.text = currentLandMark.title;
    self.lblDescribtion.text = [currentLandMark englishDetailOfPool];
    
    int item = 0;
    UIImageView *currentImageView;
    
    
    if (currentLandMark.isBedAvailable) {
        
        currentImageView  = self.imageIcons[item];
        [currentImageView setImage:[UIImage imageNamed:@"resting_area"]];
        item++;
        
    }
    
    if (currentLandMark.isCheckPostAvailable) {
        
        currentImageView  = self.imageIcons[item];
        [currentImageView setImage:[UIImage imageNamed:@"check_post"]];
        item++;
        
    }
    
    if (currentLandMark.isFoodAvailable) {
        
        currentImageView  = self.imageIcons[item];
        [currentImageView setImage:[UIImage imageNamed:@"food"]];
        item++;
    }
    
    if (currentLandMark.isMedicalAvailable) {
        
        currentImageView  = self.imageIcons[item];
        [currentImageView setImage:[UIImage imageNamed:@"medical_facility"]];
        item++;
    }
    
    if (currentLandMark.isWashroomAvailable) {
        
        currentImageView  = self.imageIcons[item];
        [currentImageView setImage:[UIImage imageNamed:@"toilet"]];
        item++;
    }
    
    if (currentLandMark.isWaterAvailable) {
        
        currentImageView  = self.imageIcons[item];
        [currentImageView setImage:[UIImage imageNamed:@"drinking_water"]];
        item++;
    }
    
}

@end
