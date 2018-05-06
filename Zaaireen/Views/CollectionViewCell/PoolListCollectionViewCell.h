//
//  PoolListCollectionViewCell.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/3/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Landmarks;

@interface PoolListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribtion;

@property (weak, nonatomic) IBOutlet UIButton *btnIsVisited;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageIcons;
-(void)populateDataFrom:(Landmarks *)currentLandMark;

@end
