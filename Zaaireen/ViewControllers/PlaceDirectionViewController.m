//
//  PlaceDirectionViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/11/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "PlaceDirectionViewController.h"
#import "GeoPointCompass.h"
#import "Landmarks.h"


@interface PlaceDirectionViewController ()<CLLocationManagerDelegate>
@property(strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic) float tmpRadius;
@property (weak, nonatomic) IBOutlet UIView *viewCompassContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblDegree;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblKmAway;
@end

@implementation PlaceDirectionViewController{
    CLGeocoder *_geocoder;
    NSString *_destinationAddress;
    GeoPointCompass *_geoPointCompass;
}

UIImageView *currentPoin;

CLLocationCoordinate2D  currentLoc;
CLLocationDirection     currentHeadi;
CLLocationDirection     cityHead;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.compass = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qibla_dial"]];
    self.compass.center = self.viewCompassContainer.center;
    
    
    [self.compass setFrame:CGRectMake(self.compass.frame.origin.x,
                                      self.viewCompassContainer.center.y - (self.compass.frame.size.width),
                                      self.compass.frame.size.width,
                                      self.compass.frame.size.height)];
    
    [self.viewCompassContainer addSubview:self.compass];
    
    currentPoin = [UIImageView new];
    
    [self.viewCompassContainer addSubview:currentPoin];
    [currentPoin setImage:[UIImage imageNamed:@"direction_arrow"]];
    
    [currentPoin setFrame:CGRectMake(80, 500, 14, 236)];
    
    currentPoin.center = self.compass.center;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }
    
    [self.locationManager startUpdatingHeading];
    
    
    [self displayCompassForLatitude:[self.currentLandmarkToShow.geo_lat doubleValue]
                          Longitude:[self.currentLandmarkToShow.geo_lat doubleValue]];
    
    
    
    
    self.lblTitle.text = self.currentLandmarkToShow.title;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    if (self.myCurrentLocation) {
        CLLocation *location1 = self.myCurrentLocation;
        
        
        CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[self.currentLandmarkToShow.geo_lat  doubleValue] longitude:[self.currentLandmarkToShow.geo_long doubleValue]];
        CLLocation *location2 = LocationAtual;
        int distanceFromPrevious = [location1 distanceFromLocation:location2];
        
        distanceFromPrevious = distanceFromPrevious / 1000;
        
        self.lblKmAway.text = [NSString stringWithFormat:@"%d KM",distanceFromPrevious];
        
    }
    else {
        
    }

    
    
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    currentLoc = newLocation.coordinate;
    [self updateHeadingDisplays];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
    
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    self.tmpRadius = newRad;
    
    theAnimation.duration = 0.25f;
    
    [self.compass.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    self.compass.transform = CGAffineTransformMakeRotation(newRad);
    
    CLLocationDirection  theHeading = ((newHeading.trueHeading > 0) ?
                                       newHeading.trueHeading : newHeading.magneticHeading);
    cityHead = [self directionFrom:currentLoc ];
    currentHeadi = theHeading;
    
    [self updateHeadingDisplays];
}

- (void)updateHeadingDisplays {
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         
                         
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
}

-(CLLocationDirection) directionFrom: (CLLocationCoordinate2D) startPt  {
    
    double lat1 = toRad(startPt.latitude);
    double lat2 = toRad(21.4225 );
    double lon1 = toRad(startPt.longitude);
    double lon2 = toRad(39.8264);
    double dLon = (lon2-lon1);
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double brng = toDeg(atan2(y, x));
    
    brng = (brng+360);
    brng = (brng>360)? (brng-360) : brng;
    
    return brng;
}


- (void)displayCompassForLatitude:(double)latitude Longitude:(double)longitude {
    
    _geoPointCompass = [[GeoPointCompass alloc] init];
    
    // _geoPointCompass.lblDegree = self.lblDegree;
    
    [_geoPointCompass setArrowImageView:currentPoin];
    _geoPointCompass.latitudeOfTargetedPoint = latitude;
    
    _geoPointCompass.longitudeOfTargetedPoint = longitude;
}

- (void)updateDestinationForLatitude:(double)latitude Longitude:(double)longitude  {
    _geoPointCompass = nil;
    [self displayCompassForLatitude:latitude Longitude:longitude];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}



@end
