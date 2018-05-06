//
//  ShowRouteViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/11/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "ShowRouteViewController.h"
#import <MapKit/MapKit.h>
#import "CoreLocationController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"
#import "LRouteController.h"
#import "Landmarks.h"

@interface ShowRouteViewController ()<MKMapViewDelegate,CoreLocationControllerDelegate,UIGestureRecognizerDelegate,GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic,strong) NSMutableArray *coordinates;

@property (nonatomic,strong) LRouteController *routeController;
@property (nonatomic,strong) GMSPolyline *polyline;


@end

@implementation ShowRouteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    
    NSLog(@"Check");
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    GMSCameraPosition *camera;
    
    if (self.myLong > 0) {
        camera = [GMSCameraPosition cameraWithLatitude:self.myLat longitude:self.myLong zoom:15];
    }
    else{
   
        camera = [GMSCameraPosition cameraWithLatitude:self.myCurrentLocation.coordinate.latitude longitude:self.myCurrentLocation.coordinate.longitude zoom:15];
    
    }
    
    [self.mapView animateToCameraPosition:camera];
    [self getRouteTapped];
    
}
- (IBAction)getRouteTapped {
    
    
    
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = self.myCurrentLocation.coordinate.latitude;
    myLocation.longitude = self.myCurrentLocation.coordinate.longitude;
    
    CLLocationCoordinate2D location;
    
    Landmarks *currentLandmark = self.currentLandmark;
    
    location.latitude =
    [currentLandmark.geo_lat doubleValue];
    location.longitude =
    [currentLandmark.geo_long doubleValue];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    
    marker.position = CLLocationCoordinate2DMake(location.latitude,
                                                 location.longitude);
    marker.map = self.mapView;

    self.coordinates = [NSMutableArray new];
    self.routeController = [LRouteController new];
    
    self.polyline.map = nil;
    
    
    [self.coordinates addObject:[[CLLocation alloc] initWithLatitude:myLocation.latitude longitude:myLocation.longitude]];
    [self.coordinates addObject:[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude]];
    
    
    [self.routeController getPolylineWithLocations:self.coordinates travelMode:TravelModeDriving andCompletitionBlock:^(GMSPolyline *polyline, NSError *error) {
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        
        marker.position = CLLocationCoordinate2DMake(self.myCurrentLocation.coordinate.latitude,
                                                     self.myCurrentLocation.coordinate.longitude);
        
        marker.map =     self.mapView;
        

        
        if (error)
        {
            NSLog(@"%@", error);
        }
        else if (!polyline)
        {
            NSLog(@"No route");
            [self.coordinates removeAllObjects];
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



- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}



@end
