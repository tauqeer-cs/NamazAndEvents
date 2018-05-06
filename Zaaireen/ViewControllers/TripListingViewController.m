//
//  TripListingViewController.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "TripListingViewController.h"
#import "TripListingCollectionViewCell.h"
#import "Trips.h"
#import "TripFeaturesListViewController.h"

@interface TripListingViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;

@end

@implementation TripListingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TripListingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellTripListing"];
    
    
    if (![self.userDefaults objectForKey:@"LandmarksDetailDownloaded"]){
        

        
        [Landmarks callLandmarksDetailUpperLimit:@"" withLowerLimit:@"" withAppId:@"" withComplitionHandler:^(id  _Nonnull result) {
            
            
            
        } withFailueHandler:^{
            
        }];
    }
    
    
    
    if (![self.userDefaults objectForKey:@"TripDetailDownloaded"]){
     
        
        [self.view addSubview:self.loadingView];
        
        [Trips callTripDetailUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
        
            [self.loadingView removeFromSuperview];
            
            
            self.dataSource = result;
            
            [self.collectionView reloadData];
            
        } withFailueHandler:^{
            
        }];
        
        [TripFeatures callTripFeaturesWithUpperLimit:@""
                                      withLowerLimit:@""
                                           withAppId:@"1"
                               withComplitionHandler:^(id  _Nonnull result) {
                                   
                                   
                                   
                                   NSLog(@"%@",result);
                                   
                                   
                               } withFailueHandler:^{
                                   
                                   
                               }];
        
    }
    else{
        
        self.dataSource = [Trips getAll];
        [self.collectionView reloadData];   
    }
    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Trips * currentLandmark = [self.dataSource objectAtIndex:indexPath.row];
   
    TripListingCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellTripListing" forIndexPath:indexPath];
    currentCell.lblTripName.text = currentLandmark.title;
    
    currentCell.lblWalk.text = [currentLandmark.tripType uppercaseString];
    
    currentCell.lblNoOfLandmarks.text = [NSString stringWithFormat:@"%lu Landmarks",[currentLandmark.tripLandmarks.allObjects count]];
    
    return currentCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5) {
        return CGSizeMake(315-6, 60);
    }
    else if (IS_IPHONE_6) {
        return CGSizeMake(370-8, 60);
        
    }
    return CGSizeMake(self.collectionView.frame.size.width, 60);
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 //
    
    //PersonalityDetailViewController *destinationView = (PersonalityDetailViewController *)
    
    //destinationView.selectedPersonality = currentLandmark;
    TripFeaturesListViewController *selectedTrip = (TripFeaturesListViewController *)[self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"TripFeaturesListViewController"];
    
    selectedTrip.selectedTrip = [self.dataSource objectAtIndex:indexPath.row];
    
    
    [self.navigationController pushViewController:selectedTrip animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}


@end
