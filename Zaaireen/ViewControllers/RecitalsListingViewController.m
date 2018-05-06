//
//  RecitalsListingViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/6/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "RecitalsListingViewController.h"
#import "Landmarks.h"
#import "Asset.h"
#import "RecitationCollectionViewCell.h"
#import "AudioListingCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "LoaderView.h"
#import "AudioPlayerView.h"
#import "VideoListingCollectionViewCell.h"
#import "GalleryListingCollectionViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "RecitalDetailViewController.h"
#import "AssetsDetail.h"
#import "ESImageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@interface RecitalsListingViewController ()<AudioPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblLandmarkName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic,strong) NSMutableArray *textArray;
@property (nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,strong) NSMutableArray *audioArray;
@property (nonatomic,strong) NSMutableArray *videoArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic,strong) LoaderView *loaderView;
@property (nonatomic,strong) AudioPlayerView *audioPlayerView;


@property (nonatomic) int assetIdPlaying;

@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) MPMoviePlayerController *audioPlayer;

@end

@implementation RecitalsListingViewController

int indexSelected;

- (IBAction)segmentIndexChanged:(UISegmentedControl *)sender {
    
    
    NSString *title =
    [self.segment titleForSegmentAtIndex:_segment.selectedSegmentIndex];

    
    if ([title isEqualToString:@"Recitation"]) {
        self.dataSource = self.textArray;
        [self.collectionView reloadData];
        
    }
    else if ([title isEqualToString:@"Audio"]) {
        self.dataSource = self.audioArray;
        [self.collectionView reloadData];
        
    }
    else if ([title isEqualToString:@"Video"]) {
        
        
        self.dataSource = self.videoArray;
        [self.collectionView reloadData];
        
    }
    else if ([title isEqualToString:@"Gallery"]) {
        self.dataSource = self.imagesArray;
        [self.collectionView reloadData];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
__block id assetDetailList = [AssetsDetail getWithLandmarkId:[self.selectedLandmark.landmarkId intValue]];
    
    if ([self.userDefaults objectForKey:@"AssetsDetailDownloaded"]) {
        
    }
    else{
        [self.view addSubview:self.loadingView];
        
        [AssetsDetail callGetAssetDetailWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result)
         {
             [self.viewSorryMessage setHidden:YES];
             
             if ([self.userDefaults objectForKey:@"AssetsDownloaded"]) {
                 
             }
             else
                 [Asset callGetAssetListWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                     
                     [self.loadingView removeFromSuperview];
                     assetDetailList = [AssetsDetail getWithLandmarkId:[self.selectedLandmark.landmarkId intValue]];
                     [Landmarks updateAllLandmarkAssetAssosiation];
                     [self loadData:assetDetailList];
                     
                 } withFailueHandler:^{
                 }];
         }
        withFailueHandler:^{
        }];
    }
    self.lblLandmarkName.text = self.selectedLandmark.title;
    [self.segment removeSegmentAtIndex:1 animated:NO];
    [self.segment removeSegmentAtIndex:0 animated:NO];
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecitationCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellRecitationName"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"AudioListingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellAudioList"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideoListingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellVideoName"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"GalleryListingCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:@"cellGalleryName"];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    if (!self.selectedLandmark) {
      assetDetailList =  [AssetsDetail getAll];
     self.lblLandmarkName.text = @"All";
    }

    
    [self loadData:assetDetailList];
    
    //K
    
    
    
}

-(void)loadData :(id)assetDetailList
{
    NSMutableArray *allLandmarks = [NSMutableArray new];
    
    for (AssetsDetail *currentAssetDetail in assetDetailList) {
        
        
        @try {
        [allLandmarks addObject:[Asset getAllWithId:[currentAssetDetail.assetId intValue]]];
        }
        @catch (NSException *exception) {
          
            
            NSLog(@"%@",exception);
            
        }

        

        
    }
    
    
    NSArray *assets = allLandmarks;
    
    for (Asset *currentAsset in assets) {
        
        if ([currentAsset.mediaType isEqualToString:@"text"]) {
            
            [self.textArray addObject:currentAsset];
        }
        else if ([currentAsset.mediaType isEqualToString:@"image"]){
            [self.imagesArray addObject:currentAsset];
        }
        else if ([currentAsset.mediaType isEqualToString:@"audio"]){
            [self.audioArray addObject:currentAsset];
        }
        else if ([currentAsset.mediaType isEqualToString:@"video"]){
            [self.videoArray addObject:currentAsset];
        }
    }
    
    
    if ([assets count] ==0) {
        UIView *tmpView = [UIView new];
        [tmpView setFrame:CGRectMake(0, (self.view.frame.size.height - (self.collectionView.frame.size.height/2))-30,
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
        [lblMessage setText:@"Recitals will be available soon."];
        [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        lblMessage.textColor = [UIColor darkGrayColor];
        
        [tmpView addSubview:lblMessage];
        
        self.viewSorryMessage = tmpView;
        
    }
    
    
    int indexToAdd = 0;
    if ([self.textArray count] > 0) {
        
        [self.segment insertSegmentWithTitle:@"Recitation" atIndex:indexToAdd animated:YES];
        
        [self.segment setSelectedSegmentIndex:0];
        self.dataSource = self.textArray;
        [self.collectionView reloadData];
        
        indexToAdd++;
    }
    
    if ([self.audioArray count] > 0) {
        
        [self.segment insertSegmentWithTitle:@"Audio" atIndex:indexToAdd animated:YES];
        indexToAdd++;
        
        if ([self.textArray count] == 0) {
            self.dataSource = self.audioArray;
            
            [self.collectionView reloadData];
            
        }
    }
    
    if ([self.videoArray count] > 0) {
        
        [self.segment insertSegmentWithTitle:@"Video" atIndex:indexToAdd animated:YES];
        indexToAdd++;
    }
    
    if ([self.imagesArray count] > 0) {
        
        [self.segment insertSegmentWithTitle:@"Gallery" atIndex:indexToAdd animated:YES];
        indexToAdd++;
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSource count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Asset *currentAsset = [self.dataSource objectAtIndex:indexPath.row];
    if ([currentAsset.mediaType isEqualToString:@"text"]) {
    
            return CGSizeMake(self.collectionView.frame.size.width, 50);
    }
    else
    if ([currentAsset.mediaType isEqualToString:@"audio"]){
            return CGSizeMake(self.collectionView.frame.size.width, 115);
    }
    else if ([currentAsset.mediaType isEqualToString:@"video"]){
        return CGSizeMake(160, 160);
    }
    else if ([currentAsset.mediaType isEqualToString:@"image"]){
        return CGSizeMake(160, 160);
    }
    return CGSizeMake(self.collectionView.frame.size.width, 50);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Asset *currentAsset = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([currentAsset.mediaType isEqualToString:@"text"]) {
        
        RecitationCollectionViewCell *currentCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellRecitationName" forIndexPath:indexPath];
        
        currentCell.lblRecitationName.text = [[currentAsset.title stringByDecodingHTMLEntities] uppercaseString];
        return currentCell;
    }
    else
    if ([currentAsset.mediaType isEqualToString:@"audio"]){
        AudioListingCollectionViewCell *currentCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"cellAudioList" forIndexPath:indexPath];
        
        currentCell.lblZiaratName.text = [currentAsset.title stringByDecodingHTMLEntities];
        

        return currentCell;
    }
    else if ([currentAsset.mediaType isEqualToString:@"video"]){
        VideoListingCollectionViewCell *currentCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"cellVideoName" forIndexPath:indexPath];
        
        currentCell.lblTitlwe.text = currentAsset.title;
        
        if ([FileManager doesExistVideoWithUrl:currentAsset.assetUrl]) {
            [FileManager getAssetVideoWithUrl:currentAsset.assetUrl
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
                            
                        } withAssetId:currentAsset.assetId];
            
        }
        return currentCell;
    }
    else if ([currentAsset.mediaType isEqualToString:@"image"]){
        GalleryListingCollectionViewCell *currentCell =
        [collectionView dequeueReusableCellWithReuseIdentifier:@"cellGalleryName" forIndexPath:indexPath];
        
        currentCell.lblTitle.text = currentAsset.title;
        
        [FileManager loadAssetImageWithImageView:currentCell.imgThumb url:currentAsset.assetUrl withComplitionHandler:^{
            
        } withFailureHandler:^{
            
            
        } withLoader:currentCell.loader];
        
        return currentCell;
        
    }
    //
    return nil;
}

- (void)showFrenchman:(int)number {
    ESImageViewController *ivc = [[ESImageViewController alloc] init];
    ivc.closeButton.hidden = NO;
    
    Asset *currentAsset = [self.dataSource objectAtIndex:number];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:number inSection:0];

    
    
   GalleryListingCollectionViewCell *tmp1 =  (GalleryListingCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    [ivc setTappedThumbnail:tmp1.imgThumb];
    
    
    if ([currentAsset.assetUrl length] == 0) {
    
        return;
        
    }
    
    UIImage *tmp = [FileManager loadCityVoiceImageFromurl:currentAsset.assetUrl];
    

    if (tmp) {
        
        [ivc setImage:tmp];
        
    }
    else
        return;
    [self presentViewController:ivc animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Asset *currentAsset = [self.dataSource objectAtIndex:indexPath.row];
    
    if ([currentAsset.mediaType isEqualToString:@"text"]) {
        RecitalDetailViewController *recitalDetailViewControlle = (RecitalDetailViewController *)[self viewControllerFromStoryBoard:@"PersonalityDetail" withViewControllerName:@"RecitalDetailViewController"];
        
        
        recitalDetailViewControlle.selectedAsset = currentAsset;
        
        [self.navigationController pushViewController:recitalDetailViewControlle animated:YES];
        
    }
    else
    if ([currentAsset.mediaType isEqualToString:@"audio"]){
        
        indexSelected = (int)indexPath.row;
        
        NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
        self.loaderView = [nibObjects objectAtIndex:0];
        [self.loaderView setFrame:CGRectMake(0,
                                             0,
                                             self.view.frame.size.width,
                                             self.view.frame.size.height)];
        
        [self.loaderView.lblActivtyindication removeFromSuperview];
        [self.view addSubview:self.loaderView];
        
        nibObjects = [[NSBundle mainBundle] loadNibNamed:@"AudioPlayerView" owner:self options:nil];
        
        
        
        self.audioPlayerView = [nibObjects objectAtIndex:0];
        [self.audioPlayerView setFrame:CGRectMake(0,
                                                  160,
                                                  self.view.frame.size.width,
                                                  self.audioPlayerView.frame.size.height)];
        self.audioPlayerView.delegate = self;
        [self.view addSubview:self.audioPlayerView];
        
        if ([self.dataSource count] == 1) {
            [self.audioPlayerView disableNextAndPreviousButton];
        }
        
        
        self.audioPlayerView.imageUrl = [self.selectedLandmark giveFirstImage];
        
        if (self.assetIdPlaying == [currentAsset.assetId intValue]) {
        
            
            [self.audioPlayerView resumeAssetMediaPlaying:self.audioPlayer];
            
        }
        else
        [self.audioPlayerView setUpViewWithAssetUrl: currentAsset.assetUrl withAssetId:[currentAsset.assetId intValue] withAssetTitle:currentAsset.title];

        self.audioPlayerView.lblTitle.text = currentAsset.title;
    }
    else if ([currentAsset.mediaType isEqualToString:@"video"]){
        
      
        if (!self.loaderView) {
            NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
            self.loaderView = [nibObjects objectAtIndex:0];
            [self.loaderView setFrame:CGRectMake(0,
                                                 0,
                                                 self.view.frame.size.width,
                                                 self.view.frame.size.height)];
            
            [self.view addSubview:self.loaderView];
        }
        
        
        [self.loaderView bringSubviewToFront:self.view];
     
        
        if ([FileManager doesExistVideoWithUrl:currentAsset.assetUrl]) {

            [FileManager getAssetVideoWithUrl:currentAsset.assetUrl withComplitionHandler:^(NSString *path) {
                
                [self.loaderView removeFromSuperview];
                NSURL *videoURL = [NSURL fileURLWithPath:path] ;
                MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                mp.moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
                [self presentMoviePlayerViewControllerAnimated:mp];
                
                self.moviePlayer = mp;
                
            } withFailureHandler:^{
                
            } withAssetId:currentAsset.assetId];
        }
        else{
         
            [FileManager getAssetVideoWithUrl:currentAsset.assetUrl withComplitionHandler:^(NSString *path) {
                

                
            } withFailureHandler:^{
                
            } withAssetId:currentAsset.assetId];
            
            
            NSURL *imageURL = [NSURL URLWithString:[[baseImageLink stringByAppendingString:@"video/"]
                                                    stringByAppendingString:currentAsset.assetUrl]];

            [self.loaderView removeFromSuperview];
            MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:imageURL];
            mp.moviePlayer.movieSourceType = MPMovieSourceTypeUnknown;
            [self presentMoviePlayerViewControllerAnimated:mp];
            self.moviePlayer = mp;
        }
    }
    else if ([currentAsset.mediaType isEqualToString:@"image"]){
       
        [self showFrenchman:(int)indexPath.row];
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.moviePlayer = nil;
    
}
-(void)previousButtonTapped{
    indexSelected--;

    if (indexSelected == 0) {
        indexSelected = (int)([self.dataSource count] -1);
    }
    
    
    Asset *currentAsset = [self.dataSource objectAtIndex:indexSelected];
    [self.audioPlayerView setUpViewWithAssetUrl: currentAsset.assetUrl withAssetId:[currentAsset.assetId intValue] withAssetTitle:currentAsset.title];
    
    
    
    self.audioPlayerView.lblTitle.text = currentAsset.title;
    
    
    
}
-(void)nextButtonTapped{
    indexSelected++;
    
    if (indexSelected == [self.dataSource count]) {
        indexSelected = 0;
    }
    Asset *currentAsset = [self.dataSource objectAtIndex:indexSelected];
    
    [self.audioPlayerView setUpViewWithAssetUrl: currentAsset.assetUrl
                                    withAssetId:[currentAsset.assetId intValue]
                                 withAssetTitle:currentAsset.title];
    
    self.audioPlayerView.lblTitle.text = currentAsset.title;

}


-(void)closeButtonTapped{
    
    [self.audioPlayerView removeFromSuperview];
    [self.loaderView removeFromSuperview];
    
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

-(NSMutableArray *)textArray{
    
    if (!_textArray) {
        
        _textArray = [NSMutableArray new];
    }
    
    return _textArray;
}

-(NSMutableArray *)imagesArray{
    
    if (!_imagesArray) {
        
        _imagesArray = [NSMutableArray new];
    }
    return _imagesArray;
}



-(NSMutableArray *)videoArray{
    
    if (!_videoArray) {
        
        _videoArray = [NSMutableArray new];
    }
    return _videoArray;
}

-(NSMutableArray *)audioArray{
    
    if (!_audioArray) {
        
        _audioArray = [NSMutableArray new];
    }
    return _audioArray;
}


-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    NSLog(@"received event!");
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlPlay:
                [self.audioPlayer play];
                break;
                
            case  UIEventSubtypeRemoteControlPause:
                [self.audioPlayer pause];
                break;
                
            case  UIEventSubtypeRemoteControlNextTrack:
                // to change the video
                
                [self nextButtonTapped];
                
                break;
                
            case  UIEventSubtypeRemoteControlPreviousTrack:
                // to play the privious video
                
                [self previousButtonTapped];
                
                
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                
                
                NSLog(@"Dams");
                
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                
                NSLog(@"Dams");
                break;
                
            default:
                break;
        }
    }
}

-(void)setMyPlayer:(id)myPlayer withAssetId:(int)assetId{
    
    self.audioPlayer = myPlayer;
    
    self.assetIdPlaying = assetId;
}


@end
