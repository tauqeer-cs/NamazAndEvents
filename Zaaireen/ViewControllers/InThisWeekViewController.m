//
//  InThisWeekViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/28/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "InThisWeekViewController.h"
#import "HistoryCollectionViewCell.h"
#import "DayDetail.h"
#import "OnThisDayDetailViewController.h"

@interface InThisWeekViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation InThisWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![self.userDefaults objectForKey:@"DayDetailDownloaded"]) {
        
        [self.view addSubview:self.loadingView];
        
        [DayDetail callDayDetailListWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
            
            [self.loadingView removeFromSuperview];
            
            self.dataSource = [DayDetail getAll];
            
            [self.collectionView reloadData];
            
            
        }
                                 withFailueHandler:^{
                                     
                                     NSLog(@"Fail DayDetail");
                                     
                                     
                                 }];
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HistoryCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellH"];
    
    
    
    self.dataSource = [DayDetail getAll];
    
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    HistoryCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellH" forIndexPath:indexPath];
    
    
    DayDetail *currentLandmark = [self.dataSource objectAtIndex:indexPath.row];
    
    
    NSArray *dayDetailArray = [currentLandmark.display_date componentsSeparatedByString:@"-"];
    
    currentCell.lblHijriMonth.text = [DayDetail islamicMonthName:[dayDetailArray[0] intValue]];
    currentCell.lblHijriDay.text = dayDetailArray[1];
    

    if ([dayDetailArray[2] isEqualToString:@"A.H"]) {
    currentCell.lblHijriYear.text = [NSString stringWithFormat:@"HIJRI"];
        
    }
    else if ([dayDetailArray[2] isEqualToString:@"NA"]) {
        currentCell.lblHijriYear.text = [NSString stringWithFormat:@"N/A"];
        
    }
    else if ([dayDetailArray[2] isEqualToString:@"BH"]) {
        currentCell.lblHijriYear.text = [NSString stringWithFormat:@"B.HIJRI"];
        
    }
    else if ([dayDetailArray[2] isEqualToString:@"B.H"]) {
        currentCell.lblHijriYear.text = [NSString stringWithFormat:@"B.HIJRI"];
        
    }
    else if ([dayDetailArray[2] isEqualToString:@"AF"]) {
        currentCell.lblHijriYear.text = [NSString stringWithFormat:@"A.Feel"];
    }
    else if ([dayDetailArray[2] isEqualToString:@"A.F"]) {
        currentCell.lblHijriYear.text = [NSString stringWithFormat:@"A.Feel"];
    }
    else{
        
    }
    
    currentCell.lblEventName.text = [currentLandmark.title stringByDecodingHTMLEntities];
    currentCell.lblEventDetail.text = [currentLandmark.text stringByDecodingHTMLEntities];
    
    return currentCell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.collectionView.frame.size.width, 80);
}




- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}




@end
