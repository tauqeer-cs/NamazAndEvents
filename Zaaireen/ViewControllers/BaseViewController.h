//
//
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "Config.h"
#import "RestCall.h"
#import "Wrapper.h"
#import "SlideNavigationController.h"
#import "Validator.h"
#import "NSString+JS.h"
#import <CommonCrypto/CommonDigest.h>
#import "FileManager.h"
#import "NSString+HTML.h"
#import "UIAlertView+Blocks.h"
#import "ZFModalTransitionAnimator.h"
#import "CoreLocationController.h"
#import "Reachability.h"
#import "NoInternetNoGPSView.h"
#import "Cities.h"



@class AppDelegate;

@interface BaseViewController : UIViewController<UITextFieldDelegate,SlideNavigationControllerDelegate,RestCallDelegates,CoreLocationControllerDelegate>
{

    float radius;
    float bubbleRadius;
}


-(void)showAlert:(NSString *)title message:(NSString *)currentMessage;
-(void)showAlert:(NSString *)title message:(NSString *)currentMessage customTag:(int)currentTag;

-(void)stopLoader;
-(void)restartLaoder;
-(void)createNewLoaderForModal;

-(void)roundTheView:(UIView *)currentView;

-(AppDelegate *)sharedDelegate;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic) NSString *salt;
-(void)makeTextBoxBorder:(UITextField *)textField;
-(void)makeFirstLetterCapital:(UITextField *)textField;
-(void)setLabelFont:(UILabel *)currentLabel withSize:(double)size;
-(void)setTextFieldPlaceHolderColor : (UITextField *)textField withColor:(UIColor *)currentColor;
-(void)removeHelperViewFromTextBox:(UITextField *)txtBox;
-(void)RemoveAllStuffFromView : (UIView *)givenView;
-(void)setLabelLightFont:(UILabel *)currentLabel withSize:(double)size;
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;



-(void)setButtonBorder:(UIButton *)givenButton;

- (UIImage *)imageWithColor:(UIColor *)color;

-(void)goBack;

-(NSString *)myJid;

-(NSString *)myCountryCode;

-(void)underLineButton:(UIButton *)givenButton;
-(void)NotunderLineButton:(UIButton *)givenButton;

+(NSString *)giveServiceSalt;
+ (NSString *) makeMd5:(NSString *) input;
-(NSString *)filerString:(NSString *)givenString;
-(UIViewController *)viewControllerFromStoryBoard:(NSString *)storyboardName withViewControllerName:(NSString *)viewId;
-(void)setLabelFontBold:(UILabel *)currentLabel withSize:(double)size;

@property (nonatomic,strong) RestCall *serviceCallObject;


-(void)slideUp:(int)scale;
-(void)slideBackToNormal;

-(UIImage *)backButtonHighlightedImage;
-(void)makeCallToNumber:(NSString *)number;

-(void)setHoverColorForButton:(UIButton *)button withColor:(UIColor *)color;
-(void)setSelecedColorForButton:(UIButton *)button withColor:(UIColor *)color;
-(void)callNotificationWithTitle:(NSString *)title withInformation:(NSString *)info;
-(UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize;
-(void)callPanic;
-(BOOL)isWorldSelected;
-(BOOL)didShowFriendsWizard;
-(void)showedFriendsWizard;
-(BOOL)didShowFamilyWizard;
-(void)showedFamilyWizard;
-(BOOL)didShowPanicWizard;
-(void)showedPanicWizard;
-(void)setWorldSelectedStatus:(BOOL)selected;
-(void)setWhenDidFilesWereDeletedLastTime;

-(int)whenDidFilesWereDeletedLastTime;

-(void)xmppMessageNotificationCalledWith:(NSString *)senderNAme withMessage:(NSString *)message fromJid:(NSString *)fulljid;
-(void)isAnonymousUser;
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

-(void)commentButtonTapped:(id)itemToComment;
@property (nonatomic,strong) id objectSharing;


-(BOOL)checkForAnonymous;

@property (nonatomic,strong) NSString *countryCodeForFeeds;

@property (nonatomic, retain) CoreLocationController *locationController;

@property (nonatomic) BOOL isLocationErrorMessageSlidedUp;
- (BOOL) isInternetConnectionAvailable;


@property (nonatomic,strong) NoInternetNoGPSView *viewNoInternetNoGPS;
-(void)topBarButtonTapped;


@property (nonatomic,strong) UIButton *btnTopBarBUtton;

-(void)goForSearch;


@property (nonatomic,strong) CLLocation * myCurrentLocation;

-(void)setMyMap;
- (void)openMapsWithDirectionsTo:(CLLocationCoordinate2D)to latitude:(double)latitude longitude:(double)longitude;

@property (nonatomic) BOOL doSlideUpForLocationError;
@property (nonatomic) BOOL doSlidUpForNoInternetError;
-(void)useMyCurrentLocationUpdated;

-(void)setAttributedTextOfButton:(UIButton *)button withTitle:(NSString *)title withImageName:(NSString *)imageName;

-(void)setAttributedTextOfLabe:(UILabel *)label withTitle:(NSString *)title withImageName:(NSString *)imageName;
-(void)setAttributedTextOfButtonOnBack:(UIButton *)button withTitle:(NSString *)title withImageName:(NSString *)imageName;
+ (UIImage *)imageFromColor:(UIColor *)color;
@property (nonatomic,strong) UIView *viewSorryMessage;

@property (nonatomic,strong) UIView *loadingView;


@end
