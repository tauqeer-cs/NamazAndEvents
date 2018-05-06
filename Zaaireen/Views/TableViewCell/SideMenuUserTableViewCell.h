//
//  SideMenuUserTableViewCell.h
//
//  Created by Tauqeer on 2014-10-31.
//  Copyright (c) 2014 Tauqeer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bubbleImage;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@end
