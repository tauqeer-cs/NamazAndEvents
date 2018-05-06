//
//  ViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "ViewController.h"
#import "ZiaratCollectionViewCell.h"
#import "LeftMenuViewController.h"
#import "SlideNavigationController.h"
#import "Landmarks.h"
#import "LocalSearchViewController.h"
#import "SearchTextView.h"
#import "DayDetail.h"
#import "LandmarkDetailViewController.h"
#import "CurrentCityHistoryViewController.h"
#import "FileManager.h"
#import "Source_detail.h"
#import "Emergency.h"
#import "Tags.h"
#import "LandmarkPersonalityDetail.h"
#import "AssetsDetail.h"
#import "Trips.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SearchTextView>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,weak) SearchTextView *searchView;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;

@property (weak, nonatomic) IBOutlet UIView *searchViewContainer;

@property (nonatomic) BOOL shouldShouldTricIcon;

@end

@implementation ViewController

bool isSlideUp;
double scrolled;

- (IBAction)btnHistoryTapped {
    
    if (!self.sharedDelegate.myCurrentCity) {
        return;
    }
    
    CurrentCityHistoryViewController *destination = (CurrentCityHistoryViewController *)[self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"CurrentCityHistoryViewController"];
    
    [self.navigationController pushViewController:destination animated:YES];
    
    
}

- (void)viewDidLoad {
    scrolled = 0;
    
    
    Cities *currentCity = [Cities getCityByName:@"Karbala"];
    
    self.sharedDelegate.myCurrentCity = currentCity;
    
    [super viewDidLoad];
    
    id c = [SlideNavigationController sharedInstance].leftMenu;
    
    if (!c) {
    
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        
        LeftMenuViewController *leftMenu =
        (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
        [SlideNavigationController sharedInstance].leftMenu = leftMenu;
        
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:90.0/255.0 green:0 blue:0 alpha:1];
    self.navigationController.navigationBar.translucent = YES;
    
    
   [self.collectionView registerNib:[UINib nibWithNibName:@"LandmarkCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellS"];
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchTextView" owner:self options:nil];
    self.searchView = [nibObjects objectAtIndex:0];
    
    self.searchView.delegate = self;
    
    
    [self.searchView setFrame:
     CGRectMake(0,0,self.searchViewContainer.frame.size.width,self.searchViewContainer.frame.size.height)];
    [self.searchViewContainer addSubview:self.searchView];
    
    
    [self setTextFieldPlaceHolderColor:self.searchView.txtSearch withColor:[UIColor colorWithRed:98.0/255.0 green:0 blue:0 alpha:1.0]];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width+ 100,
                                               self.scrollView.frame.size.height)];
    self.scrollView.scrollEnabled = NO;
    

    

    

}

-(void)reloadCollection{

    
    if (self.sharedDelegate.usingCurrentLocation) {
        
        if (self.sharedDelegate.myCurrentCity) {
            self.searchView.txtSearch.placeholder = [NSString stringWithFormat:@"Search Ziaraat in %@, %@",self.sharedDelegate.myCurrentCity.name,self.sharedDelegate.myCurrentCity.cityCountry.name];
        }
        else{
            
            [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                      withImageName:@"location_icon"];
            
            if (IS_IPHONE5 || IS_IPHONE_4S) {
                
                [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                                  withImageName:@"location_icon"];
                
[self.btnTopBarBUtton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
                
            }
            
            }
        
        
        
        if ([self.sharedDelegate.nearLoctionLandmarks count] > 0) {
            
            self.dataSource = self.sharedDelegate.nearLoctionLandmarks;
            
            [self.collectionView reloadData];
            [self.viewSorryMessage removeFromSuperview];
            self.viewSorryMessage = nil;
        
            
            
        }
        else {
            self.dataSource = nil;
            
            [self.collectionView reloadData];
            
            [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                              withImageName:@"location_icon"];
            
            if (IS_IPHONE5 || IS_IPHONE_4S) {
                
                [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                                  withImageName:@"location_icon"];
                
[self.btnTopBarBUtton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
                
            }
            self.searchView.txtSearch.placeholder = [NSString stringWithFormat:@""];
            [self.searchView.txtSearch setEnabled:NO];
            
            
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
            [lblMessage setFrame:CGRectMake(5, 25, self.view.frame.size.width -10, 60)];
            lblMessage.textAlignment = NSTextAlignmentCenter;
            lblMessage.numberOfLines =0;
            
            //Make attribute text for this
            
            [lblMessage setText:@"No Ziaraats found near your current location. Please select the city by clicking the LSymbollocation tab above."];
            
            //No result were found.Please try a different \n location.
            
            [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
            lblMessage.textColor = [UIColor darkGrayColor];
            
            [tmpView addSubview:lblMessage];
            
            self.viewSorryMessage = tmpView;

        }
    }
    else{
        self.dataSource = [Landmarks getByCityId:self.sharedDelegate.myCurrentCity.cityId];
        [self.collectionView reloadData];
        
        [self.viewSorryMessage removeFromSuperview];
        self.viewSorryMessage = nil;
        
        
        self.searchView.txtSearch.placeholder = [NSString stringWithFormat:@"Search Ziaraat in %@, %@",self.sharedDelegate.myCurrentCity.name,self.sharedDelegate.myCurrentCity.cityCountry.name];
        
    }
    
    
    
    if ([self.sharedDelegate.myCurrentCity.name isEqualToString:@"Karbala"]) {
        
        [self.btnPrev setHidden:NO];
    }
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.viewSorryMessage removeFromSuperview];
    self.viewSorryMessage = nil;
    
    

    [self reloadCollection];
    
    
    
    
    if ([self.sharedDelegate.myCurrentCity.name isEqualToString:@"Karbala"]) {
        
        self.shouldShouldTricIcon = YES;
    }
    else
    {
        self.shouldShouldTricIcon = NO;
    }

    
    if (![self.userDefaults objectForKey:@"LandmarksDetailDownloaded"]){
        
        
        [Landmarks callLandmarksDetailUpperLimit:@"" withLowerLimit:@"" withAppId:@"" withComplitionHandler:^(id  _Nonnull result) {
            
            
            
        } withFailueHandler:^{
            
        }];
    }
    
    

}




- (IBAction)btnSideMenuTapped:(id)sender {
    
    [self.sharedDelegate.sideMenuRefrence leftMenuSelected:nil];
   // self.sharedDelegate;
    
}
- (IBAction)btnDownloadTapped {
    
    if (isSlideUp) {
        
        [self slideBackToNormal];
    }
    else
    {
        [self slideUp:-40];
    }
    
    isSlideUp = !isSlideUp;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    if (IS_IPHONE_5) {
        return CGSizeMake(320-6, 85);
    }
    else if (IS_IPHONE_6) {
    return CGSizeMake(375-8, 85);
        
    }
    return CGSizeMake(self.collectionView.frame.size.width, 85);
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"segueLocalSearch"]) {
        
        LocalSearchViewController *currentSearchScreen = segue.destinationViewController;
        
        currentSearchScreen.keyWord = self.searchView.txtSearch.text;
        
    }
}

-(void)textBoxReturnTapped{

    
    
}

-(void)textDidChange:(NSString *)newText{
    
    [self performSegueWithIdentifier:@"segueLocalSearch" sender:self];
}

-(void)textEditingChange:(NSString *)newText{
    
}

- (IBAction)btnNextTapped {
    
    if (scrolled == 99) {
     
        return;
    }
    
    scrolled += 99;
    
    CGPoint bottomOffset = CGPointMake(scrolled, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
  
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    
    [self.btnPrev setHidden:NO];
    
    
    if (scrolled == 99) {
    
        [self.btnNext setHidden:YES];
        
        return;
    }
}


- (IBAction)btnPrevious {
    if (self.shouldShouldTricIcon) {
        
        if (scrolled == -99) {
            return;
        }
    }
    else
    if (scrolled == 0) {
        return;
    }
    
    scrolled -= 99;
    
    CGPoint bottomOffset = CGPointMake(scrolled,
                                       self.scrollView.contentSize.height
                                       - self.scrollView.bounds.size.height);
    
    [self.scrollView setContentOffset:bottomOffset animated:YES];
    [self.btnNext setHidden:NO];
    
   
    if (self.shouldShouldTricIcon){

       if (scrolled == -99) {
            [self.btnPrev setHidden:YES];
            
            return;
        }
        
    }
    else if (scrolled == 0) {
        [self.btnPrev setHidden:YES];
        
        return;
    }
}
- (IBAction)btnNewsTapped {

}

- (IBAction)btnDirectoryTapped {

}

- (IBAction)btnNamazTimingTapped {
    
    id toSendView = [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"NamazTimViewController"];
    [self.navigationController pushViewController:toSendView animated:YES];
    
}

- (IBAction)btnWeatherTapped {
    
    if (!self.sharedDelegate.myCurrentCity) {
        
        return;
    }
    id toSendView = [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"WeatherForcastViewController"];
    [self.navigationController pushViewController:toSendView animated:YES];
}

- (IBAction)btnDownloadButtonTapped {
    if (!self.sharedDelegate.myCurrentCity) {
        
        
        return;
        
    }
    id toShow = [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"DownloadDataViewController"];
    [self.navigationController pushViewController:toShow animated:YES];
}
- (IBAction)btnEmergencyTapped:(UIButton *)sender {
   
    
    if (!self.sharedDelegate.myCurrentCity) {
        return;
    }
    
    id toShow = [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"CountryEmergencyViewController"];
    
    [self.navigationController pushViewController:toShow animated:YES];
    
    
    
}

- (IBAction)btnTripTapped {
    //

    
    id toShow = [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"TripListingViewController"];
    
    [self.navigationController pushViewController:toShow animated:YES];
    
}


@end
