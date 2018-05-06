//
//  RecitalDetailViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/9/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "RecitalDetailViewController.h"
#import "Asset.h"
#import "YLTextView.h"
#import <AVFoundation/AVFoundation.h>
#import "FileManager.h"
#import "ESImageViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>



@interface RecitalDetailViewController ()<UIWebViewDelegate, AVAudioSessionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblDuaName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet YLTextView *textAre;

@property (weak, nonatomic) IBOutlet UILabel *textViewStarting;

@property (nonatomic,strong) NSDictionary *extra;

@property (nonatomic,strong) Asset *extraAudioAsset;


@property (weak, nonatomic) IBOutlet UIButton *btnAudioOnOff;

@property (nonatomic, retain) MPMoviePlayerController *audioPlayer;


@end

@implementation RecitalDetailViewController

- (IBAction)segmentIndexChanged:(UISegmentedControl *)sender {
    
    NSString *title =
    [self.segment titleForSegmentAtIndex:_segment.selectedSegmentIndex];
    
    if ([title isEqualToString:@"English"]) {
      
        _textAre.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //paragraphStyle.lineHeightMultiple = 40.0f;
        paragraphStyle.maximumLineHeight = 40.0f;
        paragraphStyle.minimumLineHeight = 40.0f;
        NSString *string = [[all objectForKey:@"english"] stringByReplacingOccurrencesOfString:@"ThatsABigSpace" withString: [NSString stringWithFormat:@"\n"]];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:0 error:NULL];
        NSString *newString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"\n"];
        string = newString;
        
        string = [newString stringByDecodingHTMLEntities];
        
        
        
        NSDictionary *ats = @{
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        NSMutableAttributedString *attributedPara = [[NSMutableAttributedString alloc] initWithString:string attributes:ats];
        [attributedPara addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]
                               range:NSMakeRange(0, string.length)];
        
        
        self.textAre.attributedText = attributedPara;
        
        _textAre.textAlignment=NSTextAlignmentLeft;
        
        self.textViewStarting.text = @"In the name of Allah, Most Gracious, Most Merciful";
        
        if (IS_IPHONE_5) {
        [_textViewStarting setFont:[UIFont fontWithName:@"HelveticaNeue"  size:13]];
        }
        else if(IS_IPHONE_6){
        [_textViewStarting setFont:[UIFont fontWithName:@"HelveticaNeue"  size:16]];
        }
        else{
        [_textViewStarting setFont:[UIFont fontWithName:@"HelveticaNeue"  size:17]];
        }
        
        
    }
    else if ([title isEqualToString:@"Arabic"]) {

              //  _textAre.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
        [_textViewStarting setFont:[UIFont fontWithName:@"_PDMS_Saleem_QuranFont" size:40]];
        _textAre.font = [UIFont fontWithName:@"_PDMS_Saleem_QuranFont" size:32.0f];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //paragraphStyle.lineHeightMultiple = 40.0f;
        paragraphStyle.maximumLineHeight = 40.0f;
        paragraphStyle.minimumLineHeight = 40.0f;
        NSString *string = [[all objectForKey:@"arabic"] stringByReplacingOccurrencesOfString:@"ThatsABigSpace" withString: [NSString stringWithFormat:@"\n"]];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:0 error:NULL];
        NSString *newString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"\n"];
        string = newString;
        
        string = [newString stringByDecodingHTMLEntities];
        
        
        
        NSDictionary *ats = @{
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        NSMutableAttributedString *attributedPara = [[NSMutableAttributedString alloc] initWithString:string attributes:ats];
        [attributedPara addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"_PDMS_Saleem_QuranFont" size:32.0f]
                               range:NSMakeRange(0, string.length)];
        
        
        
        
        self.textAre.text = [[[all objectForKey:@"arabic"] stringByReplacingOccurrencesOfString:@"ThatsABigSpace" withString: [NSString stringWithFormat:@""]] stringByDecodingHTMLEntities];
        
        _textAre.textAlignment=NSTextAlignmentRight;
        self.textViewStarting.text = @"\u0628\u0650\u0633\u0652\u0645\u0650 \u0627\u0644\u0644\u0647\u0650 \u0627\u0644\u0631\u064e\u0651\u062d\u0652\u0645\u0670\u0646\u0650 \u0627\u0644\u0631\u064e\u0651\u062d\u0650\u064a\u0652\u0645\u0650";
        

        
    }
    else if ([title isEqualToString:@"Roman"]) {
        
              //  _textAre.textContainerInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        _textAre.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        //paragraphStyle.lineHeightMultiple = 40.0f;
        paragraphStyle.maximumLineHeight = 40.0f;
        paragraphStyle.minimumLineHeight = 40.0f;
        NSString *string = [[all objectForKey:@"roman"] stringByReplacingOccurrencesOfString:@"ThatsABigSpace" withString: [NSString stringWithFormat:@"\n"]];
        
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n+" options:0 error:NULL];
        NSString *newString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@"\n"];
        string = newString;
        
        string = [newString stringByDecodingHTMLEntities];
        
        
        
        NSDictionary *ats = @{
                              NSParagraphStyleAttributeName : paragraphStyle,
                              };
        NSMutableAttributedString *attributedPara = [[NSMutableAttributedString alloc] initWithString:string attributes:ats];
        [attributedPara addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]
                               range:NSMakeRange(0, string.length)];
        
        
        self.textAre.attributedText = attributedPara;
        
        
        
        
        _textAre.textAlignment=NSTextAlignmentLeft;
    
        self.textViewStarting.text = @"Bismillah-Hirrahman-Nirrahim";
        [_textViewStarting setFont:[UIFont fontWithName:self.textViewStarting.font.familyName size:28]];
        
        if (IS_IPHONE_5) {
            [_textViewStarting setFont:[UIFont fontWithName:@"HelveticaNeue"
                                                       size:22]];
        }
        else if (IS_IPHONE_6) {
            [_textViewStarting setFont:[UIFont fontWithName:@"HelveticaNeue"
                                                       size:20]];
        }
        
    }
}
id all;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.btnAudioOnOff setHidden:YES];
    
    self.lblDuaName.text = [self.selectedAsset.title stringByDecodingHTMLEntities];
    
    
    
    
    [self.segment removeSegmentAtIndex:1 animated:NO];
    [self.segment removeSegmentAtIndex:0 animated:NO];
    
    all = [RestCall makeObjectFromJSON:[_selectedAsset.detail stringByDecodingHTMLEntities]];
    
    if (!all) {
    
        NSString *extra = [[_selectedAsset.detail componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@"ThatsABigSpace"];
        all = [RestCall makeObjectFromJSON:extra];
    }
    
    
    self.extra = [RestCall makeObjectFromJSON:_selectedAsset.extra];
    
    if (self.extra) {
        
        
         int audioId = (int)[[[self.extra objectForKey:@"asset_ref"] objectForKey:@"audio"] integerValue];
        
        
        self.extraAudioAsset = [Asset getAllWithId:audioId];
        
        
        if (self.extraAudioAsset) {
            
            [FileManager getAssetAudioWithUrl:self.extraAudioAsset.assetUrl withComplitionHandler:^(NSString *path) {
                
                
                @try {
                    NSURL * url = [NSURL fileURLWithPath:path];
                    
                    NSError *myErr;
                    
                    
                    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&myErr]) {
                        // Handle the error here.

                    }
                    else{
                        // Since there were no errors initializing the session, we'll allow begin receiving remote control events
                        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
                    }
                    
                    //initialize our audio player
                    
                    
                    self.audioPlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
                    
                    [self.audioPlayer setShouldAutoplay:NO];
                    [self.audioPlayer setControlStyle: MPMovieControlStyleEmbedded];
                    self.audioPlayer.view.hidden = YES;
                    
                    [self.audioPlayer prepareToPlay];
                    [self.btnAudioOnOff setHidden:NO];
                
                
                    
                    
                    
                    
                }
                @catch (NSException *exception) {

                    
                }

                
                
            } withFailureHandler:^{
                
            } withAssetId:self.extraAudioAsset.assetId];
            
            
        }
        else {
            [self.btnAudioOnOff removeFromSuperview];
            
        }
        
    }
    else{
        [self.btnAudioOnOff removeFromSuperview];
        
    }
    
    NSArray * allKeys = [all allKeys];
    
    int indexToAdd = 0;
    

    if ([allKeys containsObject:@"arabic"]) {
        
        [self.segment insertSegmentWithTitle:@"Arabic" atIndex:indexToAdd animated:YES];
        
        
        
        if (indexToAdd == 0) {
            
            
            NSString *tmp = [[[all objectForKey:@"arabic"]
                             stringByReplacingOccurrencesOfString:@"ThatsABigSpace" withString: [NSString stringWithFormat:@""]] stringByDecodingHTMLEntities];
            
            
            
            self.textAre.text = tmp;
             _textAre.textAlignment=NSTextAlignmentRight;
            self.textViewStarting.text = @"\u0628\u0650\u0633\u0652\u0645\u0650 \u0627\u0644\u0644\u0647\u0650 \u0627\u0644\u0631\u064e\u0651\u062d\u0652\u0645\u0670\u0646\u0650 \u0627\u0644\u0631\u064e\u0651\u062d\u0650\u064a\u0652\u0645\u0650";
            
            [_textViewStarting setFont:[UIFont fontWithName:@"_PDMS_Saleem_QuranFont" size:40]];
            
            _textAre.font = [UIFont fontWithName:@"_PDMS_Saleem_QuranFont" size:32.0f];
           // _textViewStarting.textAlignment=NSTextAlignmentRight;
        }
        indexToAdd++;
    }
    if ([allKeys containsObject:@"roman"]) {
        
        
        if ([[all objectForKey:@"roman"] length] > 0) {
            

        [self.segment insertSegmentWithTitle:@"Roman" atIndex:indexToAdd animated:YES];
        
        if (indexToAdd == 0) {
 
        self.textAre.text = [[all objectForKey:@"roman"] stringByReplacingOccurrencesOfString:@"ThatsABigSpace" withString: [NSString stringWithFormat:@"\n"]];
             _textAre.textAlignment=NSTextAlignmentLeft;
            
            self.textViewStarting.text = @"Bismillah-Hirrahman-Nirrahim";
            [_textViewStarting setFont:[UIFont fontWithName:self.textViewStarting.font.familyName size:28]];
        
        }
        indexToAdd++;
        }
        
    }
    if ([allKeys containsObject:@"english"]) {

         if ([[all objectForKey:@"english"] length] > 0)
        {
        if (indexToAdd == 0){
                    
        self.textAre.text = [[all objectForKey:@"english"] stringByReplacingOccurrencesOfString:@"ThatsABigSpace" withString: [NSString stringWithFormat:@"\n"]];
        _textAre.textAlignment=NSTextAlignmentLeft;
        
        if (IS_IPHONE_5) {
            [_textViewStarting setFont:[UIFont fontWithName:self.textViewStarting.font.familyName size:13]];
        }
        else if(IS_IPHONE_6){
            [_textViewStarting setFont:[UIFont fontWithName:self.textViewStarting.font.familyName size:16]];
        }
        else{
            [_textViewStarting setFont:[UIFont fontWithName:self.textViewStarting.font.familyName size:18]];
        }
        
        self.textViewStarting.text = @"In the name of Allah, Most Gracious, Most Merciful";
        
        [_textViewStarting setFont:[UIFont fontWithName:self.textViewStarting.font.familyName size:18]];
        
        
        if (IS_IPHONE_5) {
            [_textViewStarting setFont:[UIFont fontWithName:self.textViewStarting.font.familyName size:13]];
        }
        }
        
        [self.segment insertSegmentWithTitle:@"English" atIndex:indexToAdd animated:YES];
        indexToAdd++;
        
    

    [self.segment setSelectedSegmentIndex:0];
    }
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}
- (IBAction)btnAudioOffOnTapped:(UIButton *)sender {
    
    if (!sender.selected) {


        [self.audioPlayer play];
        
        Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
        
        if (playingInfoCenter) {
            
            
            NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
       
            
            MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"main_bg"]];
            
            [songInfo setObject:@"Audio Title" forKey:MPMediaItemPropertyTitle];
            [songInfo setObject:@"Audio Author" forKey:MPMediaItemPropertyArtist];
            [songInfo setObject:@"Audio Album" forKey:MPMediaItemPropertyAlbumTitle];
            [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
            
            
            
            [songInfo setObject:[NSNumber numberWithInt:[[NSString stringWithFormat:@"%f", self.audioPlayer.duration]
                                                         intValue]] forKey:MPMediaItemPropertyPlaybackDuration];
            [songInfo setObject:[NSNumber numberWithDouble:(1.0f)] forKey:MPNowPlayingInfoPropertyPlaybackRate];
            
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
            
            
        }
        
        
    }
    else {
        
        [self.audioPlayer pause];
        
        
        
    }
    
    sender.selected = !sender.selected;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}
- (void) beginSeekForward:(BOOL)forward {
    
    
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlPlay:
                [self.audioPlayer play];
                //  play the video
                break;
                
            case  UIEventSubtypeRemoteControlPause:
                // pause the video
                [self.audioPlayer pause];
        
                
                break;
                
            case  UIEventSubtypeRemoteControlNextTrack:
                // to change the video
                break;
                
            case  UIEventSubtypeRemoteControlPreviousTrack:
                // to play the privious video 
                break;

            case UIEventSubtypeRemoteControlBeginSeekingForward:
               

                
                break;
                
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                
                
                break;
                
            default:
                break;
        }
    }
}

@end
