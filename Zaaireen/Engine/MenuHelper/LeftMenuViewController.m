//
//  MenuViewController.m
//  SlideMenu
//
//  Created by Aryan Gh on 4/24/13.
//  Copyright (c) 2013 Aryan Ghassemi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "SlideNavigationContorllerAnimatorFade.h"
#import "SlideNavigationContorllerAnimatorSlide.h"
#import "SlideNavigationContorllerAnimatorScale.h"
#import "SlideNavigationContorllerAnimatorScaleAndFade.h"
#import "SlideNavigationContorllerAnimatorSlideAndFade.h"
#import "SideMenuListingTableViewCell.h"
#import "AppDelegate.h"
#import "AppConstants.h"
#import "Config.h"
#import "SideMenuUserTableViewCell.h"
#import "FileManager.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface LeftMenuViewController()

@property (weak, nonatomic) IBOutlet UITableView *statusTable;

@property (nonatomic,strong) AppDelegate *currentApp;

@end
@implementation LeftMenuViewController

#pragma mark - UIViewController Methods -
NSString *lastStatus;
NSUserDefaults *defaults;

AppDelegate *appDelegate;




-(AppDelegate *)currentApp
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
-(void)reloadStatus{
    
    defaults = [NSUserDefaults standardUserDefaults];
    lastStatus = [defaults objectForKey:@"lastStatus"];
    
    
    NSArray *reloadIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [self.statusTable reloadRowsAtIndexPaths:reloadIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self.slideOutAnimationEnabled = YES;
	
	return [super initWithCoder:aDecoder];
}
-(void)reloadCount{
 
    NSArray *reloadIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    [self.statusTable reloadRowsAtIndexPaths:reloadIndexPath withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    
}
- (void)viewDidLoad
{
	[super viewDidLoad];
    
   // delegate.myLeftSideMenu = self;
    
    defaults = [NSUserDefaults standardUserDefaults];
    lastStatus = [defaults objectForKey:@"lastStatus"];
    
}


-(void)reloadData{
    
    defaults = [NSUserDefaults standardUserDefaults];
    lastStatus = [defaults objectForKey:@"lastStatus"];
    
    
    [self.tableView reloadData];
    
    
}
#pragma mark - UITableView Delegate & Datasrouce -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 9;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return IS_IPHONE_4S ? 45 : 45;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideMenuListingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IS_IPHONE_4S ? @"normalOptionsCell" : @"normalOptionsCell"];
    
	switch (indexPath.row)
	{
        case 0:
            
            //sidemenu_voice
            cell.lblMenuName.text = @"Home";
            cell.lblIconImage.image = [UIImage imageNamed:@"home_menu_icon-1"];
            
            
            
            break;
        
            
        case 1:
            
            
            cell.lblMenuName.text = @"Recitals";
            cell.lblIconImage.image = [UIImage imageNamed:@"recitals_menu_icon"];
            
            
            break;
            
            
        case 2:
            
            cell.lblMenuName.text = @"Namaz Timing";
            cell.lblIconImage.image = [UIImage imageNamed:@"namaz_menu_icon-1"];
			break;
			
		case 3:

          //  self.currentApp.currentTag = 1;
            cell.lblMenuName.text = @"Qibla Compass";
            cell.lblIconImage.image = [UIImage imageNamed:@"qibla_menu_icon-1"];
            break;
			
		case 4:
            cell.lblMenuName.text = @"Weather";
            cell.lblIconImage.image = [UIImage imageNamed:@"weather_menu_icon-1"];
            
            break;
        
        case 5:
            
            cell.lblMenuName.text = @"Calendar";
            cell.lblIconImage.image = [UIImage imageNamed:@"thisday_menu_icon-1"];
            

            break;


            
        case 6:
            

            cell.lblMenuName.text = @"History";
            cell.lblIconImage.image = [UIImage imageNamed:@"history_menu_icon"];
            
            
            break;
           
        case 7:
            cell.lblMenuName.text = @"Emergency";
            cell.lblIconImage.image = [UIImage imageNamed:@"econtacts_menu_icon"];
            
            
            break;
            

        case 8:
            
            cell.lblMenuName.text = @"Location Selector";
            cell.lblIconImage.image = [UIImage imageNamed:@"location_menu_icon"];
            
            
            break;
            


            
            
	}
	
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:133.0/255.0 green:133.0/255.0 blue:133.0/255.0 alpha:1.0];
    
    [cell setSelectedBackgroundView:bgColorView];
    

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
															 bundle: nil];
	
	UIViewController *vc ;
    


    
    
  	switch (indexPath.row)
	{
 
            
        case 0:

            [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
            
            return;
            
            break;
        
        case 1:
            
            mainStoryboard = [UIStoryboard storyboardWithName:@"PersonalityDetail" bundle: nil];
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"RecitalsListingViewController"];
            break;
            
		case 2:
			

            mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle: nil];
            
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"NamazTimViewController"];
            
            
            
            break;
			
		case 3:
        
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle: nil];
            
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"QiblaCompassViewController"];
            
            break;
			
		case 4:
            
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle: nil];
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"WeatherForcastViewController"];
         //   tmpSwipe = vc;
            
          	break;
        case 5:

            mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                       bundle: nil];
            
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"InThisWeekViewController"];
            
            break;

            
            
        case 6:
            mainStoryboard = [UIStoryboard storyboardWithName:@"PersonalityDetail" bundle: nil];
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AllHistoryViewController"];
            
        break;
        case 7:
            
            mainStoryboard = [UIStoryboard storyboardWithName:@"PersonalityDetail" bundle: nil];
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AllEmergencyNumbersViewController"];
            //vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"AllEmergencyNumbersViewController2"];
            
        break;


        case 8:
            mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            vc = [mainStoryboard instantiateViewControllerWithIdentifier: @"SelectCityViewController"];
            break;

	}
	

	[[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
															 withSlideOutAnimation:self.slideOutAnimationEnabled
																	 andCompletion:nil];
}




@end
