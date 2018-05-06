//
//  DownloadPercentageView.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressOverlayView.h"


@protocol DownloadPercentageViewDelegate


-(void)downloadingDoneButtonTapped;

-(void)downloadingCancleButtonTapped;

@optional

@end

@interface DownloadPercentageView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblPercentage;
@property (strong, nonatomic) DAProgressOverlayView *progressOverlayView;
-(void)changeProgress:(double)percentage;

-(void)setView;

@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (nonatomic,strong) id<DownloadPercentageViewDelegate> delegate;


@end
