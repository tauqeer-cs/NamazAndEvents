//
//  DownloadCitieView.m
//  Zaaireen
//
//  Created by Tauqeer Ahmed on 11/4/15.
//  Copyright © 2015 Tauqeer Ahmed. All rights reserved.
//

#import "DownloadCitieView.h"
#import "DownloadCityTableViewCell.h"
#import "Cities.h"

@interface DownloadCitieView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DownloadCitieView


-(void)setView{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DownloadCityTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellDownloadCity"];
    
    
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return [self.citiesArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    DownloadCityTableViewCell *currentCell = [tableView dequeueReusableCellWithIdentifier:@"cellDownloadCity"];
    Cities *currentCharacteristics = [self.citiesArray objectAtIndex:indexPath.row];
    currentCell.lblCityName.text =currentCharacteristics.name;
    
    return currentCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (IBAction)btnDoneButtonTapped {
    
    [self.delegate doneButtonTapped];
    
}


@end
