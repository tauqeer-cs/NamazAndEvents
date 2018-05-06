//
//  LandmarkDetailViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/28/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "LandmarkDetailViewController.h"
#import "RelatedPersonalitiesViewController.h"
#import "Landmarks.h"
#import "Personality.h"
#import "Asset.h"
#import "RecitalsListingViewController.h"
#import "FileManager.h"
#import "PlaceDirectionViewController.h"
#import "ShowRouteViewController.h"
#import "LandmarkHistoryDetailViewController.h"
#import "NearByLandmarksViewController.h"
#import "ESImageViewController.h"
#import "AssetsDetail.h"



@interface LandmarkDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnZiaraat;
@property (weak, nonatomic) IBOutlet UIButton *btnAamaal;

@property (weak, nonatomic) IBOutlet UILabel *lblPlaceTypeWithCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceLongName;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (nonatomic,strong) NSArray *allImagesLink;
@property (weak, nonatomic) IBOutlet UIButton *btnPersonality;

@property (nonatomic) int imagesScrolled;

@property (weak, nonatomic) IBOutlet UIButton *btnNextImage;
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousImage;


@end

@implementation LandmarkDetailViewController
double scroled;
- (IBAction)btnNextImageTapped {
    
    @try {

        
        [self.btnPreviousImage setHidden:NO];
        self.imagesScrolled++;
        
        if ([self.allImagesLink count] == _imagesScrolled) {
            
            
            _imagesScrolled = 0;
            
            
        }
        
        [FileManager loadLandmarkImageByHeight:self.imgBackground url:[self.allImagesLink objectAtIndex:_imagesScrolled]
         ];

        
        if (self.imagesScrolled == ([self.allImagesLink count] -1)) {
           
            [self.btnNextImage setHidden:YES];
        }
        
    }
    @catch (NSException *exception) {
        
        _imagesScrolled = 0;

    }

}


- (IBAction)btnPreviousImageTapped {
    
    @try {
        _imagesScrolled--;
        [self.btnNextImage setHidden:NO];
        
        if (_imagesScrolled == -1) {
            _imagesScrolled = (int)[self.allImagesLink count] -1;
        }
        
        [FileManager loadLandmarkImageByHeight:self.imgBackground url:[self.allImagesLink objectAtIndex:_imagesScrolled]
         ];
        
        
        if (_imagesScrolled == 0) {
            [self.btnPreviousImage setHidden:YES];
            
        }
        
                    }
    @catch (NSException *exception) {
     
        _imagesScrolled = 0;
    }

}


- (void)showFrenchman {
    @try {
        
        ESImageViewController *ivc = [[ESImageViewController alloc] init];
        ivc.closeButton.hidden = NO;
        [ivc setTappedThumbnail:self.imgBackground];
        
        if (_imagesScrolled == [self.allImagesLink count]) {
            _allImagesLink = 0;
            
        }
        UIImage *tmp = [FileManager loadLandmarkImageFromurl:[self.allImagesLink objectAtIndex:_imagesScrolled]];
        
        if (tmp) {
            
            [ivc setImage:tmp];
            
        }
        else
            return;
        [self presentViewController:ivc animated:YES completion:nil];
    }
    @catch (NSException *exception) {
        
        scroled = 0;
    }

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
 
}
-(void)viewDidAppear:(BOOL)animated{
    
    
    [super viewDidAppear:animated];


}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    scroled = 0;
    self.allImagesLink = self.selectedLandmark.allImages;
    

    if ([self.allImagesLink count] > 0)
    {
        if ([[self.allImagesLink firstObject] length] == 0) {

                [self.imgBackground setImage:[UIImage imageNamed:@"no_image"]];
                        _imgBackground.contentMode = UIViewContentModeTop;
            
        }
        else
        {   [FileManager loadLandmarkImageByHeight:self.imgBackground url:[self.allImagesLink firstObject]];
        
            self.imgBackground.userInteractionEnabled = YES;
            [self.imgBackground addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFrenchman)]];
            
        }
    }

    
    self.btnAamaal.layer.cornerRadius = 5;
    self.btnZiaraat.layer.cornerRadius = 5;
    
    self.lblPlaceTypeWithCountry.text =  [[NSString stringWithFormat:@"%@ in %@, %@",
                                        [self.selectedLandmark.address capitalizedString],
                                        self.selectedLandmark.cityDetail.name,
                                        self.selectedLandmark.cityDetail.cityCountry.name
                                        ] uppercaseString];
    
    
    self.lblPlaceName.text = self.selectedLandmark.title;
    
 
    self.lblPlaceLongName.text =  [NSString stringWithFormat:@"%@, %@, %@",
                                          [self.selectedLandmark.address capitalizedString],
                                          self.selectedLandmark.cityDetail.name,
                                          self.selectedLandmark.cityDetail.cityCountry.name
                                          ];
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width+ 120,
                                               self.scrollView.frame.size.height)];
    
    self.scrollView.scrollEnabled = NO;
    

    
    
    
    if (![self.userDefaults objectForKey:@"AssetsDownloaded"] || ![self.userDefaults objectForKey:@"AssetsDetailDownloaded"]) {
        
        [self.view addSubview:self.loadingView];
        
     

        [AssetsDetail removeAllObject];
        [Asset removeAllObject];
        
        
        
        [AssetsDetail callGetAssetDetailWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result)
         {
             [Asset callGetAssetListWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                 
                 
                 [self.loadingView removeFromSuperview];
                 
                 
                 [Landmarks updateAllLandmarkAssetAssosiation];
                 
                 
                 
             } withFailueHandler:^{
                 
                 [self.loadingView removeFromSuperview];
                 
             }];

             
         }
        withFailueHandler:^{
        
            [self.loadingView removeFromSuperview];
            
            
        }];
        
    }
    else{
        
        
        //[FileManager loadLandmarkImageByHeight:self.imgBackground url:[self.allImagesLink firstObject]];
    
    
        for (NSString *downloadingImageLink in self.allImagesLink) {
            
            [FileManager loadLandmarkImage:nil url:downloadingImageLink loader:nil];
            
        }
    }

    
    
    
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}



- (IBAction)btnPreviousTapped {

    @try {
        if (scroled == 0) { return;}
        
        scroled -= 100;
        
        CGPoint bottomOffset = CGPointMake(scroled,
                                           self.scrollView.contentSize.height
                                           - self.scrollView.bounds.size.height);
        
        [self.scrollView setContentOffset:bottomOffset animated:YES];
        [self.btnNext setHidden:NO];
        
        
        if (scroled == 0) {
            [self.btnPrevious setHidden:YES];
            
            return;
        }
   
    }
    @catch (NSException *exception) {
     
        NSLog(@"%@",exception);
    
    }
    @finally {
        
    }
    
}

- (IBAction)btnNextTapped {
   
    @try {
        if (scroled == 100) {
            
            return;
        }
        
        scroled += 100;
        
        CGPoint bottomOffset = CGPointMake(scroled, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
        
        [self.scrollView setContentOffset:bottomOffset animated:YES];
        
        [self.btnPrevious setHidden:NO];
        
        
        if (scroled == 100) {
            
            [self.btnNext setHidden:YES];
            
            return;
        }
        
    }
    @catch (NSException *exception) {
        
        
        NSLog(@"%@",exception);
        
    }
    @finally {
        
    }

    
}
- (IBAction)btnPersonalitiesTapped {
    
    RelatedPersonalitiesViewController *destination = ( RelatedPersonalitiesViewController *)[self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"RelatedPersonalitiesViewController"];
    destination.selectedLandmark = self.selectedLandmark;
    [self.navigationController pushViewController:destination animated:YES];
}

- (IBAction)btnReciteZiaratDay:(UIButton *)sender {
    
    RecitalsListingViewController *destination = (RecitalsListingViewController *)[self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"RecitalsListingViewController"];
    destination.selectedLandmark = self.selectedLandmark;
    [self.navigationController pushViewController:destination animated:YES];
    
}
- (IBAction)btnDirectionTapped:(UIButton *)sender {
    
    if (self.myCurrentLocation) {
        
        if ([self isInternetConnectionAvailable]) {
            
            Landmarks *currentLandmark = self.selectedLandmark;
            
            CLLocationCoordinate2D myLocation;
            
            
            myLocation.latitude = self.myCurrentLocation.coordinate.latitude;
            myLocation.longitude = self.myCurrentLocation.coordinate.longitude;
            
            [self openMapsWithDirectionsTo:myLocation latitude:[currentLandmark.geo_lat doubleValue] longitude:[currentLandmark.geo_long doubleValue]];
            
            
        }
        else{
        
        PlaceDirectionViewController *destination = (PlaceDirectionViewController *)[self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"PlaceDirectionViewController"];
            
            destination.currentLandmarkToShow = self.selectedLandmark;
            
            [self.navigationController pushViewController:destination animated:YES];
            
        }
    }
    else{
        
        

        
        
        [self showAlert:@"" message:@"Could not guide you to route direction your GPS turned On."];
    }
    
}

- (IBAction)btnRouteTapped:(UIButton *)sender {
    
    if (self.myCurrentLocation) {
        
        if ([self isInternetConnectionAvailable]) {
        
            Landmarks *currentLandmark = self.selectedLandmark;
            
            CLLocationCoordinate2D myLocation;
            
            
            myLocation.latitude = self.myCurrentLocation.coordinate.latitude;
            myLocation.longitude = self.myCurrentLocation.coordinate.longitude;
            
           // [self openMapsWithDirectionsTo:myLocation latitude:[currentLandmark.geo_lat doubleValue] longitude:[currentLandmark.geo_long doubleValue]];
        
         
            ShowRouteViewController *destination = (ShowRouteViewController *)
            [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"ShowRouteViewController"];
            destination.currentLandmark = currentLandmark;
            destination.myLat = [[NSString stringWithFormat:@"%f",self.myCurrentLocation.coordinate.latitude ] doubleValue];;
            destination.myLong = [[NSString stringWithFormat:@"%f",self.myCurrentLocation.coordinate.longitude ] doubleValue];
            
            
            
            
            [self.navigationController pushViewController:destination animated:YES];
            
        }
        else{
        [self showAlert:@"" message:@"Could not guide you to route without Internet."];
        }
    }
    else{
        
        [self showAlert:@"" message:@"Could not guide you to route without your GPS turned On."];
    }
}

//
- (IBAction)btnHistoryTapped:(UIButton *)sender {
    LandmarkHistoryDetailViewController *destination = (LandmarkHistoryDetailViewController *)
    [self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"LandmarkHistoryDetailViewController"];
    
    destination.currentLandmark = self.selectedLandmark;
    
    [self.navigationController pushViewController:destination animated:YES];
    
}

- (IBAction)btnNearByTapped:(UIButton *)sender {
    
    
    NearByLandmarksViewController *destination = (NearByLandmarksViewController *)[self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"NearByLandmarksViewController"];
    
    destination.selectedLandmark = self.selectedLandmark;
    
    
    [self.navigationController pushViewController:destination animated:YES];
    
}
@end
