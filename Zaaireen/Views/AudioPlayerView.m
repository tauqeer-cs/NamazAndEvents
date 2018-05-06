//
//  AudioPlayerView.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/9/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "AudioPlayerView.h"
#import "FileManager.h"
#import "LoaderView.h"
#import "AppDelegate.h"


@interface AudioPlayerView()

@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (nonatomic,strong) LoaderView *loaderView;
@property (weak, nonatomic) IBOutlet UIView *loaderViewGray;
@property (nonatomic, weak) NSTimer *updateTimer;


@property (nonatomic,strong) NSString *titleName;

@end

@implementation AudioPlayerView


-(void)disableNextAndPreviousButton{
 
    [self.btnNext setEnabled:NO];
    [self.btnPrevious setEnabled:NO];
    
}
- (IBAction)btnNextTapped {
    
    [self.delegate nextButtonTapped];
    
}
- (IBAction)btnPreviousButtonTapped {

    [self.delegate previousButtonTapped];
    
}


- (void) onMovieDurationAvailable:(NSNotification *)notification {
    NSLog(@"duration received notification");
    
    //self.audioPlayer.duration = [[notification object] duration];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:self.audioPlayer];


    NSString *intervalString = [NSString stringWithFormat:@"%f", self.audioPlayer.duration];
    
    [self.slider setMaximumValue:[intervalString floatValue]];
    float c = self.audioPlayer.duration;
    
    c = [[NSString stringWithFormat:@"%f", self.audioPlayer.duration] intValue];
    
    self.lblTotalTime.text =[self timeFormatted:[intervalString intValue]];
    
    
    NSLog(@"c");
    
    
    
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    
    if (playingInfoCenter) {
        
        
        NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
        
        
        
        UIImage *tmp = [UIImage imageNamed:@"main_bg"];
        
        UIImage *tmp2 = [FileManager getLandmarkImageFrom:self.imageUrl];
        
        
        if (tmp2) {
            tmp = tmp2;
        }
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:tmp];
        
        
        
        
        [songInfo setObject:self.titleName forKey:MPMediaItemPropertyTitle];
        [songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
        [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
        [songInfo setObject:[NSNumber numberWithDouble:(1.0f)]
                     forKey:MPNowPlayingInfoPropertyPlaybackRate];
        
        [songInfo setObject:[NSNumber numberWithInt:[[NSString stringWithFormat:@"%f", self.audioPlayer.duration]
                                                     intValue]] forKey:MPMediaItemPropertyPlaybackDuration];
        [songInfo setObject:[NSNumber numberWithDouble:(1.0f)] forKey:MPNowPlayingInfoPropertyPlaybackRate];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];

        
    }
    
}




-(void)resumeAssetMediaPlaying:(MPMoviePlayerController *)mediaPlaying
{
    
    
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(callAfterOneSecond) userInfo:nil repeats:YES];
    
    self.audioPlayer = mediaPlaying;
    
    [self onMovieDurationAvailable:nil];
     [_loaderViewGray setHidden:YES];
    
}

-(void)setUpViewWithAssetUrl:(NSString *)assetUrl withAssetId:(int)withAssetId withAssetTitle:(NSString *)title
{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMovieDurationAvailable:)
                                                 name:MPMovieDurationAvailableNotification
                                               object:self.audioPlayer];
    
    
    AppDelegate *currentAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AVAudioPlayer *tmpPlayer = currentAppDelegate.audioPlayerPlaying;
    [tmpPlayer stop];
    
    currentAppDelegate.audioPlayerPlaying = nil;
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(callAfterOneSecond) userInfo:nil repeats:YES];
    

    
    [_loaderViewGray setHidden:NO];

    [FileManager getAssetAudioWithUrl:assetUrl withComplitionHandler:^(NSString *path) {
        
        self.titleName = title;
        
    
        NSURL * url = [NSURL fileURLWithPath:path];
       
        
        NSError *myErr;
        
        
        if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
            // Handle the error here.

        }
        else{
            // Since there were no errors initializing the session, we'll allow begin receiving remote control events
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        }
        
        
        self.audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [self.audioPlayer setShouldAutoplay:NO];
        [self.audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
        self.audioPlayer.view.hidden = YES;
        [self.audioPlayer prepareToPlay];
        [_loaderViewGray setHidden:YES];
        [self.audioPlayer play];
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)] ;
        [self.slider addGestureRecognizer:gr];
        
        [self.delegate setMyPlayer:self.audioPlayer withAssetId:withAssetId];
    } withFailureHandler:^{
        
    } withAssetId:[NSNumber numberWithInt:withAssetId]]  ;
    
    
    
}

- (NSString *)timeFormatted:(int)totalSeconds{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}


- (void)sliderTapped:(UIGestureRecognizer *)g {
    UISlider* s = (UISlider*)g.view;
    if (s.highlighted)
        return; // tap on thumb, let slider deal with it
    CGPoint pt = [g locationInView: s];
    CGFloat percentage = pt.x / s.bounds.size.width;
    CGFloat delta = percentage * (s.maximumValue - s.minimumValue);
    CGFloat value = s.minimumValue + delta;
    [s setValue:value animated:YES];
   
    //self.audioPlayer. = value;
       [self.audioPlayer setCurrentPlaybackTime:value];
    
    
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    
    NSLog(@"%f",sender.value);
    
    [self.audioPlayer setCurrentPlaybackTime:sender.value];
    
    //self.player.currentTime = sender.value;
    
    
   self.lblCurrentTime.text = [self timeFormatted:[[NSString stringWithFormat:@"%f", self.audioPlayer.currentPlaybackTime] intValue]];
    
    

    
}

- (IBAction)sendTouched:(UISlider *)sender {
   
    
    
    self.audioPlayer.currentPlaybackTime = sender.value;
    
    
   self.lblCurrentTime.text = [self timeFormatted:[[NSString stringWithFormat:@"%f", self.audioPlayer.currentPlaybackTime] intValue]];

}

-(void)callAfterOneSecond
{
    
    [self.slider setValue:[[NSString stringWithFormat:@"%f", self.audioPlayer.currentPlaybackTime] floatValue]];
    
    self.lblCurrentTime.text = [self timeFormatted:[[NSString stringWithFormat:@"%f", self.audioPlayer.currentPlaybackTime] intValue]];
  

    
    
}
- (IBAction)btnPauseTapped:(UIButton *)sender {
    
    if (sender.selected) {
    //[self.player play];
        
        [self.audioPlayer play];
        sender.selected = !sender.selected;
    }
    else
    {
        //[self.audioPlayer pause];
        [self.audioPlayer pause];
        sender.selected = !sender.selected;
    }
}
- (IBAction)btnCloseTapped {
    
    [self.delegate closeButtonTapped];
    //self.audioPlayer = nil;
    
}

///play_icon
@end
