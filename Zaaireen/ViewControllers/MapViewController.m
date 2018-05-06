//
//  MapViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "CoreLocationController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "Landmarks.h"
#import "FileManager.h"
#import "LRouteController.h"
#import "LandmarkDetailViewController.h"

@interface MapViewController ()<MKMapViewDelegate,CoreLocationControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;

@property (nonatomic,strong) NSArray *allLandmarks;

@property (weak, nonatomic) IBOutlet UIImageView *imgPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblKmAway;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceName;
@property (weak, nonatomic) IBOutlet UILabel *lblCityAndCountry;
@property (weak, nonatomic) IBOutlet UIButton *btnRoute;

@property (weak, nonatomic) IBOutlet UIButton *btnDrivingDirection;
@property (weak, nonatomic) IBOutlet UILabel *lblRouteText;
@property (weak, nonatomic) IBOutlet UILabel *lblDrivingDirectionText;

@property (nonatomic) int indexBrowsing;
@property (nonatomic,strong) NSMutableArray *myCoordinates;

@property (nonatomic,strong) LRouteController *routeController;
@property (nonatomic,strong) GMSPolyline *polyline;


@property (nonatomic) BOOL allreadyBeenCalled;

@property (nonatomic,strong) NSMutableArray *allMarkers;
@property (weak, nonatomic) IBOutlet UIView *viewBottomContainer;
@property (nonatomic,strong) Cities *currentCity;


@property (nonatomic,strong) UILabel *lblNoMessage;
@property (nonatomic,strong) UIButton *btnRetry;

@end

@implementation MapViewController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    if (![self.sharedDelegate.myCurrentCity isEqual:self.currentCity]) {
     
        
            self.currentCity = self.sharedDelegate.myCurrentCity;
 
        self.allLandmarks = [Landmarks getByCityId:self.sharedDelegate.myCurrentCity.cityId];
        
        NSMutableArray *tmp = [NSMutableArray new];
        
        for (Landmarks *currentLandmark in self.allLandmarks) {
            
            if ([currentLandmark.geo_lat intValue] == 0) {
                
            }
            else{
                [tmp addObject:currentLandmark];
            }
        }
        self.allLandmarks = tmp;
        
        self.indexBrowsing = 0;
        [self.viewBottomContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapped)]];
    
        self.allreadyBeenCalled = NO;
    
        [self.btnRetry removeFromSuperview];
        [self.lblNoMessage removeFromSuperview];
        
        [self setMyMap];
        
        

        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.mapType = MKMapTypeStandard;
    self.btnNext.layer.cornerRadius = 5;
    self.btnPrevious.layer.cornerRadius = 5;
    self.allLandmarks = [Landmarks getByCityId:self.sharedDelegate.myCurrentCity.cityId];
    
    NSMutableArray *tmp = [NSMutableArray new];
    
    for (Landmarks *currentLandmark in self.allLandmarks) {
    
        if ([currentLandmark.geo_lat intValue] == 0) {
            
        }
        else{
            [tmp addObject:currentLandmark];
        }
    }
    self.allLandmarks = tmp;
    
    self.indexBrowsing = 0;
    [self.viewBottomContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapped)]];
    
    
    self.currentCity = self.sharedDelegate.myCurrentCity;
    
}




-(void)bottomViewTapped{
    
    //self.indexBrowsing;
    
    @try {

        Landmarks *selectedLandmark = [self.allLandmarks objectAtIndex:self.indexBrowsing];
        
        LandmarkDetailViewController *desintaion = (LandmarkDetailViewController *)[self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"LandmarkDetailViewController"];
        desintaion.selectedLandmark =selectedLandmark;
        [self.navigationController pushViewController:desintaion animated:YES];

    }
    @catch (NSException *exception) {
        
    }

    
}

-(NSMutableArray *)allMarkers{
    
    if (!_allMarkers) {
        
        _allMarkers = [NSMutableArray new];
        
    }
    return _allMarkers;
    
}
-(void)setMyMap{
    
    if (self.allreadyBeenCalled) {
        
        return;
        
    }
    if (self.myCurrentLocation) {
        self.allreadyBeenCalled = YES;
        
        if ([self.allLandmarks count] > 0) {
            
            int i = 0;
            
            for (Landmarks *item in self.allLandmarks) {
                
                
                
                CLLocationCoordinate2D location;
                location.latitude = [item.geo_lat  doubleValue];
                location.longitude = [item.geo_long doubleValue];
                
                GMSMarker *marker = [[GMSMarker alloc] init];
                
                marker.position = CLLocationCoordinate2DMake(location.latitude,location.longitude);
                        [marker setIcon:[UIImage imageNamed:@"mapiconNotSelected.png"]];
                
                if (i == 0) {
                    
                    CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[item.geo_lat  doubleValue] longitude:[item.geo_long doubleValue]];
                    
                    // self.myCurrentLocation = LocationAtual;
                    
                    
                    self.mapView.selectedMarker = marker;
                    [marker setIcon:[UIImage imageNamed:@"active_pin"]];
                    
                    
                    
                    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:LocationAtual.coordinate.latitude
                                                                            longitude:LocationAtual.coordinate.longitude
                                                                                 zoom:15];
                    [self.mapView animateToCameraPosition:camera];
                    
                    
                    
                    [FileManager loadLandmarkImage:self.imgPlaceName url:[item giveFirstImage] loader:nil];
                    
                    [self roundTheView:self.imgPlaceName];
                    
                    [self.lblPlaceName setText:item.title];
                    
                    
                    self.lblCityAndCountry.text = [item.cityDetail cityCommoCountry];
                    
                    
                    if (self.myCurrentLocation) {
                        CLLocation *location1 = self.myCurrentLocation;
                        
                        CLLocation *location2 = LocationAtual;
                        
                        double distanceFromPrevious = [location1 distanceFromLocation:location2];
                        distanceFromPrevious = distanceFromPrevious / 1000;
                        
                        self.lblKmAway.text = [NSString stringWithFormat:@"%.01f KM",distanceFromPrevious];
                        
                    }
                    else {
                        
                    }
                    
                    
                    
                }
                
                i++;
                
                if (location.latitude == 0) {
                    
                }
                else{
                 
                    [self.allMarkers addObject:marker];
                    
                    marker.map = self.mapView;
                }
            }
        }
        else{
            UILabel *lblNoLandmarks = [UILabel new];
            
            
            
            [lblNoLandmarks setFrame:CGRectMake(10, self.viewBottomContainer.frame.origin.y,
                                                self.viewBottomContainer.frame.size.width-20,
                                                self.viewBottomContainer.frame.size.height)];
            
            lblNoLandmarks.text = @"No landmarks available near the selected location.\nKindly select location by tapping the button below.";
            lblNoLandmarks.numberOfLines = 0;
            [lblNoLandmarks setBackgroundColor:[UIColor whiteColor]];
            
            lblNoLandmarks.textAlignment = NSTextAlignmentCenter;
            [lblNoLandmarks setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
            
            
            [self.view addSubview:lblNoLandmarks];
            
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myCurrentLocation.coordinate.latitude
                                                                    longitude:self.myCurrentLocation.coordinate.longitude
                                                                         zoom:15];
            
            [self.mapView animateToCameraPosition:camera];
            
            UIButton *s = [UIButton new];
            s.frame = self.btnNext.frame;
            [s setFrame:CGRectMake(self.view.center.x - s.frame.size.width/2, self.view.frame.size.height - 50, s.frame.size.width, s.frame.size.height)];
            [s setTitle:@"Retry" forState:UIControlStateNormal];
            
            s.layer.cornerRadius = 10;
            
            s.backgroundColor = self.btnNext.backgroundColor;
            [s addTarget:self action:@selector(btnRetryTapped) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:s];
            
            self.btnRetry = s;
            self.lblNoMessage = lblNoLandmarks;
            

            
       
            
            
            
            
        }
        
    }
    
}

-(void)btnRetryTapped{
    
    [self topBarButtonTapped];
    
}

- (IBAction)getRouteTapped {
    
    
    
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = self.myCurrentLocation.coordinate.latitude;
    myLocation.longitude = self.myCurrentLocation.coordinate.longitude;
    
    CLLocationCoordinate2D location;
    
    Landmarks *currentLandmark =
    [self.allLandmarks objectAtIndex:self.indexBrowsing];
    location.latitude =
    [currentLandmark.geo_lat doubleValue];
    location.longitude =
    [currentLandmark.geo_long doubleValue];
    
    
    
    self.myCoordinates = [NSMutableArray new];
    self.routeController = [LRouteController new];
    
    self.polyline.map = nil;
    
    
    [self.myCoordinates addObject:[[CLLocation alloc] initWithLatitude:myLocation.latitude longitude:myLocation.longitude]];
    [self.myCoordinates addObject:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude]];
    
    
    [self.routeController getPolylineWithLocations:self.myCoordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polyline, NSError *error) {
        
        if (error)
        {
            NSLog(@"%@", error);
        }
        else if (!polyline)
        {
            NSLog(@"No route");
            [self.myCoordinates removeAllObjects];
        }
        else
        {
            self.polyline = polyline;
            self.polyline.strokeWidth = 3;
            self.polyline.strokeColor = [UIColor blueColor];
            self.polyline.map = self.mapView;
            
        }
    }];
    
    
}


- (IBAction)btnDirectionTapped {
    
    @try {
        if (self.myCurrentLocation) {
            
            Landmarks *currentLandmark =
            [self.allLandmarks objectAtIndex:self.indexBrowsing];
            
            CLLocationCoordinate2D myLocation;
            
            
            myLocation.latitude = self.myCurrentLocation.coordinate.latitude;
            myLocation.longitude = self.myCurrentLocation.coordinate.longitude;
            
            // myLocation.longitude = longitude;
            
            
            
            
            [self openMapsWithDirectionsTo:myLocation latitude:[currentLandmark.geo_lat doubleValue] longitude:[currentLandmark.geo_long doubleValue]];
            
            /*
             [self openMapsWithDirectionsTo:self.myCurrentLocation.
             latitude:
             longitude:
             ];*/
        }
        
    }
    @catch (NSException *exception) {
        
    }

}

-(void)setCenterFrom:(CLLocationCoordinate2D )location{
    
    
    
}
- (IBAction)btnNextTapped {
    
    @try {
        self.indexBrowsing++;
        
        if ([self.allLandmarks count] == 0) {
            return;
        }
        if ([self.allLandmarks count] == self.indexBrowsing) {
            
            
            self.indexBrowsing = 0;
            
            
        }
        self.polyline.map = nil;
        [self.myCoordinates removeAllObjects];
        
        Landmarks *currentLandmark = [self.allLandmarks objectAtIndex:self.indexBrowsing];
        
        self.lblPlaceName.text = currentLandmark.title;
        self.lblCityAndCountry.text = currentLandmark.cityDetail.cityCommoCountry;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[currentLandmark.geo_lat doubleValue]
                                                                longitude:[currentLandmark.geo_long doubleValue]
                                                                     zoom:15];
        
        
        
        [FileManager loadLandmarkImage:self.imgPlaceName url:[currentLandmark giveFirstImage] loader:nil];
        
        [self roundTheView:self.imgPlaceName];
        
        
        for (GMSMarker * currentMark in self.allMarkers) {
            [currentMark setIcon:[UIImage imageNamed:@"mapiconNotSelected.png"]];
        }
        GMSMarker * currentMark = [self.allMarkers objectAtIndex:self.indexBrowsing];
        
        
        [currentMark setIcon:[UIImage imageNamed:@"active_pin"]];
        
        
        [self.mapView animateToCameraPosition:camera];
        
        
        if (self.myCurrentLocation) {
            CLLocation *location1 = self.myCurrentLocation;
            
            CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[currentLandmark.geo_lat  doubleValue] longitude:[currentLandmark.geo_long doubleValue]];
            
            CLLocation *location2 = LocationAtual;
            
            double distanceFromPrevious = [location1 distanceFromLocation:location2];
            distanceFromPrevious = distanceFromPrevious / 1000.0;
            
            
            self.lblKmAway.text = [NSString stringWithFormat:@"%.01f KM",distanceFromPrevious];
            
        }
        else {
            self.lblKmAway.text = @"";
        }
    }
    @catch (NSException *exception) {
        
    }


    
    
}

- (IBAction)btnPreviousTapped {
    
    @try {
        self.indexBrowsing--;
        
        if (self.indexBrowsing == -1) {
            
            
            self.indexBrowsing = (int)[self allLandmarks].count - 1;
            
            
        }
        
        Landmarks *currentLandmark = [self.allLandmarks objectAtIndex:self.indexBrowsing];
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[currentLandmark.geo_lat doubleValue]
                                                                longitude:[currentLandmark.geo_long doubleValue]
                                                                     zoom:15];
        
        [self.mapView animateToCameraPosition:camera];
        
        
        self.lblPlaceName.text = currentLandmark.title;
        self.lblCityAndCountry.text = currentLandmark.cityDetail.cityCommoCountry;
       
        
        //currentLandmark.
        
        [FileManager loadLandmarkImage:self.imgPlaceName url:[currentLandmark giveFirstImage] loader:nil];
        
        if (self.myCurrentLocation) {
            CLLocation *location1 = self.myCurrentLocation;
            
            CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[currentLandmark.geo_lat  doubleValue] longitude:[currentLandmark.geo_long doubleValue]];
            
            CLLocation *location2 = LocationAtual;
            
            double distanceFromPrevious = [location1 distanceFromLocation:location2];
            distanceFromPrevious = distanceFromPrevious /1000;
            
            
            self.lblKmAway.text = [NSString stringWithFormat:@"%.01f KM",distanceFromPrevious];
            
        }
        else {
            self.lblKmAway.text = @"";
            
        }
        
    }
    @catch (NSException *exception) {
        
    }

    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


@end
