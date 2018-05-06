//
//  LocalSearchViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/22/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "LocalSearchViewController.h"
#import "SearchTextView.h"
#import "ZiaratCollectionViewCell.h"
#import "Landmarks.h"
#import "LandmarkDetailViewController.h"
#import "Tags.h"

@interface LocalSearchViewController ()<SearchTextView>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,weak) SearchTextView *searchView;
@property (nonatomic,strong) NSArray *dataSource;
@end

@implementation LocalSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
             self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchTextView" owner:self options:nil];
    
    self.searchView = [nibObjects objectAtIndex:0];
    
    self.searchView.delegate = self;
    
    
    [self.searchView setFrame:CGRectMake(7,
                                         75,
                                         self.view.frame.size.width - 14,
                                         self.searchView.frame.size.height)];
    
    
    [self.view addSubview:self.searchView];
    
    self.searchView.txtSearch.text = self.keyWord;
 
    [self.collectionView registerNib:[UINib nibWithNibName:@"LandmarkCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellS"];
    [self refreshDataSource];
    
    
    [Tags callGetTagsWithUpperLimit:@""
                     withLowerLimit:@""
                          withAppId:@"1"
              withComplitionHandler:^(id  _Nonnull result) {
                  

                  
              }
                  withFailueHandler:^{
                      
                      
                  }];
    
}

-(void)refreshDataSource{
   
    self.keyWord = self.searchView.txtSearch.text;
    
    self.dataSource = [Landmarks searchMark:self.keyWord withCityId:self.sharedDelegate.myCurrentCity.cityId];
    
    [self.collectionView reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)textBoxReturnTapped{
    
}

-(void)textDidChange:(NSString *)newText{
    
    NSLog(@"%@",newText);
    
    [self refreshDataSource];
    
    
}
-(void)textEditingChange:(NSString *)newText{
  
    NSLog(@"%@",newText);
    [self refreshDataSource];
    
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
    
    Landmarks *currentLandmark = [self.dataSource objectAtIndex:indexPath.row];
    
    [currentCell populateCellFromLandmark:currentLandmark];
    

    return currentCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LandmarkDetailViewController *destinationViewController = (LandmarkDetailViewController *)
    [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"LandmarkDetailViewController"];
    
    destinationViewController.selectedLandmark = [self.dataSource objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:destinationViewController animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.collectionView.frame.size.width, 85);
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


@end
