//
//  HistoryCollectionViewCell.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/28/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblHijriYear;
@property (weak, nonatomic) IBOutlet UILabel *lblHijriDay;
@property (weak, nonatomic) IBOutlet UILabel *lblHijriMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblEventName;
@property (weak, nonatomic) IBOutlet UILabel *lblEventDetail;



@end
