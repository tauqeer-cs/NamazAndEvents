//
//  LandmarkHistoryDetailViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/12/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "LandmarkHistoryDetailViewController.h"
#import "Landmarks.h"
#import "Source_detail.h"

@interface LandmarkHistoryDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblLandmarkName;
@property (weak, nonatomic) IBOutlet UILabel *lblCityAndCountry;
@property (weak, nonatomic) IBOutlet UILabel *lblTypeName;
@property (weak, nonatomic) IBOutlet UILabel *lblGeoPoints;
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;


@end

@implementation LandmarkHistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (![self.userDefaults objectForKey:@"SourceDetailDownloaded"]) {
        [Source_detail callSourceDetailWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
            
            
        }
                                    withFailueHandler:^{
                                        NSLog(@"Fail Source Source_detail");
                                        
    }];
        
    }
    
    //LandmarksDetailDownloaded
    if (![self.userDefaults objectForKey:@"LandmarksDetailDownloaded"]){

        [self.view addSubview:self.loadingView];
        
        [Landmarks callLandmarksDetailUpperLimit:@"" withLowerLimit:@"" withAppId:@"" withComplitionHandler:^(id  _Nonnull result) {
            
            [self.loadingView removeFromSuperview];
            [self.myWebView loadHTMLString:self.currentLandmark.detail
                                   baseURL:nil];
            
            [self.viewSorryMessage removeFromSuperview];
            
            
        } withFailueHandler:^{
            
        }];
    }


    
    
    self.lblLandmarkName.text = self.currentLandmark.title;
    self.lblCityAndCountry.text = self.currentLandmark.cityDetail.cityCommoCountry;
    self.lblTypeName.text = [self.currentLandmark.landmarkTypeDetail.title capitalizedString];
    self.lblGeoPoints.text = self.currentLandmark.cityDetail.latLongString;
    
    [self setAttributedTextOfLabe:self.lblGeoPoints withTitle:self.currentLandmark.latLongString withImageName:@"location_map"];
    
    [self.myWebView loadHTMLString:self.currentLandmark.detail
                           baseURL:nil];
    
    
    
    if (self.currentLandmark.detail.length == 0) {
        
        UIView *tmpView = [UIView new];
        [tmpView setFrame:CGRectMake(0, (self.view.frame.size.height - (self.myWebView.frame.size.height/2))-30,
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
        [lblMessage setText:@"History will be available soon."];
        [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        lblMessage.textColor = [UIColor darkGrayColor];
        
        [tmpView addSubview:lblMessage];
        
        self.viewSorryMessage = tmpView;
        
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    UIButton * tmp  = [UIButton new];
    [tmp setFrame:CGRectMake(self.lblGeoPoints.frame.origin.x, self.lblGeoPoints.frame.origin.y, self.lblGeoPoints.frame.size.width+20, self.lblGeoPoints.frame.size.height)];
    [tmp.titleLabel setFont:self.lblGeoPoints.font];
    
    [self.lblGeoPoints.superview addSubview:tmp];
    
    NSString *tmp2 = @"";
    
    [tmp addTarget:self action:@selector(latLongTapped) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0;i<[self.currentLandmark.latLongString length];i++) {
        
        tmp2 = [tmp2 stringByAppendingString:@" "];
        
    }
    
    [tmp setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]] forState:UIControlStateHighlighted];
    
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu

{
    return NO;
}

-(void)latLongTapped{
    
    NSLog(@"Lat Long Tapped");
    
    
    
    
    CLLocationCoordinate2D myLocation;
    
    
    myLocation.latitude = self.myCurrentLocation.coordinate.latitude;
    myLocation.longitude = self.myCurrentLocation.coordinate.longitude;
    
    // myLocation.longitude = longitude;
    
    
    
    
    [self openMapsWithDirectionsTo:myLocation latitude:[self.currentLandmark.geo_lat doubleValue]
                         longitude:[self.currentLandmark.geo_long doubleValue]];
    
    
}







@end
