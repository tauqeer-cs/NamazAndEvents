//
//  ZiaratCollectionViewCell.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/7/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Landmarks;
@class Personality;

@interface ZiaratCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgZiaImage;
@property (weak, nonatomic) IBOutlet UILabel *lblZiaName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;

@property (nonatomic,weak) IBOutlet UILabel * lblZiaratType;
@property (weak, nonatomic) IBOutlet UILabel *lblKmAway;

-(void)populateCellFromLandmark:(Landmarks *)currentLandmark;
-(void)populateCellFromLandmark:(Landmarks *)currentLandmark withKM:(NSString *)km;
-(void)populateCellFromPersonality:(Personality *)currentPersonality;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@end
