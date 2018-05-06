//
//  TripFeatureTableViewCell.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "TripFeatureTableViewCell.h"

@interface TripFeatureTableViewCell()


@property (weak, nonatomic) IBOutlet UIImageView *imagePost;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@end
@implementation TripFeatureTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)populateCellFromItem:(NSString *)item{
 

    if ([item isEqualToString:@"Water"]) {
        
        self.lblName.text = @"Water";
         [self.imagePost setImage:[UIImage imageNamed:@"drinking_water"]];
    }
    else if ([item isEqualToString:@"Washroom"]) {
        self.lblName.text = @"Washroom";
         [self.imagePost setImage:[UIImage imageNamed:@"toilet"]];
    }
    else if ([item isEqualToString:@"Medical"]) {
     self.lblName.text = @"Medical";
     [self.imagePost setImage:[UIImage imageNamed:@"medical_facility"]];
    }
    else if ([item isEqualToString:@"Food"]) {
        self.lblName.text = item;
        [self.imagePost setImage:[UIImage imageNamed:@"food"]];
    }
    else if ([item isEqualToString:@"CheckPost"]) {
        self.lblName.text = @"CheckPost";
    [self.imagePost setImage:[UIImage imageNamed:@"check_post"]];
    }
    else if ([item isEqualToString:@"Bed"]) {
        self.lblName.text = item;
        
        [self.imagePost setImage:[UIImage imageNamed:@"resting_area"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
