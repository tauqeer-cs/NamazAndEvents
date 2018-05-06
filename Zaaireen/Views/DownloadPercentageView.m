//
//  DownloadPercentageView.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "DownloadPercentageView.h"

@implementation DownloadPercentageView



-(void)setView{
    
    self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:self.imageIcon.bounds];
    [self.imageIcon addSubview:self.progressOverlayView];
     [self.progressOverlayView displayOperationWillTriggerAnimation];
    
}

-(void)changeProgress:(double)percentage{
    
    self.progressOverlayView.progress = percentage;
 
    if (percentage == 1.0) {
        
        [self.btnDone setTitle:@"Done" forState:UIControlStateNormal];
        [self.btnDone setTitle:@"Done" forState:UIControlStateHighlighted];
    }
    self.lblPercentage.text = [NSString stringWithFormat:@"Completed %.01f %%",percentage*100];
    
}

- (IBAction)btnDoneOrCancelTapped:(UIButton *)sender {
    
    
    if ([sender.titleLabel.text isEqualToString:@"Done"]) {
        
        [self.delegate downloadingDoneButtonTapped];
        
    }
    else{
        
        [self.delegate downloadingCancleButtonTapped];
        
    }
}
@end
