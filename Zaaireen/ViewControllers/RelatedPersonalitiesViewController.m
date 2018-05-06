//
//  RelatedPersonalitiesViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/29/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "RelatedPersonalitiesViewController.h"
#import "Personality.h"
#import "ZiaratCollectionViewCell.h"
#import "Landmarks.h"
#import "PersonalityCharacteristics.h"
#import "PersonalityDetailViewController.h"
#import "LandmarkPersonalityDetail.h"

@interface RelatedPersonalitiesViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblRozaOF;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation RelatedPersonalitiesViewController

//230 230 230

- (void)viewDidLoad {
    [super viewDidLoad];

    
    __block id currentLandMarkPersonalities;
    
    if (![self.userDefaults objectForKey:@"PersonalityDownloaded"]) {
        
        [self.view addSubview:self.loadingView];
        [self.viewSorryMessage setHidden:YES];
        
        if ([self.userDefaults objectForKey:@"LandmarkPersonalityDetailDownloaded"]) {
            
        }
        else{
            [LandmarkPersonalityDetail removeAllObject];
            [PersonalityCharacteristics removeAllObject];
            [PersonalityCharacteristics removeAllObject];
            
            [LandmarkPersonalityDetail callLandmarkPersonalityDetailsWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                
                
                
                [PersonalityCharacteristics callPersonalityCharacteristicsWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1"withComplitionHandler:^(id  _Nonnull result) {
                    NSLog(@"Check");
                    
                    
                    [Personality callPersonalitiesWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1"
                                           withComplitionHandler:^(id  _Nonnull result) {
                        // totalServicesCalledTillNow++;
                        
                        [self.loadingView removeFromSuperview];
                        
                        [self.viewSorryMessage removeFromSuperview];
                        
                        
                        currentLandMarkPersonalities = [LandmarkPersonalityDetail getAllWithLandmarkIdId:[self.selectedLandmark.landmarkId intValue]];
                        NSMutableArray *tmpData = [NSMutableArray new];
                        
                        for (LandmarkPersonalityDetail * currentLandmarkPD in currentLandMarkPersonalities) {
                            
                            Personality *currentPersonality = [Personality getById:currentLandmarkPD.personalityId];
                            
                            [tmpData addObject:currentPersonality];
                            
                        }
                        
                        
                        self.dataSource = tmpData;
                        
                        [self.collectionView reloadData];
                        
                        
                        
                    } withFailueHandler:^{
                        
                    }];
                    
                } withFailueHandler:^{
                    
                    
                }];
                
            } withFailueHandler:^{
                
                NSLog(@"WHAT");
                
            }];
            
        }

        

        
        

    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LandmarkCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellS"];
    
    
    self.lblRozaOF.text = self.selectedLandmark.title;
    
    //self.dataSource = [self.selectedLandmark.personalities allObjects];
    self.dataSource = nil;
    
    
    NSMutableArray *tmpData = [NSMutableArray new];
    
    
    currentLandMarkPersonalities = [LandmarkPersonalityDetail getAllWithLandmarkIdId:[self.selectedLandmark.landmarkId intValue]];
    
    
    for (LandmarkPersonalityDetail * currentLandmarkPD in currentLandMarkPersonalities) {
        
        Personality *currentPersonality = [Personality getById:currentLandmarkPD.personalityId];
        
        if (currentPersonality) {
            [tmpData addObject:currentPersonality];
            
        }

        
    }
    
    
    self.dataSource = tmpData;
    
    [self.collectionView reloadData];
    
    
    
    



    if ([self.dataSource count] == 0) {
        
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
        [lblMessage setText:@"Personalities will be available soon."];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZiaratCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellS" forIndexPath:indexPath];
    
    
    Personality *currentPersonality = [self.dataSource objectAtIndex:indexPath.row];
    
    [currentCell populateCellFromPersonality:currentPersonality];
    
    
    
    return currentCell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.collectionView.frame.size.width, 85);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //int i = indexPath.row;
    
    NSLog(@"What");
    
    Personality *currentPersonality = [self.dataSource objectAtIndex:indexPath.row];
 
    
    PersonalityDetailViewController *destinationView = (PersonalityDetailViewController *)
    [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"PersonalityDetailViewController"];
    
    destinationView.selectedPersonality = currentPersonality;
    destinationView.selectedLandmark = self.selectedLandmark;
    
    [self.navigationController pushViewController:destinationView animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

@end
