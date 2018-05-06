//
//  QiblaCompassViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/9/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "QiblaCompassViewController.h"
#import "GeoPointCompass.h"
#import "DisclaimerView.h"
#import "LoaderView.h"

@interface QiblaCompassViewController ()<DisclaimerViewDelegate>

@property(strong,nonatomic) CLLocationManager *locationManager;
@property (nonatomic) float tmpRadius;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@property (weak, nonatomic) IBOutlet UIView *viewCompassContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblDegree;

@property (weak, nonatomic) IBOutlet UIButton *btnDisclaimer;

@property (nonatomic,strong) DisclaimerView *disclaimerView;
@property (nonatomic,strong) LoaderView *loaderView;

@end

@implementation QiblaCompassViewController {
    CLGeocoder *_geocoder;
    NSString *_destinationAddress;
    GeoPointCompass *_geoPointCompass;
}

UIImageView *currentPoint;

CLLocationCoordinate2D  currentLocation;
CLLocationDirection     currentHeading;
CLLocationDirection     cityHeading;

-(NSString *)htmlForMapWithSourceLatitude:(NSString *)soureLat withSourceLong:(NSString *)sourceLong
                      withDestinationLat:(NSString *)destinationLat withDestinationLong:(NSString *)destinationLong
{
    
    NSString *html = @"<!DOCTYPE html> <html>  <head> <meta name=\"viewport\" content=\"initial-scale=1.0, user-scalable=no\"> <meta charset=\"utf-8\"> <title>Simple markers</title> <style> html, body { height: 100%; margin: 0;  padding: 0; } #map { height: 100%; } html,body,#map_canvas{margin:0;height:100%} </style> </head>  <body bgcolor='#E6E6FA'> <div id=\"map\"></div> <script> function initMap() { var map = new google.maps.Map(document.getElementById('map'), { zoom: 3,";
    

    ;
    
    html = [html stringByAppendingString:[NSString stringWithFormat:@"center: {lat: %@, lng: %@ } ,",soureLat,sourceLong]];
    
    html = [html stringByAppendingString:@"mapTypeId: google.maps.MapTypeId.TERRAIN, panControl: false, zoomControl: false, mapTypeControl: false, scaleControl: false, streetViewControl: false, overviewMapControl: false }); var lineSymbol = { path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW, strokeOpacity: 1, strokeWeight:4, scale: 9, strokeColor:\"#25383C\", fillColor:\"#25383C\" }; var line = new google.maps.Polyline({ "];
    
    
    html = [html stringByAppendingString:[NSString stringWithFormat:@"path: [{lat: %@ , lng: %@ }, {lat: %@ , lng: %@ }],",soureLat,sourceLong,destinationLat,destinationLong]];
    

    html = [html stringByAppendingString:@"icons: [{ icon: lineSymbol, offset: '100%' }], disableDefaultUI: true, map: map }); } </script> <script async defer src=\"https://maps.googleapis.com/maps/api/js?key=AIzaSyCoT_Rlsek40P845juxqMAjybk71ryInTo&callback=initMap\"></script> </body> </html>"];
    
    return html;
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  
    [self.compass setFrame:CGRectMake((self.viewCompassContainer.frame.size.width/2) - self.compass.frame.size.width/2,
                                      40,
                                      self.compass.frame.size.width,
 
                                      self.compass.frame.size.height)];
    
    currentPoint.center = self.compass.center;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //,

    
    [self.btnDisclaimer setBackgroundImage:[self imageWithColor:[UIColor grayColor]]
                                  forState:UIControlStateHighlighted];
    
    [self.myWebView loadHTMLString:[self htmlForMapWithSourceLatitude:@"24.848842"
                                                       withSourceLong:@"67.000801"
                                                   withDestinationLat:@"21.4225"
                                                  withDestinationLong:@"39.8264"]
                           baseURL:nil];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.compass = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qibla_dial"]];
    
    self.viewCompassContainer.center  = self.compass.center;
    
    
    
    //[self.compass setFrame:CGRectMake(self.compass.frame.origin.x, 40, self.compass.frame.size.width, self.compass.frame.size.height)];
    
 
    
    
    [self.viewCompassContainer addSubview:self.compass];
    
    
    currentPoint = [UIImageView new];
    
    [self.viewCompassContainer addSubview:currentPoint];
    
    [currentPoint setImage:[UIImage imageNamed:@"qibla_arrow"]];
    
    [currentPoint setFrame:CGRectMake(80, 500, 20, 239)];
    
    
    
    
   
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if([CLLocationManager locationServicesEnabled]){
        [self.locationManager startUpdatingLocation];
    }

    [self.locationManager startUpdatingHeading];
    
    [self displayCompassForLatitude:21.4225 Longitude:39.8264];
    
    return;

    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    currentLocation = newLocation.coordinate;
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
    cityHeading = [self directionFrom:currentLocation ];
    currentHeading = theHeading;
    
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
    [_geoPointCompass setArrowImageView:currentPoint];
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

- (IBAction)btnDisclaimerButtonTapped:(UIButton *)sender {
    
    
    if (self.disclaimerView) {
        [self.disclaimerView setHidden:NO];    [self.loaderView setHidden:NO];
        
    }
    else{
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
        self.loaderView = [nibObjects objectAtIndex:0];
        [self.loaderView setFrame:CGRectMake(0,
                                             0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height)];
        
        [self.view addSubview:self.loaderView];
        
        //
          nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DisclaimerView" owner:self options:nil];
        
        self.disclaimerView = [nibObjects objectAtIndex:0];
        
        self.disclaimerView.delegate = self;
        
        [self.disclaimerView setFrame:CGRectMake(0,
                                                       0,
                                                       self.view.frame.size.width - 40,
                                                       self.disclaimerView.frame.size.height)];
        self.disclaimerView.center = self.loaderView.center;
        
        [self.view addSubview:self.disclaimerView];
        
    }
}

-(void)downloadingDoneButtonTapped{
    [self.loaderView setHidden:YES];
 [self.disclaimerView setHidden:YES];
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

@end
