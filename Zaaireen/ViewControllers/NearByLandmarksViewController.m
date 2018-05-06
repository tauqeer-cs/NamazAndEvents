//
//  NearByLandmarksViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "NearByLandmarksViewController.h"
#import "Landmarks.h"
#import "ZiaratCollectionViewCell.h"
#import "LandmarkDetailViewController.h"

@interface NearByLandmarksViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblLandmarkName;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation NearByLandmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LandmarkKMCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellS"];

    
    self.lblLandmarkName.text = self.selectedLandmark.title;
    
    self.dataSource = self.selectedLandmark.nearByLandmarks;

    
    if ([self.dataSource count] == 0) {
        
        
        [self.collectionView setHidden:YES];
        
        UIView *tmpView = [UIView new];
        [tmpView setFrame:CGRectMake(0, (self.view.frame.size.height - (self.collectionView.frame.size.height/2))-30,
                                     self.view.frame.size.width, 85)];
        
        
        
        [self.view addSubview:tmpView];
        
        UILabel *lblSorry = [UILabel new];
        [lblSorry setFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
        lblSorry.textAlignment = NSTextAlignmentCenter;
        
        [lblSorry setText:@"Sorry!"];
        
        [lblSorry setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
        lblSorry.textColor = [UIColor colorWithRed:98.0/255.0 green:0.0 blue:0.0 alpha:1.0];
        [tmpView addSubview:lblSorry];
        
        UILabel *lblMessage = [UILabel new];
        [lblMessage setFrame:CGRectMake(5, 25, self.view.frame.size.width -10, 30)];
        lblMessage.textAlignment = NSTextAlignmentCenter;
        lblMessage.numberOfLines =0;
        [lblMessage setText:@"Nearby landmarks will be available soon."];
        [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        lblMessage.textColor = [UIColor darkGrayColor];
        
        [tmpView addSubview:lblMessage];
        
        self.viewSorryMessage = tmpView;
        
    }
}




- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //self.collectionView.frame.size.width-14;
    if (IS_IPHONE_5) {
        return CGSizeMake(320-6, 85);
    }
    else if (IS_IPHONE_6) {
        return CGSizeMake(375-8, 85);
        
    }
    return CGSizeMake(self.collectionView.frame.size.width, 85);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZiaratCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellS" forIndexPath:indexPath];
    
    NSDictionary * currentItem = [self.dataSource objectAtIndex:indexPath.row];
    Landmarks *currentShowing =  [Landmarks getById:[NSNumber numberWithInt:[[currentItem objectForKey:@"landmark_id"] intValue]]];
    [currentCell populateCellFromLandmark:currentShowing withKM:[currentItem objectForKey:@"distance"]];
    
    return currentCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LandmarkDetailViewController *destinationViewController = (LandmarkDetailViewController *)
    [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"LandmarkDetailViewController"];
    
    NSDictionary * currentItem = [self.dataSource objectAtIndex:indexPath.row];
    
    Landmarks *currentShowing =  [Landmarks getById:[NSNumber numberWithInt:[[currentItem objectForKey:@"landmark_id"] intValue]]];
    
    destinationViewController.selectedLandmark = currentShowing;
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}



@end
