//
//  GalleryListingCollectionViewCell.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/9/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryListingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgThumb;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@end
