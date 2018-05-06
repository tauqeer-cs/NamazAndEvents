//
//  AllEmergencyNumbersViewController.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 11/24/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "AllEmergencyNumbersViewController.h"
#import "Emergency.h"
#import "EmergencyNumberCollectionViewCell.h"
#import "Cities.h"


@interface AllEmergencyNumbersViewController ()

@property (nonatomic,strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;


@end

@implementation AllEmergencyNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.loadingView];
    
    
    if (IS_IPHONE5)
    {
    
    }
    
    if (![self.userDefaults objectForKey:@"EmergencyListDownloaded"]) {
        [Emergency removeAllObject];
        
        [Emergency callAllEmergencyNumbersWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1"
                                   withComplitionHandler:^(id  _Nonnull result){
                                       
                                       self.dataSource =[Emergency getById:[Countries getCountryByName:@"Iran"]];
                                       [self.collectionView reloadData];
                                       [self.loadingView removeFromSuperview];
                                   
                                   }
                                       withFailueHandler:^{
                                       
                                       }];
    }
    else{
        
        [self.loadingView removeFromSuperview];
        self.dataSource =[Emergency getById:[Countries getCountryByName:@"Iran"]];
        
        
    }
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"EmergencyNumber" bundle:nil]
          forCellWithReuseIdentifier:@"cellEmergency"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EmergencyNumberCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellEmergency" forIndexPath:indexPath];
    
    [currentCell setViewFromEmergency:[self.dataSource objectAtIndex:indexPath.row]];
    
    return currentCell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    Emergency *currentObject = [self.dataSource objectAtIndex:indexPath.row];
    
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Dialing Number"
                                                     message:@"Is this the number you want to dial."
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"OK", nil];
    
    dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
    [dialog textFieldAtIndex:0].text =currentObject.phone1;
    
    [dialog textFieldAtIndex:0].keyboardType = UIKeyboardTypePhonePad;
    
    dialog.tag = 400;
    [dialog show];
}

- (IBAction)segmentIndexChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            


                self.dataSource =[Emergency getById:[Countries getCountryByName:@"Iran"]];
            [self.collectionView reloadData];
            
            break;
            
        case 1:
            
            self.dataSource =[Emergency getById:[Countries getCountryByName:@"Iraq"]];
            [self.collectionView reloadData];
            
            
            
            break;
        case 2:
            
            self.dataSource =[Emergency getById:[Countries getCountryByName:@"Syria"]];
            [self.collectionView reloadData];
            break;
        default:
            
            break;
    }
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if(alertView.tag == 400)
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"OK"]){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[alertView textFieldAtIndex:0].text]]];
        }
        
        
    }
    
    
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

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}



- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}




@end
