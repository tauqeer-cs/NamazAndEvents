//
//  SelectCityViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/8/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "SelectCityViewController.h"
#import "CityTableViewCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Countries.h"
#import "Cities.h"
#import "AppDelegate.h"
#import "NSArray+BinarySearch.h"
#import "Landmarks.h"
#import "DateFormatter.h"

@interface SelectCityViewController ()<UITableViewDataSource,UITabBarDelegate,MKMapViewDelegate,CoreLocationControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *currentDataSource;
@property (nonatomic,strong) id currentCitySelected;

@property (weak, nonatomic) IBOutlet UILabel *lblCitiesOf;

@property (nonatomic) BOOL cameriaActionDone;

@end

@implementation SelectCityViewController

NSArray *allCitiesOfIran;
NSArray *allCitiesIraq;
NSArray *allCitiesSyria;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.settings.compassButton = YES;
    self.mapView.settings.myLocationButton = YES;
    self.mapView.mapType = MKMapTypeStandard;
    
    
    Countries *iranItem = [Countries getCountryByName:@"Iran"];
    Countries *iraqItem = [Countries getCountryByName:@"Iraq"];
    Countries *syriaItem = [Countries getCountryByName:@"Syria"];
    
    allCitiesOfIran = [Cities getCitiesOfCountryById:iranItem.countryId];
    
    NSMutableArray *tmp = [NSMutableArray new];
    
    for(Cities *currentCity in allCitiesOfIran)
    {
        
       id result = [Landmarks getByCityId:currentCity.cityId];
        
        if ([result count] > 0) {
            [tmp addObject:currentCity];
        }
    }

    allCitiesOfIran = tmp;
    
    allCitiesIraq = [Cities getCitiesOfCountryById:iraqItem.countryId];
    
    
    tmp = [NSMutableArray new];
    
    for(Cities *currentCity in allCitiesIraq)
    {
        
        id result = [Landmarks getByCityId:currentCity.cityId];
        
        if ([result count] > 0) {
            [tmp addObject:currentCity];
        }
    }
    
    allCitiesIraq = tmp;
    
    
    allCitiesSyria = [Cities getCitiesOfCountryById:syriaItem.countryId];
    
    
    tmp = [NSMutableArray new];
    
    for(Cities *currentCity in allCitiesSyria)
    {
        
        id result = [Landmarks getByCityId:currentCity.cityId];
        
        if ([result count] > 0) {
            [tmp addObject:currentCity];
        }
    }
    
    allCitiesSyria = tmp;
    self.currentDataSource = allCitiesOfIran;

}


-(void)setMyMap{
    
    
    
    if (_cameriaActionDone) {
        return;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.myCurrentLocation.coordinate.latitude
                                                            longitude:self.myCurrentLocation.coordinate.longitude
                                                                 zoom:15];
    
    [self.mapView animateToCameraPosition:camera];
    self.cameriaActionDone = YES;
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.currentDataSource count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CityTableViewCell * currentCell =   [tableView dequeueReusableCellWithIdentifier:@"cellCity"];
    
    @try {
        

    Cities *currentCityToShow = [self.currentDataSource objectAtIndex:indexPath.row];
    
    currentCell.lblCityName.text = currentCityToShow.name;
    currentCell.preservesSuperviewLayoutMargins = false;
    currentCell.separatorInset = UIEdgeInsetsZero;
    currentCell.layoutMargins = UIEdgeInsetsZero;
    
    }

    @catch (NSException *exception) {
        
    }

    
    return currentCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currentCitySelected = [self.currentDataSource objectAtIndex:indexPath.row];

    self.sharedDelegate.myCurrentCity = self.currentCitySelected;
    
    self.sharedDelegate.usingCurrentLocation = NO;
    
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)segmentIndexChanged:(UISegmentedControl *)sender {
 
    switch (sender.selectedSegmentIndex) {
        case 0:
            
            NSLog(@"Iran Selected");
 
            self.currentDataSource = allCitiesOfIran;
            
            
            [self.tableView reloadData];
        
            self.lblCitiesOf.text = @"Cities of Iran";
            break;
        
       case 1:
            
            NSLog(@"Iraq Selected");
            self.currentDataSource = allCitiesIraq;
            self.lblCitiesOf.text = @"Cities of Iraq";
            [self.tableView reloadData];
            
            break;
       case 2:
            
            NSLog(@"Syria Selected");
            
            self.lblCitiesOf.text = @"Cities of Syria";
            
            self.currentDataSource = allCitiesSyria;
            [self.tableView reloadData];
            break;
        default:
   
            NSLog(@"All Cities");
            
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}
- (IBAction)btnUserMyCurrentLocationTapped:(UIButton *)sender {
    
    self.sharedDelegate.usingCurrentLocation = NO;
    [self useMyCurrentLocationUpdated];
}



@end
