//
//  OnThisDayDetailViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/30/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "OnThisDayDetailViewController.h"
#import "DayDetail.h"

@interface OnThisDayDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblBattleName;
@property (weak, nonatomic) IBOutlet UILabel *lblHijriYear;
@property (weak, nonatomic) IBOutlet UILabel *lblHijriDate;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UITextView *txtDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblHistoryTitle;

@end

@implementation OnThisDayDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  


    
    
    self.lblBattleName.text = self.selectedDay.title;
    

    NSArray *dayDetailArray = [self.selectedDay.display_date componentsSeparatedByString:@"-"];
    self.lblMonth.text = [DayDetail islamicMonthName:[dayDetailArray[0] intValue]];

    self.lblHijriYear.text = [NSString stringWithFormat:@"HIJRI %d",[dayDetailArray[2] intValue]];
    self.lblHijriDate.text = dayDetailArray[1];
    
    
    self.txtDetail.text = self.selectedDay.text;
    
    //self.lblHijriDate =
    
    NSLog(@"%@",self.selectedDay);
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu

{
    return NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
