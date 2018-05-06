//
//  GlobalSearchViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/22/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "GlobalSearchViewController.h"
#import "SearchTextView.h"
#import "ZiaratCollectionViewCell.h"
#import "Landmarks.h"
#import "Tags.h"
#import "SearchHeadingCollectionReusableView.h"
#import "LandmarkDetailViewController.h"
#import "RelatedPersonalitiesViewController.h"
#import "PersonalityDetailViewController.h"

@interface GlobalSearchViewController ()<SearchTextView>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,weak) SearchTextView *searchView;

@property (nonatomic,strong) NSDictionary *dataSource;

@end

@implementation GlobalSearchViewController
NSArray *tmpSections;



- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchTextView" owner:self options:nil];
    self.searchView = [nibObjects objectAtIndex:0];
    self.searchView.delegate = self;
    
    [self.searchView setFrame:CGRectMake(7,
                                         75,
                                         self.view.frame.size.width - 14,
                                         self.searchView.frame.size.height)];
    
    [self.view addSubview:self.searchView];
    
    
    if (![self.userDefaults objectForKey:@"TagsDownloaded"]) {
    
        [self.view addSubview:self.loadingView];
    
        
        [Tags callGetTagsWithUpperLimit:@""
                         withLowerLimit:@""
                              withAppId:@"1"
                  withComplitionHandler:^(id  _Nonnull result) {
                      
                      [self refreshDataSource];
                      
                      self.dataSource = [Tags tagSearchLandmark:@""];
                      
                      [self.loadingView removeFromSuperview];
                      
                  }
                      withFailueHandler:^{
                          
                          
                      }];
        
    }
    
    
    tmpSections = @[@"shrineArray",@"personalityArray",@"landmarksArray"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    

    self.searchView.txtSearch.text = self.keyWord;
    [self.collectionView registerNib:[UINib nibWithNibName:@"LandmarkCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellS"];
    [self refreshDataSource];
    
    self.dataSource = [Tags tagSearchLandmark:@""];

}

-(void)refreshDataSource{
    
    self.keyWord = self.searchView.txtSearch.text;
    
    self.dataSource = [Tags tagSearchLandmark:self.keyWord];
    [self.collectionView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textBoxReturnTapped{
    
}

-(void)textDidChange:(NSString *)newText{
    
    NSLog(@"%@",newText);
    
    [self refreshDataSource];
    self.dataSource = [Tags tagSearchLandmark:newText];
    [self.collectionView reloadData];
}
-(void)textEditingChange:(NSString *)newText{
    
    NSLog(@"%@",newText);
    [self refreshDataSource];
 
    self.dataSource = [Tags tagSearchLandmark:newText];
    [self.collectionView reloadData];
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
  
    if (kind == UICollectionElementKindSectionHeader) {
        SearchHeadingCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellHeader" forIndexPath:indexPath];
        

       
       //@[@"",@"",@""]
        
        if ([tmpSections[indexPath.section] isEqualToString:@"shrineArray"]){
       
            headerView.lblHeading.text = @"Shrine";
            
        }
        else if ([tmpSections[indexPath.section] isEqualToString:@"personalityArray"]){
            headerView.lblHeading.text = @"Personality";
        }
        else if ([tmpSections[indexPath.section] isEqualToString:@"landmarksArray"]){
         headerView.lblHeading.text = @"Others";   
        }
        
        
        
        reusableview = headerView;
        
    }
    
    return reusableview;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
        //
    return [[self.dataSource objectForKey:tmpSections[section]] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[self.dataSource allKeys] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZiaratCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellS" forIndexPath:indexPath];
    
   
    Landmarks *currentLandmark =[[self.dataSource objectForKey:tmpSections[indexPath.section]] objectAtIndex:indexPath.row];
    
    
    if ([currentLandmark isKindOfClass:[Personality class]]) {
        
        Personality *currentPerson = (Personality *)currentLandmark;
        currentCell.lblZiaName.text = currentPerson.title;
        return currentCell;
    }
    [currentCell populateCellFromLandmark:currentLandmark];
    return currentCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        Landmarks *currentLandmark =[[self.dataSource objectForKey:tmpSections[indexPath.section]] objectAtIndex:indexPath.row];
        
        
        if ([currentLandmark isKindOfClass:[Landmarks class]]) {
            LandmarkDetailViewController *destinationViewController = (LandmarkDetailViewController *)
            [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"LandmarkDetailViewController"];
            destinationViewController.selectedLandmark = currentLandmark;
            
            [self.navigationController pushViewController:destinationViewController animated:YES];
            
        }
        else if ([currentLandmark isKindOfClass:[Personality class]])
        {
            
            PersonalityDetailViewController *destinationView = (PersonalityDetailViewController *)
            [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"PersonalityDetailViewController"];
            
            
            destinationView.selectedPersonality = (Personality *)currentLandmark;
            
            
            [self.navigationController pushViewController:destinationView animated:YES];
            
        }
    }
    @catch (NSException *exception) {
        
    }



}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.collectionView.frame.size.width, 85);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(6, 6, 6, 6);
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


@end
