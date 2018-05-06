//
//  WeatherForcastViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/15/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "WeatherForcastViewController.h"
#import "FileManager.h"
#import "DateFormatter.h"
#import "AppDelegate.h"
#import "Cities.h"

@interface WeatherForcastViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblCityName;
@property (weak, nonatomic) IBOutlet UILabel *lblCountryName;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCondition;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;

@property (weak, nonatomic) IBOutlet UIImageView *imgWeather;

@property (weak, nonatomic) IBOutlet UILabel *lblDay1;
@property (weak, nonatomic) IBOutlet UILabel *lblConditon1;
@property (weak, nonatomic) IBOutlet UILabel *lblHighLow1;

@property (weak, nonatomic) IBOutlet UILabel *lblDay2;
@property (weak, nonatomic) IBOutlet UILabel *lblConditon2;
@property (weak, nonatomic) IBOutlet UILabel *lblHighLow2;

@property (weak, nonatomic) IBOutlet UILabel *lblDay3;
@property (weak, nonatomic) IBOutlet UILabel *lblConditon3;
@property (weak, nonatomic) IBOutlet UILabel *lblHighLow3;

@property (weak, nonatomic) IBOutlet UILabel *lblDay4;
@property (weak, nonatomic) IBOutlet UILabel *lblConditon4;
@property (weak, nonatomic) IBOutlet UILabel *lblHighLow4;

@property (weak, nonatomic) IBOutlet UILabel *lblDay5;
@property (weak, nonatomic) IBOutlet UILabel *lblConditon5;
@property (weak, nonatomic) IBOutlet UILabel *lblHighLow5;
@property (nonatomic,strong) UIView *loaderView;
@property (weak, nonatomic) IBOutlet UIImageView *iconLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrentConditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lblForcaseLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *viewCityNameContainer;
@property (nonatomic) BOOL isShowingWeatherInCentrigrade;

@end

@implementation WeatherForcastViewController

-(void)hideAllStuff :(BOOL )hidden{
    
   
    [self.lblCityName setHidden:hidden];
    [self.lblCountryName setHidden:hidden];
    [self.lblDate setHidden:hidden];
    
    [self.lblCondition setHidden:hidden];
    [self.lblTemperature setHidden:hidden];
    [self.imgWeather setHidden:hidden];
    
    [self.lblDay1 setHidden:hidden];
    [self.lblConditon1 setHidden:hidden];
    [self.lblHighLow1 setHidden:hidden];
    
    [self.lblDay2 setHidden:hidden];
    [self.lblConditon2 setHidden:hidden];
    [self.lblHighLow2 setHidden:hidden];

    [self.lblDay3 setHidden:hidden];
    [self.lblConditon3 setHidden:hidden];
    [self.lblHighLow3 setHidden:hidden];

    [self.lblDay4 setHidden:hidden];
    [self.lblConditon4 setHidden:hidden];
    [self.lblHighLow4 setHidden:hidden];

    [self.lblDay5 setHidden:hidden];
    [self.lblConditon5 setHidden:hidden];
    [self.lblHighLow5 setHidden:hidden];
    
    [self.iconLocation setHidden:hidden];
    [self.lblCurrentConditionLabel setHidden:hidden];
    [self.lblForcaseLabel setHidden:hidden];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additionasel setup after loading the view.
    //.xib
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
    self.loaderView = [nibObjects objectAtIndex:0];
    [self.loaderView setFrame:CGRectMake(0,
                                         0,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height)];
    
    [self.view addSubview:self.loaderView];
    [self hideAllStuff:YES];
    
    self.isShowingWeatherInCentrigrade = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    Cities *currentCity = self.sharedDelegate.myCurrentCity;
    
    [self.serviceCallObject callWeatherForImageWithCityId:currentCity.woeid];
  

    
    if (IS_IPHONE_5) {
        
        [self.viewCityNameContainer
         setFrame:CGRectMake(self.viewCityNameContainer.frame.origin.x, self.viewCityNameContainer.frame.origin.y - 30, self.viewCityNameContainer.frame.size.width, self.viewCityNameContainer.frame.size.height)];
        
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)weatherServicecAlledWithSuccessWithImage:(NSString *)imageLink withCurrentWeather:(id)currentWeather
                                    withForcast:(id)forcast withWeatherLocation:(id)weatherLocation
{
    
    [self hideAllStuff:NO];
    [self.loaderView setHidden:YES];
    
    
    self.lblCityName.text = [weatherLocation objectForKey:@"_city"];
    self.lblCountryName.text = [weatherLocation objectForKey:@"_country"];
    
    NSDictionary * dayOneForcast = forcast[0];
    NSDictionary * dayTwoForcast = forcast[1];
    NSDictionary * dayThreeForcast = forcast[2];
    NSDictionary * dayFourForcast = forcast[3];
    NSDictionary * dayFiveForcast = forcast[4];
    
    
    self.lblDay1.text = [dayOneForcast objectForKey:@"_day"];
    self.lblConditon1.text = [dayOneForcast objectForKey:@"_text"];
    
    
    NSString *high = @"";
    NSString *low = @"";
    
    low = [dayOneForcast objectForKey:@"_low"];
    
    if ([low length] == 1) {
        
        low = [@"0" stringByAppendingString:low];
    
    }
    
    high = [dayOneForcast objectForKey:@"_high"];
    
    if ([high length] == 1) {
        
        high = [@"0" stringByAppendingString:low];
    
    }
    
    self.lblHighLow1.text = [NSString stringWithFormat:@"High: %@ Low: %@",high,low];
    
    self.lblDay2.text = [dayTwoForcast objectForKey:@"_day"];
    self.lblConditon2.text = [dayTwoForcast objectForKey:@"_text"];
    
    low = [dayTwoForcast objectForKey:@"_low"];
    
    if ([low length] == 1) {
        
        low = [@"0" stringByAppendingString:low];
        
    }
    
    high = [dayTwoForcast objectForKey:@"_high"];
    
    if ([high length] == 1) {
        
        high = [@"0" stringByAppendingString:low];
        
    }
    
    
    self.lblHighLow2.text = [NSString stringWithFormat:@"High: %@ Low: %@",high,low];

    self.lblDay3.text = [dayThreeForcast objectForKey:@"_day"];
    self.lblConditon3.text = [dayThreeForcast objectForKey:@"_text"];
    
    low = [dayThreeForcast objectForKey:@"_low"];
    
    if ([low length] == 1) {
        
        low = [@"0" stringByAppendingString:low];
        
    }
    
    high = [dayThreeForcast objectForKey:@"_high"];
    
    if ([high length] == 1) {
        
        high = [@"0" stringByAppendingString:low];
        
    }
    
    
    self.lblHighLow3.text = [NSString stringWithFormat:@"High: %@ Low: %@",high,low];;
    
    self.lblDay4.text = [dayFourForcast objectForKey:@"_day"];
    self.lblConditon4.text = [dayFourForcast objectForKey:@"_text"];
    
    low = [dayFourForcast objectForKey:@"_low"];
    
    if ([low length] == 1) {
        
        low = [@"0" stringByAppendingString:low];
        
    }
    
    high = [dayFourForcast objectForKey:@"_high"];
    
    if ([high length] == 1) {
        
        high = [@"0" stringByAppendingString:low];
        
    }
    
    self.lblHighLow4.text = [NSString stringWithFormat:@"High: %@ Low: %@",high,low];;

    self.lblDay5.text = [dayFiveForcast objectForKey:@"_day"];
    self.lblConditon5.text = [dayFiveForcast objectForKey:@"_text"];
    
    low = [dayFiveForcast objectForKey:@"_low"];
    
    if ([low length] == 1) {
        
      low = [@"0" stringByAppendingString:low];
    }
    
    high = [dayFiveForcast objectForKey:@"_high"];
    
    if ([high length] == 1) {
        
        high = [@"0" stringByAppendingString:low];
    }
    
    
    self.lblHighLow5.text = [NSString stringWithFormat:@"High: %@ Low: %@",high,low];
    
    
    self.lblTemperature.text = [[currentWeather objectForKey:@"_temp"] stringByAppendingString:@"\u00B0C"];
    
    self.lblDate.text = [currentWeather objectForKey:@"_date"];
    self.lblCondition.text = [currentWeather objectForKey:@"_text"];
    [FileManager loadWeathImage:self.imgWeather url:imageLink loader:nil];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu

{
    return NO;
}


@end
