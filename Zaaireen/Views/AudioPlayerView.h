//
//  AudioPlayerView.h
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/9/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@protocol AudioPlayerViewDelegate

-(void)closeButtonTapped;
-(void)nextButtonTapped;
-(void)previousButtonTapped;

@optional

-(void)setMyPlayer:(id)myPlayer withAssetId:(int)assetId;


@end


@interface AudioPlayerView : UIView<AVAudioPlayerDelegate>
-(void)disableNextAndPreviousButton;

@property (nonatomic,strong) id<AudioPlayerViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTime;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalTime;

-(void)setUpViewWithAssetUrl:(NSString *)assetUrl withAssetId:(int)withAssetId withAssetTitle:(NSString *)title;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, retain) MPMoviePlayerController *audioPlayer;

-(void)resumeAssetMediaPlaying:(MPMoviePlayerController *)mediaPlaying;

@property (nonatomic,strong) NSString *imageUrl;



@end
