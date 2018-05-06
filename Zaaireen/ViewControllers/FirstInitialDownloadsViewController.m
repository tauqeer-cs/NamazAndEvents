//
//  FirstInitialDownloadsViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/13/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "FirstInitialDownloadsViewController.h"
#import "LeftMenuViewController.h"
#import "SlideNavigationController.h"
#import "AppDelegate.h"
#import "Countries.h"
#import "Cities.h"
#import "Landmarks.h"
#import "Personality.h"
#import "PersonalityCharacteristics.h"
#import "LandmarkPersonalityDetail.h"
#import "AssetsDetail.h"
#import "Tags.h"
#import "Asset.h"
#import "DayDetail.h"
#import "LandmarkType.h"
#import <QuartzCore/QuartzCore.h>
#import "DAProgressOverlayView.h"
#import "Source.h"
#import "Source_detail.h"
#import "AssetType.h"
#import "Emergency.h"
#import "FileManager.h"

@interface FirstInitialDownloadsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;

@property (nonatomic) int numberOfServicesCompleted;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (strong, nonatomic) DAProgressOverlayView *progressOverlayView;

@property (weak, nonatomic) IBOutlet UIImageView *imgNoImage;
@property (weak, nonatomic) IBOutlet UILabel *lblText;

@property (weak, nonatomic) IBOutlet UILabel *lblDescribtionMessage;

@property (weak, nonatomic) IBOutlet UILabel *lblWelcomeHeading;

@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (nonatomic) int timerCalledTimes;

@end

@implementation FirstInitialDownloadsViewController

int totalServicesToBeCalled = 16;
int totalServicesCalledTillNow;
- (void)checkDone {
    // Do any additional setup after loading the view.
    [self updateProgress];
    
    if (totalServicesToBeCalled == totalServicesCalledTillNow) {
        
        self.lblNumber.text = @"All done press next to continue";
        [self.btnNext setHidden:NO];
    }
}

- (void)changeProgress {
    totalServicesCalledTillNow++;
    
    self.lblNumber.text = [NSString stringWithFormat:@"%d done of %d",totalServicesCalledTillNow,totalServicesToBeCalled];


    if (totalServicesCalledTillNow == 4) {
            [self callFirstCycleOfServices];
        
    }
    if (totalServicesCalledTillNow == 10) {
        [self callSecondCycleOfServices];
    }
    else if (totalServicesCalledTillNow == 13) {
        
        [self callThirdCycleOfServices];
        
    }
    else if(totalServicesCalledTillNow == 14){
        [self callFourthCycleOfServices];
        
    }
    else if(totalServicesCalledTillNow == 15){
       
        [self callFifthServices];
        
    }

    
    if (totalServicesCalledTillNow == 16) {
        
        
        
        self.lblNumber.text = @"";
        [self.btnNext setHidden:NO];
        [self.lblText removeFromSuperview];
        [self.btnNext setTitle:@"GET STARTED" forState:UIControlStateNormal];
        
        self.lblDescribtionMessage.text = @"Find, explore & learn about 130+ Ziaraat in Iran, Iraq & Syria with audio recitals & Duas.";
        [self.lblWelcomeHeading setHidden:NO];
        [self.progressBar setProgress:1.0 animated:YES];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)updateProgress
{
    
    self.progressOverlayView.progress = ((double)totalServicesCalledTillNow/(double)totalServicesToBeCalled);
    
    [self.progressBar setProgress:((double)totalServicesCalledTillNow/(double)totalServicesToBeCalled) animated:YES];
    
 //
}
-(void)methodB{
    //10
    
    self.timerCalledTimes++;
    
    
    if (self.timerCalledTimes >= 12) {
        
        return;
    }
    [self changeProgress];
    [self checkDone];
    
}

-(void)callFirstCycleOfServices{
 
    self.timerCalledTimes = 1;
    [NSTimer scheduledTimerWithTimeInterval:0.3f
                                     target:self selector:@selector(methodB) userInfo:nil repeats:YES];
    

    if ([self.userDefaults objectForKey:@"CityListDownloaded"]) {
        [self changeProgress];
        NSLog(@"Check");
        [self checkDone];
    }
    else
        [Cities callAllCitiesWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
            [self changeProgress];
            
            
            NSLog(@"Check");
            
            NSLog(@"City has been called");
            [self checkDone];
            
        } withFailueHandler:^{
            
            NSLog(@"Fail Cities");
            [self errorDownloading];
        }];
    
    
    
    

    
}

-(void)callSecondCycleOfServices{
   

    
}
-(void)callThirdCycleOfServices{

    

    
}
-(void)callFourthCycleOfServices{
    
    

}
-(void)callFifthServices{
    
    
    if ([self.userDefaults objectForKey:@"LandmarksDownloaded"]) {
        [self changeProgress];
        NSLog(@"Check");
        [self checkDone];
    }
    else

        [Landmarks removeAllObject];
    
        [Landmarks callLandmarksWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
            NSLog(@"Check");
            
            [self changeProgress];
            NSLog(@"Check");
            [self checkDone];
            

            
            dispatch_async(dispatch_get_main_queue(), ^{
               //Landmarks callLandmarksDetailUpper
            });

            
        } withFailueHandler:^{
            

            [self errorDownloading];
            
        }];

}
-(void)callServices{

    if ([self.userDefaults objectForKey:@"AssetTypeDownloaded"]) {
        
        [self changeProgress];
        [self checkDone];

    }
    else{
        
        
        if ([self.userDefaults objectForKey:@"ShouldDownloadAgain"]) {
            [AssetType removeAllObject];
            
            [AssetType callAssetTypeWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                
                [self changeProgress];
                [self checkDone];
                
            } withFailueHandler:^{
                NSLog(@"Fail Source AssetType");
                [self errorDownloading];
                
            }];
            
        }
        else
        {
            [AssetType loadFirstTimeDataFromPlistWithComplitionHandler:^(id  _Nonnull result) {
                [self changeProgress];
                NSLog(@"Check");
                [self checkDone];
            } withFailueHandler:^{
                NSLog(@"Fail Source AssetType");
                [self errorDownloading];
                
            }];
        }

        
    }
    
    
    //Done with the Plist
    if ([self.userDefaults objectForKey:@"SourceDownloaded"]) {
        [self changeProgress];
        NSLog(@"Check");
        [self checkDone];
    }
    else
    {
        if ([self.userDefaults objectForKey:@"ShouldDownloadAgain"])
        {
            [Source removeAllObject];
            
            [Source callSourceWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"" withComplitionHandler:^(id  _Nonnull result) {
                
                
                [self changeProgress];
                [self checkDone];
                
            } withFailueHandler:^{
                NSLog(@"Fail Source Source");
                [self errorDownloading];
            }];
            
        }
        else{
            [Source loadFirstTimeDataFromPlistWithComplitionHandler:^(id  _Nonnull result) {
                
                [self changeProgress];
                [self checkDone];
                
            } withFailueHandler:^{
                
                NSLog(@"Fail Source Source");
                [self errorDownloading];
                
            }];
        }

        
    }
    
    //Done with the Plist
    if ([self.userDefaults objectForKey:@"CountryListDownloaded"]) {
        [self changeProgress];
        NSLog(@"Check");
        [self checkDone];
    }
    else
    {
        if ([self.userDefaults objectForKey:@"ShouldDownloadAgain"]){
            
            //[Countries removeAllObject];
            
            [Countries callAllCountriesWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1"
                                withComplitionHandler:^(id  _Nonnull result) {
                                    [self changeProgress];
                                    NSLog(@"Check");
                                    [self checkDone];
                                }
                                    withFailueHandler:^{
                                        
                                        [self errorDownloading];
                                    }];
            
        }
        else{
            
            [Countries loadFirstTimeDataFromPlistWithComplitionHandler:^(id  _Nonnull result) {
                [self changeProgress];
                NSLog(@"Check");
                [self checkDone];
            } withFailueHandler:
             ^{
                [self errorDownloading];
            }];

        }
    }

    
    if ([self.userDefaults objectForKey:@"LandmarkTypeDownloaded"])
    {
        [self changeProgress];
        [self checkDone];
    }
    else{
        if ([self.userDefaults objectForKey:@"ShouldDownloadAgain"]){
            
            [LandmarkType removeAllObject];
            

         
            
            [LandmarkType callLandmarkTypeWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                
                [self changeProgress];
                NSLog(@"Check");
                [self checkDone];
                
                
            } withFailueHandler:^{
                
                
                NSLog(@"Fail LandmarkType");
                
                [self errorDownloading];
            }];
        }
        else
        {

            [LandmarkType loadFirstTimeDataFromPlistWithComplitionHandler:^(id  _Nonnull result) {
                
                [self changeProgress];
                NSLog(@"Check");
                [self checkDone];
                
            } withFailueHandler:^{
                
                NSLog(@"Fail LandmarkType");
                
                [self errorDownloading];
                
            }];
            
            
        }
    }

    
    

       // [self callFirstCycleOfServices];

    
}
- (void)viewDidLoad {
   // [super viewDidLoad];
    self.btnNext.layer.cornerRadius = 10;
   
    self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:self.iconImage.bounds];
    [self.iconImage addSubview:self.progressOverlayView];
    [self.progressOverlayView displayOperationWillTriggerAnimation];
    
    
    self.lblDescribtionMessage.text = @"";
    [self.lblWelcomeHeading setHidden:YES];
    
    if (![self isInternetConnectionAvailable]) {
        
        
        [self.imgNoImage setHidden:NO];
        [self.iconImage setHidden:YES];
        
        
        [self.btnNext setTitle:@"RETRY" forState:UIControlStateNormal];
        
        [self.btnNext setHidden:NO];
        
        self.lblText.text = @"Please Check your internet connect!";
        self.lblDescribtionMessage.text = @"";
        [self.lblWelcomeHeading setHidden:YES];
        return;
    }
    else
    {
        [self callServices];
        
    }
    

    
    
    Cities *currentCity = [Cities getCityByName:@"Karbala"];
    id source = [Landmarks getByCityId:currentCity.cityId];

    
    
    source = [Landmarks getAll];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)errorDownloading{
    [self.imgNoImage setHidden:NO];
    [self.iconImage setHidden:YES];
    
    
    [self.btnNext setTitle:@"RETRY" forState:UIControlStateNormal];
    self.lblText.text = @"Error while downloading some files!Please Check your internet connect!";
    
    [self.btnNext setHidden:NO];
    [self.btnNext setTitle:@"Retry" forState:UIControlStateNormal];
    
    
}
- (IBAction)btnDoneTapped:(UIButton *)sender {
    totalServicesCalledTillNow = 0;
    
    if ([sender.titleLabel.text isEqualToString:@"GET STARTED"]) {
        
        NSString * deviceToken = [self.userDefaults objectForKey:@"deviceToken"];
        
        if (!deviceToken) {
            deviceToken = @"";
        }

        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
        [SlideNavigationController sharedInstance].leftMenu = leftMenu;
        AppDelegate *currentApp = [[UIApplication sharedApplication] delegate];
        [currentApp.window
         setRootViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"SlideNavigationController"]];
        
        NSMutableDictionary *currentDictionary = [NSMutableDictionary new];
        
        [currentDictionary setObject:deviceToken forKey:@"deviceId"];
        
        [currentDictionary setObject:@"zaair" forKey:@"appType"];
        [currentDictionary setObject:@"iOS" forKey:@"deviceType"];
        
        NSString *current = [[UIDevice currentDevice] model];
        
        [currentDictionary setObject:current forKey:@"deviceInfo"];
        

        
        
        if ([self.userDefaults objectForKey:@"firstTimeDownloads"]) {
        

        }
        else
        [RestCall callWebServiceWithTheseParams:currentDictionary withSignatureSequence:@[@"deviceId",@"appType",@"deviceType",@"deviceInfo"] urlCalling:[baseServiceUrl stringByAppendingString:@"zaair/create-user-device"]
                          withComplitionHandler:^(id result) {
            
            
            NSLog(@"%@",result);
            
        } failureComlitionHandler:^{
            
            
            NSLog(@"f");
            
        }];
        
        [self.userDefaults setObject:@"1" forKey:@"firstTimeDownloads"];
        [self.userDefaults setObject:nil forKey:@"ShouldDownloadAgain"];
        
        
        NSLog(@"");
        
        
    }
    else{
        
        if (![self isInternetConnectionAvailable]) {
            
            
            [self.imgNoImage setHidden:NO];
            [self.iconImage setHidden:YES];
            
            
            [self.btnNext setTitle:@"RETRY" forState:UIControlStateNormal];
            self.lblText.text = @"Please Check your internet connect!";
            
            return;
        }
        else
        {
            
            [self.imgNoImage setHidden:YES];
            [self.iconImage setHidden:NO];
            
            
            [self.btnNext setTitle:@"GET STARTED" forState:UIControlStateNormal];
           //Please wait while we download the required files
            
             self.lblText.text = @"Please wait while we download the required files.";
            
            [self.btnNext setHidden:YES];

            
            [self callServices];
            
        }
        
    }
    
    
}


@end
