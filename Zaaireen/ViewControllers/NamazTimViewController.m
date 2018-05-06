//
//  NamazTimViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/15/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "NamazTimViewController.h"
#import "PrayTime.h"
#import "AppDelegate.h"
#import "Cities.h"
#import "CLLocation+APTimeZones.h"

@interface NamazTimViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *namazSegment;
@property (weak, nonatomic) IBOutlet UILabel *lblFajarTiming;
@property (weak, nonatomic) IBOutlet UILabel *lblZoharTiming;
@property (weak, nonatomic) IBOutlet UILabel *lblAsrTiming;
@property (weak, nonatomic) IBOutlet UILabel *lblMagribTiming;
@property (weak, nonatomic) IBOutlet UILabel *lblIshaTiming;
@property (strong, nonatomic) PrayTime *prayTimeShia;
@property (strong, nonatomic) PrayTime *prayTimeSunni;

@property (nonatomic,strong) NSMutableArray *shiaTimes;
@property (nonatomic,strong) NSMutableArray *suniTimes;

@property (weak, nonatomic) IBOutlet UILabel *lblSunrise;

@end

@implementation NamazTimViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    
    self.prayTimeShia = [PrayTime new];
    self.prayTimeShia.calcMethod = PTKCalculationMethodJafari;
    self.prayTimeShia.asrJuristic = PTKJuristicMethodShafii;
    self.prayTimeShia.timeFormat = PTKTimeFormatNSDate;
    
    
    self.prayTimeSunni = [PrayTime new];
    self.prayTimeSunni.calcMethod = PTKCalculationMethodKarachi;
    self.prayTimeSunni.asrJuristic = PTKJuristicMethodShafii;
    self.prayTimeSunni.timeFormat = PTKTimeFormatNSDate;
    
    [self refreshTimes];

    [self refreshTimesSunni];
    
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    [self refreshTimes];
    
    [self refreshTimesSunni];
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTimes {
    
    
    
    @try {
        NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [cal components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
        
        CLLocation *LocationAtual = nil;
        
        NSArray *times = nil;
        
        
        
        if (self.sharedDelegate.myCurrentCity) {
            LocationAtual =  [[CLLocation alloc] initWithLatitude:[self.sharedDelegate.myCurrentCity.lat  doubleValue] longitude:[self.sharedDelegate.myCurrentCity.longitude doubleValue]];
            
            
            
            NSString *full =
            [NSString stringWithFormat:@"%@",LocationAtual.timeZone];
            
            
            full = [[[[full substringFromString:@"("] substringToString:@")"] stringByReplacingOccurrencesOfString:@"GMT" withString:@""] stringByReplacingOccurrencesOfString:@"UTC" withString:@""];
            
            
            
            times = [self.prayTimeShia getPrayerTimes:components
                                          andLatitude:[self.sharedDelegate.myCurrentCity.lat doubleValue]
                                         andLongitude:[self.sharedDelegate.myCurrentCity.longitude doubleValue]
                                          andtimeZone:[full doubleValue]];
            
        }
        
        
        
        
        if (self.sharedDelegate.usingCurrentLocation) {
            
            if (self.myCurrentLocation) {
                
                
                NSString *full =
                [NSString stringWithFormat:@"%@",self.myCurrentLocation.timeZone];
                
                
                
                
                full = [[[[full substringFromString:@"("] substringToString:@")"] stringByReplacingOccurrencesOfString:@"GMT" withString:@""] stringByReplacingOccurrencesOfString:@"UTC" withString:@""];
                
                
                
                times = [self.prayTimeShia getPrayerTimes:components
                                              andLatitude:self.myCurrentLocation.coordinate.latitude
                                             andLongitude:self.myCurrentLocation.coordinate.longitude
                                              andtimeZone:+5];
                
            }
            
        }
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        self.shiaTimes = [[NSMutableArray alloc] init];
        
        for (id currentTime in times) {
            
            NSLog(@"%@",[formatter stringFromDate:currentTime]);
            [self.shiaTimes addObject:[formatter stringFromDate:currentTime]];
        }
        
        
        NSLog(@"%@", self.shiaTimes);
        
        
        self.lblFajarTiming.text = self.shiaTimes[0];
        self.lblSunrise.text = self.shiaTimes[1];
        self.lblZoharTiming.text = self.shiaTimes[2];
        self.lblAsrTiming.text = self.shiaTimes[3];
        self.lblMagribTiming.text = self.shiaTimes[5];
        self.lblIshaTiming.text = self.shiaTimes[6];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
     
        
    }
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


-(void)refreshTimesSunni {
    
    @try {
        NSCalendar *cal = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [cal components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
        
        
        CLLocation *LocationAtual = nil;
        
        NSArray *times = nil;
        
        if (self.sharedDelegate.myCurrentCity) {
            LocationAtual =  [[CLLocation alloc] initWithLatitude:[self.sharedDelegate.myCurrentCity.lat  doubleValue] longitude:[self.sharedDelegate.myCurrentCity.longitude doubleValue]];
            
            
            
            NSString *full =
            [NSString stringWithFormat:@"%@",LocationAtual.timeZone];
            
            
            full = [[[[full substringFromString:@"("] substringToString:@")"] stringByReplacingOccurrencesOfString:@"GMT" withString:@""] stringByReplacingOccurrencesOfString:@"UTC" withString:@""];
            
            
            
            times = [self.prayTimeSunni getPrayerTimes:components
                                           andLatitude:[self.sharedDelegate.myCurrentCity.lat doubleValue]
                                          andLongitude:[self.sharedDelegate.myCurrentCity.longitude doubleValue]
                                           andtimeZone:[full doubleValue]];
            
        }
        
        
        if (self.sharedDelegate.usingCurrentLocation) {
            
            if (self.myCurrentLocation) {
                
                
                NSString *full =
                [NSString stringWithFormat:@"%@",self.myCurrentLocation.timeZone];
                
                
                full = [[[[full substringFromString:@"("] substringToString:@")"] stringByReplacingOccurrencesOfString:@"GMT" withString:@""] stringByReplacingOccurrencesOfString:@"UTC" withString:@""];
                
                times = [self.prayTimeSunni getPrayerTimes:components
                                               andLatitude:self.myCurrentLocation.coordinate.latitude
                                              andLongitude:self.myCurrentLocation.coordinate.longitude
                                               andtimeZone:+5];
            }
            
        }
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm a"];
        self.suniTimes = [[NSMutableArray alloc] init];
        
        for (id currentTime in times) {
            
            NSLog(@"%@",[formatter stringFromDate:currentTime]);
            [self.suniTimes addObject:[formatter stringFromDate:currentTime]];
        }
        
    }
    @catch (NSException *exception) {
        
        
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
    

    //self.lblZoharTiming.
    
}



- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            NSLog(@"Iran Selected");
            
            self.lblFajarTiming.text = self.shiaTimes[0];
            self.lblZoharTiming.text = self.shiaTimes[2];
            self.lblAsrTiming.text = self.shiaTimes[3];
            self.lblMagribTiming.text = self.shiaTimes[5];
            self.lblIshaTiming.text = self.shiaTimes[6];
            self.lblSunrise.text = self.shiaTimes[1];
            //self.currentDataSource = allCitiesOfIran;
            //[self.tableView reloadData];
            break;
            
        case 1:
            
            self.lblFajarTiming.text = self.suniTimes[0];
            self.lblSunrise.text = self.suniTimes[1];
            self.lblZoharTiming.text = self.suniTimes[2];
            self.lblAsrTiming.text = self.suniTimes[3];
            self.lblMagribTiming.text = self.suniTimes[5];
            self.lblIshaTiming.text = self.suniTimes[6];
            
            NSLog(@"Iraq Selected");
           // self.currentDataSource = allCitiesIraq;
            //[self.tableView reloadData];
            break;

            default:
            break;
    }
    
    
}



@end
