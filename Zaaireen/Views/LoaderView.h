//
//  LoaderView.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/20/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderView : UIView
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *lblActivtyindication;

-(void)setUpViewWithAssetUrl:(NSString *)assetUrl;

@end
