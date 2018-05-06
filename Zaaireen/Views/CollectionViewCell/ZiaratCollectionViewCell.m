//
//  ZiaratCollectionViewCell.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/7/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "ZiaratCollectionViewCell.h"
#import "Landmarks.h"
#import "FileManager.h"
#import "Personality.h"
#import "NSString+HTML.h"

@implementation ZiaratCollectionViewCell

-(void)populateCellFromLandmark:(Landmarks *)currentLandmark{
    
    self.lblZiaName.text = [currentLandmark.title uppercaseString];
    
    if ([[currentLandmark giveFirstImage] length] == 0) {
        [self.imgZiaImage  setImage:[UIImage imageNamed:@"listitem_no_image"]];
        [self.activityLoader stopAnimating];
        
    }
    else
    [FileManager loadLandmarkImage:self.imgZiaImage url:[currentLandmark giveFirstImage]
                            loader:
     self.activityLoader];
    
    

    self.lblLocationName.text = currentLandmark.largeAddress;
    self.lblZiaratType.text = [currentLandmark.landmarkTypeDetail.title capitalizedString];
    
}
-(void)populateCellFromLandmark:(Landmarks *)currentLandmark withKM:(NSString *)km{
    
    self.lblZiaName.text = [currentLandmark.title uppercaseString];
    if ([[currentLandmark giveFirstImage] length] == 0) {
        [self.imgZiaImage  setImage:[UIImage imageNamed:@"listitem_no_image"]];
         [self.activityLoader stopAnimating];
    }
    else
        [FileManager loadLandmarkImage:self.imgZiaImage url:[currentLandmark giveFirstImage] loader:self.activityLoader];
    
    self.lblLocationName.text = currentLandmark.largeAddress;
    self.lblZiaratType.text = [currentLandmark.landmarkTypeDetail.title capitalizedString];
    self.lblKmAway.text = [NSString stringWithFormat:@"%@ KM",km];
}


-(void)populateCellFromPersonality:(Personality *)currentPersonality{
    
    self.lblZiaName.text = [currentPersonality.title stringByDecodingHTMLEntities];
    self.lblLocationName.text = [[currentPersonality.personality_type capitalizedString] stringByDecodingHTMLEntities];
    self.lblZiaratType.text = @"";
    self.imgZiaImage.backgroundColor = [UIColor grayColor];
    [self.imgZiaImage setImage:[UIImage imageNamed:@"personalities_icon"]];
     [self.activityLoader stopAnimating];
    _imgZiaImage.contentMode = UIViewContentModeCenter;
    
}
@end
