//
//  DisclaimerView.h
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/18/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DisclaimerViewDelegate

-(void)downloadingDoneButtonTapped;
@optional

@end

@interface DisclaimerView : UIView

@property (nonatomic,strong) id<DisclaimerViewDelegate> delegate;
-(void)setUpView;

@end
