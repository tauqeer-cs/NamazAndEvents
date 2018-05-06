//
//  BaseViewController.m
//  GChat
//
//  Created by Tauqeer on 2014-09-26.
//  Copyright (c) 2014 Carlin. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "DateFormatter.h"
#import "FirstInitialDownloadsViewController.h"
#import "SelectCityViewController.h"
#import "ViewController.h"
#import "Landmarks.h"
#import "LoaderView.h"

@interface BaseViewController ()<MBProgressHUDDelegate>{
    
    MBProgressHUD *hud;
}

@end

@implementation BaseViewController


- (BOOL) isInternetConnectionAvailable
{
    Reachability *internet = [Reachability reachabilityWithHostName: @"www.google.com"];
    NetworkStatus netStatus = [internet currentReachabilityStatus];
    bool netConnection = false;
    switch (netStatus)
    {
        case NotReachable:
        {
            
            netConnection = false;
         
            break;
        }
        case ReachableViaWWAN:
        {
            netConnection = true;
            
            
            break;
        }
        case ReachableViaWiFi:
        {
            netConnection = true;
            break;
        }
    }
    return netConnection;
}

-(void)setWhenDidFilesWereDeletedLastTime{
    
    [self.userDefaults setObject:[DateFormatter showDate:[NSDate date] inStringFormate:@"dd-MM-yy"] forKey:@"WhenDidFilesWereDeletedLastTime"];
    
}


-(int)whenDidFilesWereDeletedLastTime{
    
    /*NSLog(@"%@",[self.userDefaults objectForKey:@"WhenDidFilesWereDeletedLastTime"]);
    
    NSDate *dt = [DateFormatter makeDataFromString:[self.userDefaults objectForKey:@"WhenDidFilesWereDeletedLastTime"] withDateFormate:@"dd-MM-yy"];
    
    int daysAfter = [[NSDate date] daysAfterDate:dt];
 
    
    if (daysAfter >= 0) {
        //[self EmptySandbox];
    }*/
    
    return 1;
}

-(void)EmptySandbox
{

}

-(NSString *)salt{
    
    return serviceSalt;
    
}

+(NSString *)giveServiceSalt{
    
    return serviceSalt;
    
}
-(NSUserDefaults *)userDefaults
{
    
    if (!_userDefaults) {
         _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}


-(void)makeTextBoxBorder:(UITextField *)textField
{
    
    [textField.layer setBorderWidth:0.3];
    
}
-(void)makeFirstLetterCapital:(UITextField *)textField
{

        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
}
-(void)setButtonBorder:(UIButton *)givenButton {
    
    [[givenButton layer] setBorderWidth:0.5f];
    [[givenButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.doSlidUpForNoInternetError = ![self isInternetConnectionAvailable];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blueColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.locationController = [[CoreLocationController alloc] init];
    self.locationController.delegate = self;

    [self setNeedsStatusBarAppearanceUpdate];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:90.0/255.0 green:0 blue:0 alpha:1];
    self.navigationController.navigationBar.translucent = YES;
    
    
    self.navigationController.navigationBar.topItem.title = @"";
    
    self.btnTopBarBUtton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.btnTopBarBUtton.frame = CGRectMake(50, 0, self.navigationController.view.frame.size.width - 100, 42);
    [self.btnTopBarBUtton addTarget:self action:@selector(topBarButtonTapped)
                   forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = self.btnTopBarBUtton;
    for (UIBarButtonItem *currentItem in self.navigationItem.rightBarButtonItems) {
        
        if (currentItem.tag == 1) {
         
            [currentItem setTarget:self];
            [currentItem setAction:@selector(btnSearchTapped)];
            

        }
        else if(currentItem.tag == 2){
            
            [currentItem setTarget:self];
            [currentItem setAction:@selector(btnLocationTapped)];
            
        }
    }
    

    if (!self.viewNoInternetNoGPS) {
        
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"NoInternetNoGPSView" owner:self options:nil];
        UIView *nibView = [nibObjects objectAtIndex:0];
        nibView.frame = CGRectMake(0, 24, nibView.frame.size.width, nibView.frame.size.height);
        
        self.viewNoInternetNoGPS = (NoInternetNoGPSView *)nibView;
        
        [self.viewNoInternetNoGPS.lblLocationServiceOffLarge setHidden:YES];
        [self.viewNoInternetNoGPS.lblInternetOffLarge setHidden:YES];
        
        [self.view addSubview:self.viewNoInternetNoGPS];
        
    }
    
    
}

-(void)setAttributedTextOfButton:(UIButton *)button withTitle:(NSString *)title withImageName:(NSString *)imageName{
    
    title = [@"   " stringByAppendingString:title];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:imageName];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    

    [attributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:attrStringWithImage];
    
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button setAttributedTitle:attributedString forState:UIControlStateHighlighted];
    [button setAttributedTitle:attributedString forState:UIControlStateSelected];
    
}

-(void)setAttributedTextOfButtonOnBack:(UIButton *)button withTitle:(NSString *)title withImageName:(NSString *)imageName{
    
    title = [@"   " stringByAppendingString:title];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:imageName];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    
    [attributedString replaceCharactersInRange:NSMakeRange(title.length - 2, 1) withAttributedString:attrStringWithImage];
    
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button setAttributedTitle:attributedString forState:UIControlStateHighlighted];
    [button setAttributedTitle:attributedString forState:UIControlStateSelected];
    
}


-(void)setAttributedTextOfLabe:(UILabel *)label withTitle:(NSString *)title withImageName:(NSString *)imageName{
    
    
    title = [title stringByAppendingString:@"    "];
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:imageName];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    
    [attributedString replaceCharactersInRange:NSMakeRange(title.length - 2, 1) withAttributedString:attrStringWithImage];
   
    [label setAttributedText:attributedString];
    
 //   [button setAttributedTitle:attributedString forState:UIControlStateNormal];

    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (self.sharedDelegate.myCurrentCity) {
    
        
        if (self.sharedDelegate.usingCurrentLocation) {
            
            if (self.sharedDelegate.myCurrentCity) {
            //    [self.btnTopBarBUtton setTitle:self.sharedDelegate.myCurrentCity.name forState:UIControlStateNormal];
            
            
                [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:self.sharedDelegate.myCurrentCity.name
                                  withImageName:@"location_icon"];
                
            }
            else{

                [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                                  withImageName:@"location_icon"];
                
                if (IS_IPHONE5 || IS_IPHONE_4S) {
                    
                    [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                                      withImageName:@"location_icon"];
                    [self.btnTopBarBUtton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
                    
                }
                
            }
        }
        else
        {
            
            [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:self.sharedDelegate.myCurrentCity.name
                              withImageName:@"location_icon"];
            

        }
    }
    else{
        if (self.sharedDelegate.usingCurrentLocation) {
            if (self.sharedDelegate.myCurrentCity) {
                
                [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:self.sharedDelegate.myCurrentCity.name
                                  withImageName:@"location_icon"];

            }
            else{
                [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                                  withImageName:@"location_icon"];
                
                
                if (IS_IPHONE5 || IS_IPHONE_4S) {
                    
                    [self setAttributedTextOfButton:self.btnTopBarBUtton withTitle:@"Near my current location"
                                      withImageName:@"location_icon"];
                [self.btnTopBarBUtton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
                    
                }
                
                
                
            }
        }
    }
    
    
    if (self.doSlideUpForLocationError && self.doSlidUpForNoInternetError) {
        
        [self slideUp:-40];
        
        [self.viewNoInternetNoGPS.lblLocationServiceOffLarge setHidden:YES];
        [self.viewNoInternetNoGPS.lblInternetOffLarge setHidden:YES];
        [self.viewNoInternetNoGPS.lblLocationServiceOffSmall setHidden:NO];
        [self.viewNoInternetNoGPS.lblInternetOffSmall setHidden:NO];
        
    }
    else if (self.doSlideUpForLocationError && !self.doSlidUpForNoInternetError){
        [self slideUp:-40];
        
        [self.viewNoInternetNoGPS.lblLocationServiceOffLarge setHidden:NO];
        [self.viewNoInternetNoGPS.lblInternetOffLarge setHidden:YES];
        
        [self.viewNoInternetNoGPS.lblLocationServiceOffSmall setHidden:YES];
        [self.viewNoInternetNoGPS.lblInternetOffSmall setHidden:YES];
        
    }
    else if (!self.doSlideUpForLocationError && self.doSlidUpForNoInternetError){
        [self slideUp:-40];
        
        [self.viewNoInternetNoGPS.lblLocationServiceOffLarge setHidden:YES];
        [self.viewNoInternetNoGPS.lblInternetOffLarge setHidden:NO];
        
        [self.viewNoInternetNoGPS.lblLocationServiceOffSmall setHidden:YES];
        [self.viewNoInternetNoGPS.lblInternetOffSmall setHidden:YES];
        
    }
 
    
}

- (void)btnSearchTapped
{
    [self goForSearch];
}

-(void)topBarButtonTapped{
    
    NSLog(@"Top Bar Button Tapped");
    
    if ([self isKindOfClass:[SelectCityViewController class]]) {
        return;
    }
    
    id currentSearch = [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"SelectCityViewController"];
    [self.navigationController pushViewController:currentSearch animated:YES];
}
-(void)btnLocationTapped{
    
    id currentSearch = [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"MapViewController"];
    
    
    if ([self isKindOfClass:[currentSearch class]]) {
        return;
    }
    
    [self.navigationController pushViewController:currentSearch animated:YES];
}






- (void)update:(CLLocation *)location {
    
    if (self.isLocationErrorMessageSlidedUp) {
     
        
        
        [self slideBackToNormal];
        self.isLocationErrorMessageSlidedUp = NO;
        
    }
    else
    {
        
    }
    
    self.myCurrentLocation = location;
    
    [self setMyMap];
    self.doSlideUpForLocationError = NO;
    

    
    
    if (self.sharedDelegate.usingCurrentLocation) {
        
        id lastOne = [self.userDefaults objectForKey:@"lastTimeLocationCalled"];
        
        if ([lastOne isKindOfClass:[NSString class]]) {
            
            
            
            NSDate *lastDate =  [DateFormatter makeDataFromString:lastOne withDateFormate:@"yyyy-MM-dd HH:mm:ss"];
            
            if ([DateFormatter hasMinutesPass:5 sinceTime:lastDate]) {

                [self useMyCurrentLocationUpdated];
                if ([self isKindOfClass:[ViewController class]]) {
                    
                    ViewController *tmp = (ViewController *)self;
                    
                    
                    [tmp reloadCollection];
                    
                    
                    
                    
                }
            }
            else {


            }
        }
    
        
    }
}

-(void)setMyMap{

    
    
}
- (void)openMapsWithDirectionsTo:(CLLocationCoordinate2D)to latitude:(double)latitude longitude:(double)longitude{
    
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = latitude;
    myLocation.longitude = longitude;
    
    NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
    [mapURL appendFormat:@"saddr=%f,%f", myLocation.latitude, myLocation.longitude];
    [mapURL appendFormat:@"&daddr=%f,%f", to.latitude, to.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    
}

- (void)locationError:(NSError *)error {
    
    
    
    if (self.isLocationErrorMessageSlidedUp) {
        
        
        
    }
    else{



        
        self.doSlideUpForLocationError = YES;
        self.isLocationErrorMessageSlidedUp = YES;
        
        if ([self isKindOfClass:[ViewController class]]) {
         
            if (!self.sharedDelegate.firstSlideDone) {
                //[self slideUp:-40];
                
                if (self.doSlideUpForLocationError && self.doSlidUpForNoInternetError) {
                    
                    [self slideUp:-40];
                    
                    [self.viewNoInternetNoGPS.lblLocationServiceOffLarge setHidden:YES];
                    [self.viewNoInternetNoGPS.lblInternetOffLarge setHidden:YES];
                    [self.viewNoInternetNoGPS.lblLocationServiceOffSmall setHidden:NO];
                    [self.viewNoInternetNoGPS.lblInternetOffSmall setHidden:NO];
                    
                }
                else if (self.doSlideUpForLocationError && !self.doSlidUpForNoInternetError){
                    [self slideUp:-40];
                    
                    [self.viewNoInternetNoGPS.lblLocationServiceOffLarge setHidden:NO];
                    [self.viewNoInternetNoGPS.lblInternetOffLarge setHidden:YES];
                    
                    [self.viewNoInternetNoGPS.lblLocationServiceOffSmall setHidden:YES];
                    [self.viewNoInternetNoGPS.lblInternetOffSmall setHidden:YES];
                    
                }
                else if (!self.doSlideUpForLocationError && self.doSlidUpForNoInternetError){
                    [self slideUp:-40];
                    
                    [self.viewNoInternetNoGPS.lblLocationServiceOffLarge setHidden:YES];
                    [self.viewNoInternetNoGPS.lblInternetOffLarge setHidden:NO];
                    
                    [self.viewNoInternetNoGPS.lblLocationServiceOffSmall setHidden:YES];
                    [self.viewNoInternetNoGPS.lblInternetOffSmall setHidden:YES];
                    
                }

                self.sharedDelegate.firstSlideDone = YES;
                
            }

        }
    }
   // self.locationUpdated = NO;
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


-(void)setTextFieldPlaceHolderColor : (UITextField *)textField withColor:(UIColor *)currentColor
{

    [textField setValue:currentColor forKeyPath:@"_placeholderLabel.textColor"];
}

-(void)restartLaoder{
    [self createNewLoader];
    
}
-(void)stopLoader{
    
    [hud removeFromSuperview];
}

-(void)createNewLoaderForModal{
    
    id c = self.navigationController.view;
    
    if (!c) {
        c = self.view;
    }
    hud = [[MBProgressHUD alloc] initWithView:c];
    
    
    [self.view addSubview:hud];
    hud.labelText = @"Posting";
    
    [hud show:YES];
    
}
- (void)createNewLoader{
    
    id c = self.navigationController.view;
    
    if (!c) {
        c = self.view;
    }
	hud = [[MBProgressHUD alloc] initWithView:c];
    
    
	[self.navigationController.view addSubview:hud];
	hud.labelText = @"Loading";
	
    [hud show:YES];
}

-(void)setLabelLightFont:(UILabel *)currentLabel withSize:(double)size
{
    
    [currentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                          size:size]];
}

-(void)setLabelFont:(UILabel *)currentLabel withSize:(double)size
{

    [currentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:size]];
}

-(void)setLabelFontBold:(UILabel *)currentLabel withSize:(double)size
{
    
    [currentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold"
                                          size:size]];
    
}


-(void)showAlert:(NSString *)title message:(NSString *)currentMessage
{
    UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:title
                                                         message:currentMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    
    ErrorAlert.tag = 0;
    
    ErrorAlert.delegate = self;
    [ErrorAlert show];
    
}

-(void)showAlert:(NSString *)title message:(NSString *)currentMessage customTag:(int)currentTag
{
    UIAlertView *ErrorAlert = [[UIAlertView alloc] initWithTitle:title
                                                         message:currentMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    
    ErrorAlert.tag = currentTag;
    
    ErrorAlert.delegate = self;
    [ErrorAlert show];
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
	return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
	return NO;
}


-(void)removeHelperViewFromTextBox:(UITextField *)txtBox{
    
    txtBox.autocorrectionType = UITextAutocorrectionTypeNo;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



-(AppDelegate *)sharedDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

-(NSString *)myCountryCode{
    
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    NSString *countryCode = [defaults objectForKey:@"phoneCode"];
    
    if (!countryCode) {
        return @"0";
        
    }
    return countryCode;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"Shaked");
        

        
        //
     
     //   [self callPanic];
    }
}

-(void)callPanic{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Rescue"
                                                             bundle: nil];
    UIViewController *tmp;
    tmp = [mainStoryboard instantiateViewControllerWithIdentifier: @"PanicViewController"];
    [self.navigationController pushViewController:tmp animated:YES];
    
    
}
-(UIViewController *)viewControllerFromStoryBoard:(NSString *)storyboardName withViewControllerName:(NSString *)viewId{

 
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboardName
                                                             bundle: nil];
    return (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: viewId];

}



+ (NSString *) makeMd5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //image.layer.cornerRadius = 20;
    
    
    return image;
}

-(void)RemoveAllStuffFromView : (UIView *)givenView
{

    for (UIView *currentView in givenView.subviews) {
 
        [currentView removeFromSuperview];
    }
}

-(void)goBack{
    

}

-(NSString *)myJid{
  

    return @"";
    
}

-(void)underLineButton:(UIButton *)givenButton{
  
    if (!givenButton) {
        return;

    }
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    givenButton.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:givenButton.titleLabel.text
                                                                                  attributes:underlineAttribute];
    
    
    
}

-(void)NotunderLineButton:(UIButton *)givenButton{
    
    NSString *text = givenButton.titleLabel.text;
    givenButton.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text];;
    

}
-(NSString *)filerString:(NSString *)givenString{
    
    NSString *unfilteredString = givenString;
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    return resultString;
}





-(void)connectionErrorDelegate{
    
    //[self.view makeToast:@"Unable to establish connection with the Server. Please check your internet connection and try again!"];
    
    
    for (UIView *allSubView in [self.view subviews]) {
        
        if ([allSubView isKindOfClass:[UIActivityIndicatorView class]]) {
            
            UIActivityIndicatorView *tmp = (UIActivityIndicatorView *)allSubView;
            
            [tmp stopAnimating];
            
        
        }
    }
    [self stopLoader];
    
}

-(void)roundTheView:(UIView *)currentView{
    CALayer *layer  =   currentView.layer;
    
    layer.cornerRadius  =   currentView.frame.size.width / 2;
    currentView.clipsToBounds = YES;
    
}


-(RestCall *)serviceCallObject{
    
    if (!_serviceCallObject) {
        _serviceCallObject = [RestCall new];
        _serviceCallObject.delegate =self;
    }
    return _serviceCallObject;
}


-(void)slideUp:(int)scale{
    CGRect viewFrame;
    viewFrame=self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    viewFrame.origin.y = -scale;
    self.view.frame=viewFrame;
    [UIView commitAnimations];
}

-(void)slideBackToNormal{
    CGRect viewFrame;
    viewFrame=self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    viewFrame.origin.y = 0;
    self.view.frame=viewFrame;
    [UIView commitAnimations];
}

-(UIImage *)backButtonHighlightedImage{
    
    return [self imageWithColor:[UIColor grayColor]];
}

-(void)makeCallToNumber:(NSString *)number{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",number]]];;
}

-(void)setHoverColorForButton:(UIButton *)button withColor:(UIColor *)color{
    
    
    if (!color) {
        [button setBackgroundImage:[self imageWithColor:[UIColor brownColor]] forState:UIControlStateHighlighted];
    }
    
    else
        [button setBackgroundImage:[self imageWithColor:color] forState:UIControlStateHighlighted];
    
}

-(void)setSelecedColorForButton:(UIButton *)button withColor:(UIColor *)color{
    
    
    if (!color) {
        [button setBackgroundImage:[self imageWithColor:[UIColor brownColor]] forState:UIControlStateSelected];
    }
    
    else
        [button setBackgroundImage:[self imageWithColor:color] forState:UIControlStateSelected];
    
}

-(void)xmppMessageNotificationCalledWith:(NSString *)senderNAme withMessage:(NSString *)message fromJid:(NSString *)fulljid{
    
    
    

    
}

-(void)callNotificationWithTitle:(NSString *)title withInformation:(NSString *)info
{

    
    

}
-(UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(BOOL)isWorldSelected{
    
    NSString *type = [self.userDefaults objectForKey:@"newType"];
    
    if ([type isEqualToString:@"1"]) {
        
        return YES;
    }
    return NO;
    
}

-(void)setWorldSelectedStatus:(BOOL)selected{
    
    
    [self.userDefaults setValue:selected ? @"0" : @"1" forKey:@"newType"];
    
}

-(BOOL)didShowFriendsWizard{
    NSString *type = [self.userDefaults objectForKey:@"didShowFriendsWizard"];
    
    if ([type isEqualToString:@"1"]) {
        
        return YES;
    }
    return NO;
    
}

-(void)showedFriendsWizard{
    
    [self.userDefaults setObject:@"1" forKey:@"didShowFriendsWizard"];
    
}



-(BOOL)didShowFamilyWizard{
    NSString *type = [self.userDefaults objectForKey:@"didShowFamilyWizard"];
    
    if ([type isEqualToString:@"1"]) {
        
        return YES;
    }
    return NO;
    
}

-(void)showedFamilyWizard{
    
    [self.userDefaults setObject:@"1" forKey:@"didShowFamilyWizard"];
    
}

-(BOOL)didShowPanicWizard{
    NSString *type = [self.userDefaults objectForKey:@"didShowPanicWizard"];
    
    if ([type isEqualToString:@"1"]) {
        
        return YES;
    }
    return NO;
    
}


-(void)showedPanicWizard{
    
    [self.userDefaults setObject:@"1" forKey:@"didShowPanicWizard"];
    
}

-(void)isAnonymousUser{
    
    
    
    [UIAlertView showWithTitle:@""
                       message:@"This action requires Login. Proceed to Login Screen ?"
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@[@"OK"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");
                          } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"]) {
                              
                              
                              UIStoryboard *mainStoryboard1 = [UIStoryboard
                                                               storyboardWithName:@"Main"
                                                               bundle: nil];
                              UIViewController *vc1 = [mainStoryboard1 instantiateViewControllerWithIdentifier: IS_IPHONE_4S ? @"RegistrationViewController4" : @"RegistrationViewController"];
                              [self.navigationController pushViewController:vc1
                                                                   animated:NO];
                              
                              

                              
                              
                          }
                      }];
    
    
    
}

-(void)commentButtonTapped:(id)itemToComment{
    
   
    
   
}


#pragma mark AAShareBubbles



-(BOOL)checkForAnonymous{
    
    if ([[self myJid] isEqualToString:@"anonymous"]) {
        
        return NO;
    }
    else
        return YES;
    
    return NO;
    
}


-(NSString *)countryCodeForFeeds{
    
    return self.isWorldSelected ? @"0" : [self.myCountryCode stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
}

-(UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController
                                                              interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}


-(void)goForSearch{
    
    id currentSearch = [self viewControllerFromStoryBoard:@"Main" withViewControllerName:@"GlobalSearchViewController"];
    
    
    if ([self isKindOfClass:[currentSearch class]]) {
        return;
    }
    [self.navigationController pushViewController:currentSearch animated:YES];
    
    
}

-(void)useMyCurrentLocationUpdated{
    NSMutableArray * allLandmarks = [NSMutableArray new];
    
    NSMutableArray * allDistances = [NSMutableArray new];
    
    
    //self.myCurrentLocation = [[CLLocation alloc] initWithLatitude:31.926025 longitude:44.314663];
    
    
    for (Landmarks *currentLandmark in [Landmarks getAll]) {
        [currentLandmark.geo_lat doubleValue];
        
        
        if ([currentLandmark.geo_lat intValue] != 0) {
            
            //[allLandmarks addObject:currentLandmark.geo_lat];
            
            CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:[currentLandmark.geo_lat  doubleValue] longitude:[currentLandmark.geo_long doubleValue]];
            
            
            double distance = [self.myCurrentLocation distanceFromLocation:LocationAtual];
            distance = distance/1000.0;
            
            if (distance < 10.0) {
                [allLandmarks addObject:currentLandmark];
                [allDistances addObject:[NSNumber numberWithDouble:distance]];
                
            }
        }
    }
    
    
    
    if ([allDistances count] > 0) {
        
        NSNumber *max=[allDistances valueForKeyPath:@"@min.self"];
        
        NSInteger index = [allDistances indexOfObject:max];
        Landmarks *mostNearLandmark = allLandmarks[index];
        
        
        self.sharedDelegate.myCurrentCity = mostNearLandmark.cityDetail;
        self.sharedDelegate.usingCurrentLocation = YES;
        self.sharedDelegate.nearLoctionLandmarks = allLandmarks;
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"");
        
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
        
        self.sharedDelegate.myCurrentCity = nil;
        self.sharedDelegate.usingCurrentLocation = YES;
        self.sharedDelegate.nearLoctionLandmarks = nil;
    }
    
    
    [self.userDefaults setObject:[DateFormatter getCurrentDate] forKey:@"lastTimeLocationCalled"];
    
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(UIView *)loadingView{
    
    if (!_loadingView) {
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
        _loadingView = [nibObjects objectAtIndex:0];
        [_loadingView setFrame:CGRectMake(0,
                                             0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height)];
        
        
    }
    return _loadingView;
}
@end
