//
//  AllHistoryViewController.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/25/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "AllHistoryViewController.h"
#import "SearchTextView.h"
#import "ZiaratCollectionViewCell.h"
#import "Landmarks.h"
#import "Personality.h"
#import "LandmarkDetailViewController.h"
#import "PersonalityDetailViewController.h"
#import "Source_detail.h"
#import "LandmarkPersonalityDetail.h"

@interface AllHistoryViewController ()<SearchTextView>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *viewSearchContainer;

@property (nonatomic,weak) SearchTextView *searchView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic) BOOL isLandmarkActive;

@end

@implementation AllHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (![self.userDefaults objectForKey:@"PersonalityDownloaded"]) {
        
        [self.view addSubview:self.loadingView];
        
        [LandmarkPersonalityDetail removeAllObject];
        [PersonalityCharacteristics removeAllObject];
        [Personality removeAllObject];
        
        if ([self.userDefaults objectForKey:@"LandmarkPersonalityDetailDownloaded"]) {
            
        }
        else
            [LandmarkPersonalityDetail callLandmarkPersonalityDetailsWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                
                
                [PersonalityCharacteristics callPersonalityCharacteristicsWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1"withComplitionHandler:^(id  _Nonnull result) {
                    
                    
                    [Personality callPersonalitiesWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                        
                        [self.loadingView removeFromSuperview];
                        [self.viewSorryMessage removeFromSuperview];
                        
                    } withFailueHandler:^{
                        
                    }];
                    
                } withFailueHandler:^{
                    
                    
                }];
                
            } withFailueHandler:^{
                
                NSLog(@"WHAT");
                
            }];
        
    }
    if (![self.userDefaults objectForKey:@"SourceDetailDownloaded"]) {
        
        [Source_detail removeAllObject];
        
        [Source_detail callSourceDetailWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
            
            
        }
                                    withFailueHandler:^{
                                        NSLog(@"Fail Source Source_detail");
                                        
                                    }];
        
    }
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchTextView" owner:self options:nil];
    self.searchView = [nibObjects objectAtIndex:0];
    
    self.searchView.delegate = self;
    [self.searchView setFrame:
     CGRectMake(0,0,self.viewSearchContainer.frame.size.width,self.viewSearchContainer.frame.size.height)];
    [self.viewSearchContainer addSubview:self.searchView];
    
    
    [self setTextFieldPlaceHolderColor:self.searchView.txtSearch withColor:[UIColor colorWithRed:98.0/255.0 green:0 blue:0 alpha:1.0]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    self.dataSource = [Landmarks getAll];
    
    [self.collectionView reloadData];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LandmarkCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellS"];
    
    self.isLandmarkActive = YES;

}

-(void)refreshDataSource{
    
    

    if (self.isLandmarkActive) {
        
        if ([self.searchView.txtSearch.text length] > 0){
        
            self.dataSource = [Landmarks searchMark:self.searchView.txtSearch.text];
            
        }
        else{
            self.dataSource = [Landmarks getAll];
            
        }
    }
    else {
        
        if ([self.searchView.txtSearch.text length] > 0){
            
            self.dataSource =
            [Personality searchPersonalityWithKeyWord:self.searchView.txtSearch.text];
            
        }
        else{

            self.dataSource = [Personality getAll];
            
            
        }
        

    }
    
    [self.collectionView reloadData];
    
}


-(void)textBoxReturnTapped{
 
    
    [self.searchView.txtSearch resignFirstResponder];
        [self refreshDataSource];
    
}

-(void)textDidChange:(NSString *)newText{
        [self refreshDataSource];
    
}

-(void)textEditingChange:(NSString *)newText{
    
    
        [self refreshDataSource];
}


- (IBAction)segmentTapped:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            
            NSLog(@"Iran Selected");
            self.isLandmarkActive = YES;
            if ([self.searchView.txtSearch.text length] > 0) {
            self.dataSource = [Landmarks searchMark:self.searchView.txtSearch.text];
            }
            else
            self.dataSource = [Landmarks getAll];
            
            [self.collectionView reloadData];
            
            break;
            
        case 1:
            
            NSLog(@"Iraq Selected");
            self.isLandmarkActive = NO;
            
            if ([self.searchView.txtSearch.text length] > 0) {
             
                self.dataSource =
                [Personality searchPersonalityWithKeyWord:self.searchView.txtSearch.text];
            }
            else
            self.dataSource = [Personality getAll];
            
            
            [self.collectionView reloadData];
            break;
 
        default:
            
            break;
    }
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
     id currentLandmark = [self.dataSource objectAtIndex:indexPath.row];
    
    ZiaratCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellS" forIndexPath:indexPath];
    
    if ([currentLandmark isKindOfClass:[Landmarks class]]) {
        
        [currentCell populateCellFromLandmark:currentLandmark];
    
    }
    else
    {
    
        [currentCell populateCellFromPersonality:currentLandmark];
        
    }
    
    return currentCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    id currentLandmark = [self.dataSource objectAtIndex:indexPath.row];
    if([currentLandmark isKindOfClass:[Landmarks class]]){
        LandmarkDetailViewController *destinationViewController = (LandmarkDetailViewController *)
        [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"LandmarkDetailViewController"];
        
        destinationViewController.selectedLandmark = currentLandmark;
        
        [self.navigationController pushViewController:destinationViewController animated:YES];
    }
    else{
        
        PersonalityDetailViewController *destinationView = (PersonalityDetailViewController *)
        [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"PersonalityDetailViewController"];
        destinationView.selectedPersonality = currentLandmark;
        [self.navigationController pushViewController:destinationView animated:YES];
    }

    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSLog(@"Scrolling Starting");
    
    

    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Scrolling Up");
        [self.searchView.txtSearch resignFirstResponder];

}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


@end
