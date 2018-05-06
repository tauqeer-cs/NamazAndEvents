//
//  TripFeaturesListViewController.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/3/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "TripFeaturesListViewController.h"
#import "TripFeatures.h"
#import "TripSummaryTableViewCell.h"
#import "Landmarks.h"
#import "PoolListCollectionViewCell.h"
#import "VideoListingCollectionViewCell.h"
#import "GalleryListingCollectionViewCell.h"
#import "ESImageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AudioListingCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "PoolDetailViewController.h"
#import "AssetsDetail.h"

@interface TripFeaturesListViewController ()

@property (nonatomic,strong) NSArray *dataSource;

@property (nonatomic,strong) NSMutableArray *dataSourceSummary;
@property (weak, nonatomic) IBOutlet UIView *viewMainContainer;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) TripFeatures * notesItem;

@property (weak, nonatomic) IBOutlet UIWebView *webViewNotes;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *lblNotesHeading;

@property (nonatomic,strong) NSArray *guideLandmarks;

@property (nonatomic,strong) NSArray * imagesArray;
@property (nonatomic,strong) NSArray * videoArray;
@property (nonatomic) BOOL isGalleySecmentActive;
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;

@end


@implementation TripFeaturesListViewController

-(NSMutableArray *)dataSourceSummary{
    
    if (!_dataSourceSummary) {

         _dataSourceSummary = [NSMutableArray new];
    }
    return _dataSourceSummary;
}
- (IBAction)segmentTapped:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
        case 0:

            self.isGalleySecmentActive =  NO;
            
            [self.tableView setHidden:NO];
            [self.lblNotesHeading setHidden:NO];
            [self.webViewNotes setHidden:NO];
            [self.lblNotesHeading.superview setHidden:NO];
            
            [self.collectionView setHidden:YES];
            
            break;
            
        case 1:
            
            self.isGalleySecmentActive =  NO;
            
            [self.tableView setHidden:YES];
            [self.lblNotesHeading setHidden:YES];
            [self.webViewNotes setHidden:YES];
            [self.lblNotesHeading.superview setHidden:YES];
            [self.collectionView setHidden:NO];
            

            [self.collectionView reloadData];

            for (Landmarks *currentLandmark in self.guideLandmarks) {
                NSLog(@"c");
                
                if ([currentLandmark.assets count] > 0) {
                    
                    NSLog(@"");
                    
                }
                
                
                
                if ([[currentLandmark allImages] count] > 0 ) {
                    

                    
                    NSLog(@"");
                    
                }
                
                id assetDetailList = [AssetsDetail getWithLandmarkId:[currentLandmark.landmarkId intValue]];
                
                if ([assetDetailList count] > 0) {
                    
                    NSLog(@"");
                    
                    
                }
                
            }
            break;
         case 2:
         
            self.isGalleySecmentActive =  YES;
         
            [self.tableView setHidden:YES];
            [self.lblNotesHeading setHidden:YES];
            [self.webViewNotes setHidden:YES];
            [self.lblNotesHeading.superview setHidden:YES];
            [self.collectionView setHidden:NO];
            
            [self.collectionView reloadData];
            break;
            
        default:
            
            break;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView setHidden:YES];
    
    if (![self.userDefaults objectForKey:@"TripFeaturesDownloaded"]){

        [TripFeatures callTripFeaturesWithUpperLimit:@""
                                      withLowerLimit:@""
                                           withAppId:@"1"
                               withComplitionHandler:^(id  _Nonnull result) {
                                   
                                   self.dataSource = result;
                                   
                                   
                                   NSLog(@"%@",result);
                                   
                                   
                               } withFailueHandler:^{
                                   
                                   
                               }];
        
        
        
    }
    
    

    
    self.dataSource = [TripFeatures getAll];
    
    
    
    for (TripFeatures *currentItem in self.dataSource) {
        
        if ([currentItem.cName isEqualToString:@"Notes"]) {
         
            self.notesItem = currentItem;
            
        }
        else if ([currentItem.cName isEqualToString:@"Guide"]) {
         
            self.guideLandmarks =  [self.selectedTrip.tripLandmarks allObjects];
            
            NSArray *sortDescriptors = @[
                                         [NSSortDescriptor sortDescriptorWithKey:@"landmarkId" ascending:YES]
                                         ];
            NSArray *sortedPeople = [self.guideLandmarks sortedArrayUsingDescriptors:sortDescriptors];
            self.guideLandmarks = sortedPeople;
            
            
            
        }
        else if ([currentItem.cName isEqualToString:@"Videos"]) {
            
            self.videoArray = [currentItem.cValue componentsSeparatedByString:@","];

        }
        else if ([currentItem.cName isEqualToString:@"Images"]) {

            self.imagesArray = [currentItem.cValue componentsSeparatedByString:@","];
            
        }
        else
        {
            [self.dataSourceSummary addObject:currentItem];
        }
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"TripSummaryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellSummary"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PoolListCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellPoolList"];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoListingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellVideoName"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GalleryListingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellGalleryName"];
    
    
    
    [self.tableView reloadData];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    [self.webViewNotes loadHTMLString: [NSString
                                        stringWithFormat:@"%@",
                                        [self.notesItem.cValue stringByDecodingHTMLEntities]]
                           baseURL:nil];
    
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return [self.dataSourceSummary count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    TripSummaryTableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"cellSummary"];
    
    TripFeatures *currentItem = [self.dataSourceSummary objectAtIndex:indexPath.row];
    
    currentCell.lblPropertyName.text = currentItem.cName;
    currentCell.lblPropertyValue.text = currentItem.cValue;
    
    
    return currentCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
 
    if (_isGalleySecmentActive) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    if (_isGalleySecmentActive) {
        
        if (section == 1) {
           return [self.imagesArray count];
            
        }
        else{
            return [self.videoArray count];
        }
    }
    return [self.guideLandmarks count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_isGalleySecmentActive) {
        
        if (indexPath.section == 1) {
            
            return CGSizeMake(160, 160);
        }
        else{
            return CGSizeMake(160, 160);
        }
    }
    if (IS_IPHONE_5) {
        return CGSizeMake(320-6, 72);
    }
    else if (IS_IPHONE_6) {
        return CGSizeMake(375-8, 72);
        
    }
    return CGSizeMake(self.collectionView.frame.size.width, 72);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_isGalleySecmentActive) {
        
    
        if (indexPath.section == 0) {
            
            VideoListingCollectionViewCell *currentCell =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"cellVideoName" forIndexPath:indexPath];
            
            NSString *tmpUrl =[self.videoArray objectAtIndex:indexPath.row];
            tmpUrl = [tmpUrl trim];
            tmpUrl = [tmpUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
            tmpUrl  = [tmpUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
            
            
            ///<insert-youtube-video-id-here>/0.jpg


            if ([tmpUrl containsString:@"youtube"]) {
                
                NSLog(@"tmpUrl");
                
                //http://www.youtube.com/capMObCpFPc
                
                NSRange range = [tmpUrl rangeOfString:@"embed/"];
                NSString *substring = [[tmpUrl substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                

                [FileManager loadAssetImageWithImageView:currentCell.imgThumb
                                                     url:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",substring]
                                   withComplitionHandler:^{
                                       
                                   } withFailureHandler:^{
                                       
                                       
                                   } withLoader:nil];
                
                
                
                
            }
            if ([FileManager doesExistVideoWithUrl:tmpUrl]) {
                [FileManager getAssetVideoWithUrl:tmpUrl
                            withComplitionHandler:^(NSString *path) {
                                
                                NSURL * url = [NSURL fileURLWithPath:path];
                                
                                AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:url options:nil];
                                AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
                                generate1.appliesPreferredTrackTransform = YES;
                                NSError *err = NULL;
                                CMTime time = CMTimeMake(10, 1);
                                CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
                                UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [currentCell.imgThumb setImage:one];
                                });
                                
                            } withFailureHandler:^{
                                
                            } withAssetId:nil];
                
            }
            return currentCell;
        
        }
        else{
            
            GalleryListingCollectionViewCell *currentCell =
            [collectionView dequeueReusableCellWithReuseIdentifier:@"cellGalleryName" forIndexPath:indexPath];
            
            
            
            [FileManager loadAssetImageWithImageView:currentCell.imgThumb
                                                 url:[self.imagesArray objectAtIndex:indexPath.row]
                               withComplitionHandler:^{
                
            } withFailureHandler:^{
                
                
            } withLoader:currentCell.loader];
            
            
            return currentCell;
            
            
        }
    }
    
    Landmarks * currentLandMark = [self.guideLandmarks objectAtIndex:indexPath.row];
    PoolListCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellPoolList"
                                                                                        forIndexPath:indexPath];
    [currentCell populateDataFrom:currentLandMark];
    return currentCell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
 
    
    if (!_isGalleySecmentActive) {
        
        Landmarks * currentLandMark = [self.guideLandmarks objectAtIndex:indexPath.row];
        
        PoolDetailViewController *selectedTrip = (PoolDetailViewController *)[self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"PoolDetailViewController"];
        
        selectedTrip.itemSelected = currentLandMark;
        
        
        [self.navigationController pushViewController:selectedTrip animated:YES];
        
        
        return;
        
    }
    if (_isGalleySecmentActive)
    {
        if (indexPath.section == 0){
            
            NSString *tmpUrl =[self.videoArray objectAtIndex:indexPath.row];
            tmpUrl = [tmpUrl trim];
            tmpUrl = [tmpUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
            tmpUrl  = [tmpUrl stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
            
            
            if ([FileManager doesExistVideoWithUrl:tmpUrl]) {
                
                [FileManager getAssetVideoWithUrl:tmpUrl
                            withComplitionHandler:^(NSString *path) {
                    

                    NSURL *videoURL = [NSURL fileURLWithPath:path] ;
                    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                    mp.moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
                    [self presentMoviePlayerViewControllerAnimated:mp];
                    
                    self.moviePlayer = mp;
                    
                } withFailureHandler:^{
                    
                } withAssetId:nil];
            }
            else{
                
                [FileManager getAssetVideoWithUrl:tmpUrl
                            withComplitionHandler:^(NSString *path) {
                    
                    
                    
                } withFailureHandler:^{
                    
                } withAssetId:nil];
                
                
                NSURL *imageURL;


                
                if ([tmpUrl containsString:@"http"]) {
                    
                    
                    imageURL = [NSURL URLWithString:tmpUrl];
                }
                else
                imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"video/"]
                                                        stringByAppendingString:tmpUrl]];
                
                MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:imageURL];
                mp.moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
                [self presentMoviePlayerViewControllerAnimated:mp];
                self.moviePlayer = mp;
                
            }
            
        }
        else{
        
            [self showFrenchman:(int)indexPath.row];
            
        }
    }
}



- (void)showFrenchman:(int)number {
    ESImageViewController *ivc = [[ESImageViewController alloc] init];
    ivc.closeButton.hidden = NO;
    

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number inSection:0];
    
    
    
    GalleryListingCollectionViewCell *tmp1 =  (GalleryListingCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    
    
    [ivc setTappedThumbnail:tmp1.imgThumb];
    
    
    UIImage *tmp = [FileManager loadCityVoiceImageFromurl:[self.imagesArray objectAtIndex:number]];
    
    
    if (tmp) {
        
        [ivc setImage:tmp];
        
    }
    else
        return;
    [self presentViewController:ivc animated:YES completion:nil];
}

@end
