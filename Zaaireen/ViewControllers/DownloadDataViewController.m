//
//  DownloadDataViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/3/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "DownloadDataViewController.h"
#import "Asset.h"
#import "Landmarks.h"
#import "DownloadCitieView.h"
#import "DownloadCityTableViewCell.h"
#import "DownloadPercentageView.h"
#import "FileManager.h"
#import "AssetsDetail.h"

@interface DownloadDataViewController ()<DownloadCitieViewDelegate,DownloadPercentageViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnImageSize;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoSize;
@property (weak, nonatomic) IBOutlet UIButton *btnAudioSize;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherSize;

@property (weak, nonatomic) IBOutlet UIButton *btnIran;

@property (weak, nonatomic) IBOutlet UIButton *btnIraq;
@property (weak, nonatomic) IBOutlet UIButton *btnSyria;

@property (nonatomic,strong) NSMutableArray * imagesArray;
@property (nonatomic,strong) NSMutableArray * videosArray;
@property (nonatomic,strong) NSMutableArray * audioArray;
@property (nonatomic,strong) NSMutableArray * othersArray;
@property (nonatomic,strong) UIView *loaderView;

@property (nonatomic,strong) DownloadCitieView *downloadCityView;

@property (nonatomic,strong) NSMutableArray *citiesSelected;

@property (nonatomic,strong) DownloadPercentageView *downloadProgressView;


@property (weak, nonatomic) IBOutlet UILabel *lblTotalSize;

@property (nonatomic,strong) Cities *currentCity;
@property (weak, nonatomic) IBOutlet UILabel *lblMediaOf;


@property (nonatomic,strong) NSMutableArray *assetsIran;
@property (nonatomic,strong) NSMutableArray *assetsIraq;
@property (nonatomic,strong) NSMutableArray *assetsSyria;


@property (nonatomic) int lastCountryTapped;

@end

@implementation DownloadDataViewController


-(NSMutableArray *)assetsIran{
    if (!_assetsIran) {
        
        
        _assetsIran = [NSMutableArray new];
        
    }
    
    return _assetsIran;
}

-(NSMutableArray *)assetsIraq{
    
    
    if (!_assetsIraq) {
       _assetsIraq = [NSMutableArray new];
    }
    return _assetsIraq;
}
-(NSMutableArray *)assetsSyria{
    
    
    if (!_assetsSyria) {
      _assetsSyria  = [NSMutableArray new];
    }
    return _assetsSyria;
}

-(void)initializeStuff{
    
    
    
    
    NSArray * allLandmarks = [Landmarks getByCityId:self.sharedDelegate.myCurrentCity.cityId];
    
    
    int count;
    if (![self.userDefaults objectForKey:@"AssetsDownloaded"] || ![self.userDefaults objectForKey:@"AssetsDetailDownloaded"]) {
        
        [self.view addSubview:self.loadingView];
        [AssetsDetail removeAllObject];
        [Asset removeAllObject];
        
        [AssetsDetail callGetAssetDetailWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result)
         {
             [Asset callGetAssetListWithUpperLimit:@"" withLowerLimit:@"" withAppId:@"1" withComplitionHandler:^(id  _Nonnull result) {
                 
                 
                 [self.loadingView removeFromSuperview];
                 [Landmarks updateAllLandmarkAssetAssosiation];
                 
                 
                [self.sharedDelegate saveContext];
                 
                 for (Landmarks *currentLandmark in allLandmarks) {
                     
                     for (Asset * currentAsset in currentLandmark.assets) {
                         
                         if ([currentAsset.isDowloaded intValue] == 1) {
                             
                         }
                         else{
                             if ([currentAsset.mediaType isEqualToString:@"image"])
                             {
                                 [self.imagesArray addObject:currentAsset];
                             }
                             else if ([currentAsset.mediaType isEqualToString:@"text"]){
                                 
                             }
                             else if ([currentAsset.mediaType isEqualToString:@"audio"]){
                                 
                                 [self.audioArray addObject:currentAsset];
                                 
                             }
                             else if ([currentAsset.mediaType isEqualToString:@"video"]){
                                 
                                 [self.videosArray addObject:currentAsset];
                             }
                             else
                             {
                                 
                             }
                         }
                         
                     }
                     
                 }
                 [self calculateSize];
                 
                 
             } withFailueHandler:^{
                 
                 [self.loadingView removeFromSuperview];
                 
             }];
             
             
         }
                                     withFailueHandler:^{
                                         
                                         [self.loadingView removeFromSuperview];
                                         
                                         
                                     }];
        
    }
    
    
    self.lblMediaOf.text = @"for offline use.";
    
    self.currentCity = self.sharedDelegate.myCurrentCity;
    self.btnAudioSize.selected = YES;
    self.btnImageSize.selected = YES;
    self.btnVideoSize.selected = YES;
    self.btnOtherSize.selected = YES;
    
    
    
    
    for (Landmarks *currentLandmark in allLandmarks) {
        
        for (Asset * currentAsset in currentLandmark.assets) {
            
            count++;
            if ([currentAsset.isDowloaded intValue] == 1) {
             
                NSLog(@"Downloaded");
            }
            else{
                if ([currentAsset.mediaType isEqualToString:@"image"])
                {
                    [self.imagesArray addObject:currentAsset];
                }
                else if ([currentAsset.mediaType isEqualToString:@"text"]){
                    
                }
                else if ([currentAsset.mediaType isEqualToString:@"audio"]){
                    
                    [self.audioArray addObject:currentAsset];
                    
                }
                else if ([currentAsset.mediaType isEqualToString:@"video"]){
                    
                    [self.videosArray addObject:currentAsset];
                }

            }
            
        }
        
    }
    [self calculateSize];
    
}

- (void)viewDidLoad {
    

    
    [super viewDidLoad];
    [self initializeStuff];
}



- (void)calculateSize {
    
    double totalSize = 0.0;
    
    if (self.btnImageSize.selected)
    {
    if ([self.imagesArray count] == 0) {
        [self.btnImageSize setTitle:@"0 Kb"
                           forState:UIControlStateNormal];
        [self.btnImageSize setTitle:@"0 Kb"
                           forState:UIControlStateHighlighted];
        [self.btnImageSize setTitle:@"0 Kb"
                           forState:UIControlStateSelected];}
    else{
        double assetSize = 0.0;
        for (Asset *currentAsset in self.imagesArray) {
            assetSize += [currentAsset.assetSize doubleValue];}
        int kbSize = assetSize/1024.0;
        totalSize = kbSize;
        if (kbSize > 1024) {
            int mbSize = kbSize/1024.0;
            [self.btnImageSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize]
                               forState:UIControlStateNormal];
            [self.btnImageSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize]
                               forState:UIControlStateHighlighted];
            [self.btnImageSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize]
                               forState:UIControlStateSelected];
        }
        else{
            [self.btnImageSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize]
                               forState:UIControlStateNormal];
            [self.btnImageSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize]
                               forState:UIControlStateHighlighted];
            [self.btnImageSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize]
                               forState:UIControlStateSelected];}}
    }
    
    if(self.btnAudioSize.selected){
    if ([self.audioArray count] == 0) {
        [self.btnAudioSize setTitle:@"0 Kb" forState:UIControlStateNormal];
        [self.btnAudioSize setTitle:@"0 Kb" forState:UIControlStateHighlighted];
        [self.btnAudioSize setTitle:@"0 Kb" forState:UIControlStateSelected];}
    else{
        
        double assetSize = 0.0;
        for (Asset *currentAsset in self.audioArray) {
            
            assetSize += [currentAsset.assetSize doubleValue];
            
        }
         int kbSize = assetSize/1024.0;
        totalSize += kbSize;
        if (kbSize > 1024) {
            int mbSize = kbSize/1024.0;
            [self.btnAudioSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateNormal];
            [self.btnAudioSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateHighlighted];
            [self.btnAudioSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateSelected];
        }
        else{
            
            [self.btnAudioSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateNormal];
            [self.btnAudioSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateHighlighted];
            [self.btnAudioSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateSelected];}}
    
    }
    
    if (self.btnVideoSize.selected) {
        

    if ([self.videosArray count] == 0) {
        [self.btnVideoSize setTitle:@"0 Kb" forState:UIControlStateNormal];
        [self.btnVideoSize setTitle:@"0 Kb" forState:UIControlStateHighlighted];
        [self.btnVideoSize setTitle:@"0 Kb" forState:UIControlStateSelected];}
    else{
        
        double assetSize = 0.0;
        for (Asset *currentAsset in self.videosArray) {
            
            assetSize += [currentAsset.assetSize doubleValue];
        }
        int kbSize = assetSize/1024.0; totalSize += kbSize;
        
        if (kbSize > 1024) {
            
            int mbSize = kbSize/1024.0;
            [self.btnVideoSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateNormal];
            [self.btnVideoSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateHighlighted];
            [self.btnVideoSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateSelected];
        }
        else{

            [self.btnVideoSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateNormal];
            [self.btnVideoSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateHighlighted];
            [self.btnVideoSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateSelected];}}
        }
    
    if (self.btnOtherSize.selected) {
        

    if ([self.othersArray count] == 0) {
        [self.btnOtherSize setTitle:@"0 Kb" forState:UIControlStateNormal];
        [self.btnOtherSize setTitle:@"0 Kb" forState:UIControlStateHighlighted];
        [self.btnOtherSize setTitle:@"0 Kb" forState:UIControlStateSelected];}
    else{
        double assetSize = 0.0;
        for (Asset *currentAsset in self.othersArray) {
            assetSize += [currentAsset.assetSize doubleValue];
        }
        int kbSize = assetSize/1024.0;
        totalSize += kbSize;
        if (kbSize > 1024) {
            
            int mbSize = kbSize/1024.0;
            [self.btnOtherSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateNormal];
            [self.btnOtherSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateHighlighted];
            [self.btnOtherSize setTitle:[NSString stringWithFormat:@"%d MB",mbSize] forState:UIControlStateSelected];
        }
        else
        {
            [self.btnOtherSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateNormal];
            [self.btnOtherSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateHighlighted];
            [self.btnOtherSize setTitle:[NSString stringWithFormat:@"%d Kb",kbSize] forState:UIControlStateSelected];}
    }
        }
    
    
    if (totalSize > 1024) {
        int mbSize = totalSize/1024.0;
        
        self.lblTotalSize.text = [NSString stringWithFormat:@"%d MB ",mbSize];
        
    }
    else{
        
        
        self.lblTotalSize.text = [NSString stringWithFormat:@"%d kB",(int)totalSize];
        
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
 
    if ([self.currentCity isEqual:self.sharedDelegate.myCurrentCity]) {
        
    }
    else{
        
        [self.currentCity isEqual:self.sharedDelegate.myCurrentCity];
        [self initializeStuff];
        
    }
    [self calculateSize];
}
- (void)showCitySelectorViewWithCity:(NSString *)city{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
    self.loaderView = [nibObjects objectAtIndex:0];
    [self.loaderView setFrame:CGRectMake(0,
                                         0,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height)];
    
    [self.view addSubview:self.loaderView];
    
    nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DownloadCitieView" owner:self options:nil];
    
    self.downloadCityView = [nibObjects objectAtIndex:0];
    [self.downloadCityView setFrame:CGRectMake(0,
                                               0,
                                               self.view.frame.size.width - 40,
                                               self.downloadCityView.frame.size.height)];
    
    self.downloadCityView.delegate = self;
    
    self.downloadCityView.center = self.loaderView.center;
    
    [self.view addSubview:self.downloadCityView];
    
    
    Countries *currentCountrySelectec=  [Countries getCountryByName:city];
    
    id allCities = [Cities getCitiesOfCountryById:currentCountrySelectec.countryId];
    self.downloadCityView.citiesArray = allCities;
    
    [self.downloadCityView setView];
    
    self.citiesSelected = [NSMutableArray new];
    
    for (id currentItem in allCities) {
        
        
        [self.citiesSelected addObject:currentItem];
        
    }
}

- (IBAction)btnCheckImagesTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
        [self calculateSize];
    
    
}

- (IBAction)btnCheckVideosTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self calculateSize];
}


- (IBAction)btnCheckAudioTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
        [self calculateSize];
}

- (IBAction)btnCheckOtherTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;

        [self calculateSize];
    
}


- (IBAction)btnSyriaTapped:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    
    if (!sender.selected) {
        
        [self removeCountryAssets:self.assetsSyria];
        [self calculateSize];
        
        
        return;
        
    }
    
    self.lastCountryTapped = 3;
    [self showCitySelectorViewWithCity:@"Syria"];

    
}

- (IBAction)btnIraqTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    
    if (!sender.selected) {
                [self removeCountryAssets:self.assetsIraq];
        [self calculateSize];
        
        return;
        
    }

    [self showCitySelectorViewWithCity:@"Iraq"];

        self.lastCountryTapped = 2;
}


-(void)removeCountryAssets:(NSMutableArray *)whichCountryArray{
    for (Asset * object in whichCountryArray) {
        
        NSLog(@"%@",object);
        
        if ([object.mediaType isEqualToString:@"video"]) {
            
            
            [self.videosArray removeObject:object];
            
        }
        else if([object.mediaType isEqualToString:@"audio"]){
            [self.audioArray removeObject:object];
            
        }
        else if([object.mediaType isEqualToString:@"image"]){
            [self.imagesArray removeObject:object];
            
        }
        
    }
}
- (IBAction)btnIranTapped:(UIButton *)button {
    
    button.selected = !button.selected;
    
    
    if (!button.selected) {
    
        
        

        [self removeCountryAssets:self.assetsIran];
        [self calculateSize];
        
        return;
        
    }
    else{
        
    
        
    }
    
    [self showCitySelectorViewWithCity:@"Iran"];
    self.lastCountryTapped = 1;
    

    
}
- (IBAction)btnDownloadButtonTapped:(id)sender {
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"LoaderView" owner:self options:nil];
    self.loaderView = [nibObjects objectAtIndex:0];
    [self.loaderView setFrame:CGRectMake(0,
                                         0,
                                         self.view.frame.size.width,
                                         self.view.frame.size.height)];
    
    [self.view addSubview:self.loaderView];
    
    nibObjects = [[NSBundle mainBundle] loadNibNamed:@"DownloadPercentageView" owner:self options:nil];
    
    
    self.downloadProgressView = [nibObjects objectAtIndex:0];
    [self.downloadProgressView setFrame:CGRectMake(0,
                                               0,
                                               self.view.frame.size.width - 40,
                                               self.downloadProgressView.frame.size.height)];
    

    self.downloadProgressView.center = self.loaderView.center;
    
    [self.view addSubview:self.downloadProgressView];
   
    
    
    [self.downloadProgressView setView];
    self.downloadProgressView.delegate = self;
    
    __block double progress = 0;
    double total = [self.imagesArray count];
    total += [self.audioArray count];
    total += [self.videosArray count];
    total += [self.othersArray count];
    
    if (self.btnImageSize.selected)
    for (Asset *currentAsset in self.imagesArray) {
        


        [FileManager loadAssetImageWithCountry:@"" url:currentAsset.assetUrl withComplitionHandler:^{
        
            progress++;
            
            
            [self.downloadProgressView changeProgress:progress/total ];
            
            if (total == progress) {
                
            }
            
            
        } withFailureHandler:^{
            NSLog(@"Failed to download");
        } assetId:currentAsset.assetId];
        
    }
    
    if (self.btnAudioSize.selected)
    for (Asset *currentAsset in self.audioArray) {
        
        
        [FileManager loadAssetAudioWithCountry:@"" url:currentAsset.assetUrl withComplitionHandler:^{
           
            progress++;

            NSLog(@"%f done of %f",progress,total);
            
            [self.downloadProgressView changeProgress:progress/total ];
            
            if (total == progress) {
                
                NSLog(@"We are done here");
            }
            
        } withFailureHandler:^{
            
            NSLog(@"Failed to download");
        
        } withAssetId:currentAsset.assetId
         ];
        
        
    }
    
    if (self.btnVideoSize.selected)
    for (Asset *currentAsset in self.videosArray) {
        
        [FileManager loadAssetVideoWithCountry:@"" url:currentAsset.assetUrl withComplitionHandler:^{
            
            progress++;
            
                        NSLog(@"%f done of %f",progress,total);
            [self.downloadProgressView changeProgress:progress/total ];
            
            if (total == progress) {
                
                NSLog(@"We are done here");
            }
            
        } withFailureHandler:^{
            
            NSLog(@"Failed to download");
            
        } withAssetId:currentAsset.assetId];
        
    }
    
    
    if (self.btnOtherSize.selected)
    for (Asset *currentAsset in self.othersArray) {
        
        
        [FileManager loadAssetOtherWithCountry:@"" url:currentAsset.assetUrl withComplitionHandler:^{
            
            progress++;
            
            
            NSLog(@"%f done of %f",progress,total);
            [self.downloadProgressView changeProgress:progress/total ];
            
            if (total == progress) {
                
                NSLog(@"We are done here");
            }
            
        } withFailureHandler:^{
            
            NSLog(@"Failed to download");
        }];
    }
    
}


-(void)downloadingDoneButtonTapped{
    
    [self.downloadProgressView removeFromSuperview];
    self.downloadProgressView = nil;
    [self.downloadProgressView removeFromSuperview];
    self.downloadProgressView = nil;

    
    [self.loaderView removeFromSuperview];
    
    
    
    [self.downloadCityView removeFromSuperview];
    self.downloadCityView = nil;
    [self.loaderView removeFromSuperview];
    self.loaderView = nil;
    
    self.imagesArray = nil;
    self.audioArray = nil;
    self.videosArray = nil;
    
    
    [self initializeStuff];
    [self calculateSize];

}

-(void)downloadingCancleButtonTapped{
    
    [self.downloadProgressView removeFromSuperview];
    self.downloadProgressView = nil;
    [self.downloadProgressView removeFromSuperview];
    self.downloadProgressView = nil;
    
    [self.loaderView removeFromSuperview];
    
    
}
-(void)doneButtonTapped{
    
    NSLog(@"");
    
    
    
    
    if (![self.citiesSelected containsObject:self.sharedDelegate.myCurrentCity]) {
        
        [self.citiesSelected addObject:self.sharedDelegate.myCurrentCity];
        
    }
    
    
    
    NSMutableArray *allLandMarks = [NSMutableArray new];
    
    
    for (Cities * currentCity in self.citiesSelected) {
        
        id all = [Landmarks getByCityId:currentCity.cityId];
        
        for (id item in all) {
          [allLandMarks addObject:item];
        }
    }
    
    

    if (self.lastCountryTapped == 1) {
        
        self.assetsIran = nil;
        
    }
    else{
        
        self.lastCountryTapped == 2 ?  [self.assetsIraq removeAllObjects] :  [self.assetsIraq removeAllObjects];
        
    }
    
    for (Landmarks *currentLandmark in allLandMarks) {
        
        for (Asset * currentAsset in currentLandmark.assets) {
            
            if ([currentAsset.mediaType isEqualToString:@"image"])
            {
                [self.imagesArray addObject:currentAsset];
                
                if (self.lastCountryTapped == 1) {
                    
                    [self.assetsIran addObject:currentAsset];
                    
                }
                else{
                    
                    self.lastCountryTapped == 2 ?  [self.assetsIraq addObject:currentAsset] :  [self.assetsSyria addObject:currentAsset];
                    
                }
            }
            else if ([currentAsset.mediaType isEqualToString:@"text"]){
                
                if (self.lastCountryTapped == 1) {
                    
                    [self.assetsIran addObject:currentAsset];
                    
                }
                else{
                    
                    self.lastCountryTapped == 2 ?  [self.assetsIraq addObject:currentAsset] :  [self.assetsSyria addObject:currentAsset];
                    
                }
            }
            else if ([currentAsset.mediaType isEqualToString:@"audio"]){
                
                [self.audioArray addObject:currentAsset];
                
                if (self.lastCountryTapped == 1) {
                    
                    [self.assetsIran addObject:currentAsset];
                    
                }
                else{
                    
                    self.lastCountryTapped == 2 ?  [self.assetsIraq addObject:currentAsset] :  [self.assetsSyria addObject:currentAsset];
                    
                }
            }
            else if ([currentAsset.mediaType isEqualToString:@"video"]){
                
                [self.videosArray addObject:currentAsset];
                
                if (self.lastCountryTapped == 1) {
                    
                    [self.assetsIran addObject:currentAsset];
                    
                }
                else{
                    
                    self.lastCountryTapped == 2 ?  [self.assetsIraq addObject:currentAsset] :  [self.assetsSyria addObject:currentAsset];
                    
                }
            }
            else{
                
                NSLog(@"");
                
            }
        }
        
    }
    
    
    [self calculateSize];
    [self.downloadCityView removeFromSuperview];
    self.downloadCityView = nil;
    [self.loaderView removeFromSuperview];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return [self.downloadCityView.citiesArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    DownloadCityTableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"cellDownloadCity"];
    Cities *currentCharacteristics = [self.downloadCityView.citiesArray objectAtIndex:indexPath.row];
    currentCell.lblCityName.text =currentCharacteristics.name;
    [currentCell.btnCheck setTag:indexPath.row];
    [currentCell.btnCheck  addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    return currentCell;
    
}

-(void)checkButtonTapped:(UIButton *)button{
    
    button.selected = !button.selected;


    if (button.selected) {
        
        [self.citiesSelected removeObject:[self.downloadCityView.citiesArray objectAtIndex:button.tag]];
        
    }
    else{

       // [self.citiesSelected removeObject:[self.citiesSelected objectAtIndex:button.tag]];
        
        
        id toAdd = [self.downloadCityView.citiesArray objectAtIndex:button.tag];
        
        [self.citiesSelected addObject:toAdd];
        
        NSLog(@"Add");
        
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}





-(NSMutableArray *)othersArray{
    
    if (!_othersArray) {
        
        _othersArray = [NSMutableArray new];
    }
    
    return _othersArray;
}

-(NSMutableArray *)audioArray{
    
    if (!_audioArray) {
        
        _audioArray = [NSMutableArray new];
    }
    return _audioArray;
}



-(NSMutableArray *)videosArray{
    
    if (!_videosArray) {
        
        _videosArray = [NSMutableArray new];
    }
    return _videosArray;
}

-(NSMutableArray *)imagesArray{
    
    if (!_imagesArray) {
        
        _imagesArray = [NSMutableArray new];
    }
    return _imagesArray;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu

{
    return NO;
}


@end
