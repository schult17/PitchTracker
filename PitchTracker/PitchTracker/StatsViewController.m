//
//  StatsViewController.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "StatsViewController.h"

@interface StatsViewController ()

@end

@implementation StatsViewController

@synthesize pitcherScrollView = _pitcherScrollView;
@synthesize teamFilterButton = _teamFilterButton;
@synthesize statsView = _statsView;

@synthesize pitcher = _pitcher;
@synthesize TeamFilter = _TeamFilter;
@synthesize StatFilters = _StatFilters;
@synthesize calculatingIndicator = _calculatingIndicator;
@synthesize teamPicker = _teamPicker;

- (void)viewDidLoad
{
    [ super viewDidLoad ];
    
    [ self loadStatsDisplay ];
}

-(void) viewDidLayoutSubviews
{
    [ super viewDidLayoutSubviews ];
    
    //basically a refresh
    [ self changeTeamFilter:_TeamFilter ];
    [ self changePitcher:_pitcher ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
}

-(void) loadStatsDisplay
{
    _calculatingIndicator = [ [UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    _calculatingIndicator.center = self.view.center;    //for now....
    [ self.view addSubview:_calculatingIndicator ];
    
    [ self loadPicker ];
    
    //default filter for stats
    _StatFilters = InZone | OutZone | SwingMiss | SwingHit | Take;
}

- (IBAction)handleButtonClicked:(id)sender
{
    if( sender == _teamFilterButton )
        [ self togglePickerHidden ];
}

-(void) changeTeamFilter:(TeamNames) team
{
    _TeamFilter = team;
    [ _teamFilterButton setTitle:TEAM_NAME_STR[team] forState:UIControlStateNormal ];
}

-(void) changePitcher:(Pitcher *) pitcher
{
    _pitcher = pitcher;
}

//--Team picker methods--//
-(void) loadPicker
{
    _teamPicker = [ UIPickerView new ];
    _teamPicker.delegate = self;
    _teamPicker.dataSource = self;
    _teamPicker.showsSelectionIndicator = YES;
    _teamPicker.hidden = YES;
    
    [ _teamPicker setCenter:self.view.center ];
    [ self.view addSubview:_teamPicker ];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name;
    
    name = TEAM_NAME_STR[ row ];
    
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return TEAMCOUNT;
}

-(void) togglePickerHidden
{
    _teamPicker.hidden = !_teamPicker.hidden;
    
    //if we are about to show picker, set row to current filter
    if( !_teamPicker.hidden )
        [ _teamPicker selectRow:(int)_TeamFilter inComponent:0 animated:NO ];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //New filter chosen
    [ self changeTeamFilter:(TeamNames)row ];
    _teamPicker.hidden = YES;
    
}
//-----------------------//


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
