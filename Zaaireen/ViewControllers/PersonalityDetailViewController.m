//
//  PersonalityDetailViewController.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 10/29/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "PersonalityDetailViewController.h"
#import "PersonalityCharacteristics.h"
#import "Personality.h"
#import "Landmarks.h"
#import "NSString+HTML.h"
#import "PersonalityPropertyTableViewCell.h"
#import "PersonalityDetailTableViewCell.h"

@interface PersonalityDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblPersonalityName;
@property (weak, nonatomic) IBOutlet UILabel *lblPlace;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) NSArray *characteristicArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation PersonalityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    if ([self.userDefaults objectForKey:@"PersonalityCharacteristicsDownloaded"]) {
        
        
    }
    
    self.lblPersonalityName.text = [self.selectedPersonality.title stringByDecodingHTMLEntities];
    
    if (self.selectedLandmark) {
    self.lblPlace.text = [NSString stringWithFormat:@"%@, %@",self.selectedLandmark.cityDetail.name,self.selectedLandmark.cityDetail.cityCountry.name];
    }
    else{
        [self.lblPlace setHidden:YES];
        
    }


    self.characteristicArray = [self.selectedPersonality.characteristic allObjects];
    
    NSArray *sortDescriptors = @[
                                 [NSSortDescriptor sortDescriptorWithKey:@"orderBy" ascending:YES]
                                 ];
    
    
    NSArray *sortedPeople = [self.characteristicArray sortedArrayUsingDescriptors:sortDescriptors];
    self.characteristicArray = sortedPeople;
    
    
    if ([self.characteristicArray count] == 0) {

            
            UIView *tmpView = [UIView new];
            [tmpView setFrame:CGRectMake(0, (self.view.frame.size.height - (self.tableView.frame.size.height/2))-30,
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
            [lblMessage setText:@"Personalities Characteristics will be available soon."];
            [lblMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
            lblMessage.textColor = [UIColor darkGrayColor];
            
            [tmpView addSubview:lblMessage];
            
            self.viewSorryMessage = tmpView;
        
        
    }
    
    if ([self.characteristicArray count] > 0) {
        
        for (PersonalityCharacteristics *currentCharacter in self.characteristicArray) {
            
            NSLog(@"Order %@ name = %@ value = %@",currentCharacter.orderBy,currentCharacter.name,currentCharacter.value);
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalityPropertyTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellPersonalityProperty"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalityDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellPersonalityPropertyDetail"];
    
    self.tableView.estimatedRowHeight = 34;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.characteristicArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    PersonalityPropertyTableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"cellPersonalityProperty"];
    PersonalityCharacteristics *currentCharacteristics = [self.characteristicArray objectAtIndex:indexPath.row];
    
    
    if([currentCharacteristics.orderBy integerValue] >= 20){
        
        currentCell = [tableView dequeueReusableCellWithIdentifier:@"cellPersonalityPropertyDetail"];
        currentCell.lblPropertyName.text = [currentCharacteristics.name capitalizedString];
        currentCell.lblValue.text = [[currentCharacteristics.value stringByConvertingHTMLToPlainText] stringByDecodingHTMLEntities];
        
    }
    else{
        currentCell.lblPropertyName.text = [currentCharacteristics.name capitalizedString];
        currentCell.lblValue.text = [[currentCharacteristics.value stringByConvertingHTMLToPlainText] stringByDecodingHTMLEntities];
    }
    return currentCell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    

}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}


@end
