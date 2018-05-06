#import "CoreLocationController.h"
#import "CoreLocation/CoreLocation.h"
#import "AppDelegate.h"

@implementation CoreLocationController

- (id)init {
    self = [super init];
    if(self != nil) {
      
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;

        NSString *currentSystemVer = [UIDevice currentDevice].systemVersion;
        currentSystemVer = [currentSystemVer substringToIndex:1];
        
        if ([currentSystemVer isEqualToString:@"8"]) {
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
        
        }
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [self.delegate update:newLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    @try {
    [self.delegate locationError:error];
        
    }
    @catch (NSException *exception) {
        
    }


    
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
   
    AppDelegate *currenApp = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    if (status == kCLAuthorizationStatusDenied) {
    
        currenApp.currentLocationState = LocationDisabled;
    }
    else if (status == kCLAuthorizationStatusAuthorized) {
        
        currenApp.currentLocationState = LocationEnable;
        
    }
    else{
    
    }
    //else if()
    

    
}

@end

