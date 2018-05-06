//
//  DownloadCitieView.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DownloadCitieViewDelegate


-(void)doneButtonTapped;

@optional

@end

@interface DownloadCitieView : UIView

@property (nonatomic,strong) NSArray *citiesArray;
-(void)setView;

@property (nonatomic,strong) id<DownloadCitieViewDelegate> delegate;

@end
