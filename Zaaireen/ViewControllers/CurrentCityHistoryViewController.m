//
//  CurrentCityHistoryViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/10/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "CurrentCityHistoryViewController.h"
#import "Cities.h"
#import "Source_detail.h"

@interface CurrentCityHistoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblLocationNameTOp;
@property (weak, nonatomic) IBOutlet UILabel *lblArea;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationName;
@property (weak, nonatomic) IBOutlet UILabel *lblLatLong;
@property (weak, nonatomic) IBOutlet UILabel *lblHistoryOf;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation CurrentCityHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![self.userDefaults objectForKey:@"SourceDetailDownloaded"]) {
        [Source_detail callSourceDetailWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
            
            
        }
                                    withFailueHandler:^{
                                        NSLog(@"Fail Source Source_detail");
                                        
                                    }];
        
    }
    
    self.currentCityShowing =self.sharedDelegate.myCurrentCity;
    self.lblLocationNameTOp.text = self.currentCityShowing.cityCommoCountry;
    self.lblLocationName.text = self.currentCityShowing.cityCommoCountry;
    [self setAttributedTextOfLabe:self.lblLatLong withTitle:self.currentCityShowing.latLongString withImageName:@"location_map"];
    
    self.lblHistoryOf.text = [NSString stringWithFormat:@"History of %@",self.currentCityShowing.name];
    [self.webView loadHTMLString:self.currentCityShowing.detail
                           baseURL:nil];
    
    
    if (self.currentCityShowing.detail.length == 0) {
        
        UIView *tmpView = [UIView new];
        [tmpView setFrame:CGRectMake(0, (self.view.frame.size.height - (self.webView.frame.size.height/2))-30,
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
    [tmp setFrame:CGRectMake(self.lblLatLong.frame.origin.x, self.lblLatLong.frame.origin.y, self.lblLatLong.frame.size.width+20, self.lblLatLong.frame.size.height)];
    [tmp.titleLabel setFont:self.lblLatLong.font];
    [self.lblLatLong.superview addSubview:tmp];
    
    NSString *tmp2 = @"";
    
    [tmp addTarget:self action:@selector(latLongTapped) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0;i<[self.currentCityShowing.latLongString length];i++) {
        
        tmp2 = [tmp2 stringByAppendingString:@" "];
        
    }
    
    [tmp setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]] forState:UIControlStateHighlighted];
    
    
    
    //[self setAttributedTextOfButtonOnBack:tmp withTitle:tmp2 withImageName:@"location_map"];

    
}

-(void)latLongTapped{
    
    NSLog(@"Lat Long Tapped");
    

    
    
    CLLocationCoordinate2D myLocation;
    
    
    myLocation.latitude = self.myCurrentLocation.coordinate.latitude;
    myLocation.longitude = self.myCurrentLocation.coordinate.longitude;
    
    // myLocation.longitude = longitude;
    
    
    
    
    [self openMapsWithDirectionsTo:myLocation latitude:[self.currentCityShowing.lat doubleValue]
                         longitude:[self.currentCityShowing.longitude doubleValue]];
    
    
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}



@end
