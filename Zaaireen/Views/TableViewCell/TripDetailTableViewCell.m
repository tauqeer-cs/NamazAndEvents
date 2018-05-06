//
//  TripDetailTableViewCell.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "TripDetailTableViewCell.h"
#import "Landmarks.h"

@implementation TripDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)populateWithLandmark:(Landmarks *)currentLandmark{
    
    self.lblPoleName.text = currentLandmark.title;
    
    NSRange range = [currentLandmark.title rangeOfString:@"#"];
    
    NSString *substring = [[currentLandmark.title substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    double cover = [substring doubleValue];
    cover = cover * 500;
    cover = cover / 1000.0;
    
    self.lblDistanceCovered.text = [NSString stringWithFormat:@"%d KM",(int)cover];
    
    double total = 1452;
    total = total * 500;
    total = total / 1000.0;
    
    
    int remaining = total - cover;

        self.lblDistanceRemaining.text = [NSString stringWithFormat:@"%d KM",remaining];
    
    
    self.lblDetail.text = currentLandmark.englishDetailOfPool;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

@end
