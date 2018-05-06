//
//  NoInternetNoGPSView.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/8/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoInternetNoGPSView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblLocationServiceOffSmall;
@property (weak, nonatomic) IBOutlet UILabel *lblInternetOffSmall;


@property (weak, nonatomic) IBOutlet UILabel *lblLocationServiceOffLarge;
@property (weak, nonatomic) IBOutlet UILabel *lblInternetOffLarge;

@end
