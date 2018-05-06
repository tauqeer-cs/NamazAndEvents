//
//  PoolDetailViewController.m
//  ZaaireenGuide
//
//  Created by Tauqeer Ahmed on 12/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "PoolDetailViewController.h"
#import "TripDetailTableViewCell.h"
#import "Landmarks.h"
#import "TripFeatureTableViewCell.h"

@interface PoolDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *rowsArray;
@property (nonatomic,strong) Landmarks *currentLandmark;

@end

@implementation PoolDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentLandmark =self.itemSelected;
    
        self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSLog(@"%@",self.itemSelected);
    self.rowsArray = [NSMutableArray new];
    
    [self.rowsArray addObject:@"Summary"];
    if (_currentLandmark.isBedAvailable) {
        
        [self.rowsArray addObject:@"Bed"];
    }
    
    if (_currentLandmark.isCheckPostAvailable) {
        
        [self.rowsArray addObject:@"CheckPost"];
    }
    
    if (_currentLandmark.isFoodAvailable) {
        
        [self.rowsArray addObject:@"Food"];
    }
    
    if (_currentLandmark.isMedicalAvailable) {
        
        [self.rowsArray addObject:@"Medical"];
    }
    
    if (_currentLandmark.isWashroomAvailable) {
        
        [self.rowsArray addObject:@"Washroom"];
    }
    
    if (_currentLandmark.isWaterAvailable) {
        
        [self.rowsArray addObject:@"Water"];
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TripDetailViewCell" bundle:nil] forCellReuseIdentifier:@"cellTripSummary"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TripFeatureTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellCityFeatures"];
    
    
    self.tableView.estimatedRowHeight = 34;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
    
    
    Landmarks *check = self.itemSelected;
    
    NSLog(@"%@",check);
    
    if ([[check.assets allObjects] count] >0) {
        
        NSLog(@"YES");
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.rowsArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([[self.rowsArray objectAtIndex:indexPath.row] isEqualToString:@"Water"]
        || [[self.rowsArray objectAtIndex:indexPath.row] isEqualToString:@"Washroom"]
        || [[self.rowsArray objectAtIndex:indexPath.row] isEqualToString:@"Medical"]
        ||  [[self.rowsArray objectAtIndex:indexPath.row] isEqualToString:@"Food"]
        ||  [[self.rowsArray objectAtIndex:indexPath.row] isEqualToString:@"CheckPost"]
        ||  [[self.rowsArray objectAtIndex:indexPath.row] isEqualToString:@"Bed"])
    {
            TripFeatureTableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"cellCityFeatures"];
        //
        
        [currentCell populateCellFromItem:[self.rowsArray objectAtIndex:indexPath.row]];
        
        return currentCell;
        
    }
    
    TripDetailTableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"cellTripSummary"];
    
    [currentCell populateWithLandmark:self.itemSelected];
    
    
    return currentCell;
    
}



- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return NO;
}

@end
