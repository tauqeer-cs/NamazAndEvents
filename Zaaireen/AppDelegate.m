//
//  AppDelegate.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/2/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <StoreKit/StoreKit.h>
#import "AssetType.h"


@interface AppDelegate (){
    id services_;
}

@end

@implementation AppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

const NSString * global_bundleVersion = @"1.0.2";

const NSString * global_bundleIdentifier = @"com.vanguard.Zaaireen";

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    
    NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
    [currentUserDefault setObject:@"1" forKey:@"ShouldDownloadAgain"];
    
    UIBackgroundTaskIdentifier preLoadPNTask = [[UIApplication sharedApplication]
                                                beginBackgroundTaskWithExpirationHandler:^{
        NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
        [currentUserDefault setObject:@"1" forKey:@"ShouldDownloadAgain"];
    }];


    handler(preLoadPNTask);
    handler(UIBackgroundFetchResultNewData);
    handler(UIBackgroundFetchResultNewData);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    
    NSDictionary * pushNotificationUserInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (pushNotificationUserInfo)
    {
        NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
        [currentUserDefault setObject:@"1" forKey:@"ShouldDownloadAgain"];
    }

    
    
    [GMSServices provideAPIKey:@"AIzaSyAEg-TnUwVeMk64A6fqdTkJpBN_50QY8o4"];
    services_ = [GMSServices sharedServices];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    LeftMenuViewController *leftMenu = (LeftMenuViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeftMenuViewController"];
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    _managedObjectContext = self.managedObjectContext;
    
    
    NSUserDefaults *currentUserDefault = [NSUserDefaults standardUserDefaults];
    
    id isFirstTimeRunDone = [currentUserDefault objectForKey:@"firstTimeDownloads"];
    id shouldDownloadAgain = [currentUserDefault objectForKey:@"ShouldDownloadAgain"];
    
    
    if (!isFirstTimeRunDone) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"FirstDownloads" bundle:nil];
        UIViewController *initViewController;
        
        
        if (IS_IPHONE_5 || IS_IPOD) {
         initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewControllerFor5"];
        }
        else{

            initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewController"];
            initViewController = [storyBoard instantiateViewControllerWithIdentifier:IS_IPHONE_6 ?
                                  @"FirstInitialDownloadsViewController6" : @"FirstInitialDownloadsViewController"];

            
            if (IS_IPad) {
            initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewControllerFor4"];
            }
            else
            if (IS_IPHONE_4S) {
            initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewControllerFor4"];
            }

        }
        [self.window setRootViewController:initViewController];
    }
    else if(shouldDownloadAgain)
    {
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"FirstDownloads" bundle:nil];
        UIViewController *initViewController;
        
        
        if (IS_IPHONE_5) {
            initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewControllerFor5"];
        }
        else{
            
            initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewController"];
            initViewController = [storyBoard instantiateViewControllerWithIdentifier:IS_IPHONE_6 ?
                                  @"FirstInitialDownloadsViewController6" : @"FirstInitialDownloadsViewController"];
            
            
            if (IS_IPad) {
                initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewControllerFor4"];
            }
            else
                if (IS_IPHONE_4S) {
                    initViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FirstInitialDownloadsViewControllerFor4"];
                }
            
            
            
            [currentUserDefault setObject:nil forKey:@"AssetTypeDownloaded"];
            [currentUserDefault setObject:nil forKey:@"LandmarksDownloaded"];
            [currentUserDefault setObject:nil forKey:@"SourceDownloaded"];
            [currentUserDefault setObject:nil forKey:@"CountryListDownloaded"];
            [currentUserDefault setObject:nil forKey:@"LandmarkTypeDownloaded"];
            [currentUserDefault setObject:nil forKey:@"AssetTypeDownloaded"];
            [currentUserDefault setObject:nil forKey:@"CityListDownloaded"];
            [currentUserDefault setObject:nil forKey:@"LandmarksDownloaded"];
            [currentUserDefault setObject:nil forKey:@"AssetsDownloaded"];
            [currentUserDefault setObject:nil forKey:@"AssetsDetailDownloaded"];
            [currentUserDefault setObject:nil forKey:@"LandmarkPersonalityDetailDownloaded"];
            [currentUserDefault setObject:nil forKey:@"PersonalityDownloaded"];
            [currentUserDefault setObject:nil forKey:@"SourceDetailDownloaded"];
            [currentUserDefault setObject:nil forKey:@"EmergencyListDownloaded"];
            [currentUserDefault setObject:nil forKey:@"PersonalityCharacteristicsDownloaded"];
            
            
        }
        [self.window setRootViewController:initViewController];
        
    }
    
    return YES;
  
    /*
     NSURL *receiptURL = [NSBundle mainBundle].appStoreReceiptURL;
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];  NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
   
    if (!receipt) {
        SKReceiptRefreshRequest * recreq = [[SKReceiptRefreshRequest alloc] init];
        recreq.delegate = self;
        
        [recreq start];
        
   
    }
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0 error:&error];
    
    NSURL *storeURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL]; [storeRequest setHTTPMethod:@"POST"];
    
    [storeRequest setHTTPBody:requestData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError
                                               *connectionError){
    
                               if (connectionError) {

                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                options:0 error:&error];
                                   if (!jsonResponse) {
                                   }
                               }
                           }];
    */

    return YES;

}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
    
    
    NSString *tokenToSend =     [[[[deviceToken description]
                                   stringByReplacingOccurrencesOfString:@"<"withString:@""]
                                  stringByReplacingOccurrencesOfString:@">" withString:@""]
                                 stringByReplacingOccurrencesOfString: @" " withString: @""];
    [defauls setObject:tokenToSend forKey:@"deviceToken"];
    
    
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@" Failed to register for remote notifications: %@", error);
}

- (void)requestDidFinish:(SKRequest *)request
{

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"Did not get receipt");
    
}



- (id) parseReceiptData:(NSData *)receipt_data OnAppStoreUsingURL:(NSURL *) store_URL {
    
    NSDictionary * request_contents = @{
                                        @"receipt-data" : [receipt_data base64EncodedStringWithOptions:0]
                                        };
    
    NSError * error = nil;
    
    NSData * request_data = (
                             [NSJSONSerialization
                              dataWithJSONObject: request_contents
                              options           : 0
                              error             : &error
                              ]
                             );
    NSAssert(error == nil, @"JSON Serialization Error : %@", error);
    
    NSMutableURLRequest * store_request = [NSMutableURLRequest requestWithURL:store_URL];
    
    [store_request setHTTPMethod:@"POST"];
    [store_request setHTTPBody:request_data];
    
    NSURLResponse * response;
    
    NSData * result = (
                       [NSURLConnection
                        sendSynchronousRequest: store_request
                        returningResponse     : &response
                        error                 : &error
                        ]
                       );
    NSAssert(error == nil, @"NSURLConnection Error : %@", error);
    
    NSDictionary * json_response;
    
    if( result ) {
        json_response =  (
                          [NSJSONSerialization
                           JSONObjectWithData: result
                           options           : 0
                           error             : &error
                           ]
                          );
        NSAssert(error == nil, @"JSON Serialization Error : %@", error);
    }
    return json_response;
}


- (NSDictionary *) parseReceiptOnAppStore {
    
    NSURL   * receipt_url   = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData  * receipt_data  = [NSData   dataWithContentsOfURL:receipt_url];
    
    NSURL   * sandbox_url    = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSURL   * production_url = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];
    
    NSDictionary * response;
    
    response = (
                [self
                 parseReceiptData  : receipt_data
                 OnAppStoreUsingURL: production_url
                 ]
                );
    
    if( [response[@"status"] intValue] == 21007  ) {
        
        response = (
                    [self
                     parseReceiptData  : receipt_data
                     OnAppStoreUsingURL: sandbox_url
                     ]
                    );
    }
    return response;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.brian.starr.ThousandWords" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Zaaireen" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    NSLog(@"");
    
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Zaaireen.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        
        abort();
    }
    
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (void)saveContext {
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
      
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            abort();
        }
    }
}


@end
