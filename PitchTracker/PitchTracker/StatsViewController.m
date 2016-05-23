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

@synthesize zoneView = _zoneView;

@synthesize pitcher = _pitcher;
@synthesize TeamFilter = _TeamFilter;
@synthesize StatFilters = _StatFilters;
@synthesize calculatingIndicator = _calculatingIndicator;
@synthesize teamPicker = _teamPicker;

@synthesize shortNameLabel = _shortNameLabel;

@synthesize filtersHeaderLabel = _filtersHeaderLabel;
@synthesize resetDefaultFiltersButton = _resetDefaultFiltersButton;
@synthesize inZoneFilter = _inZoneFilter;
@synthesize outZoneFilter = _outZoneFilter;
@synthesize swingMissFilter = _swingMissFilter;
@synthesize swingHitFilter = _swingHitFilter;
@synthesize takeFilter = _takeFilter;
@synthesize pitchFilter = _pitchFilter;
@synthesize pitchLabel = _pitchLabel;
@synthesize followUpFilter = _followUpFilter;
@synthesize followUpPitch = _followUpPitch;

- (void)viewDidLoad
{
    [ super viewDidLoad ];
    
    [ self loadZoneAndExtrasDisplay ];
    [ self loadInfoDisplay ];
    [ self loadFilterDisplay ];
    [ self highlightCurrentResultFilters ]; //must be after loadFilterDisplay
}

-(void) viewDidLayoutSubviews
{
    [ super viewDidLayoutSubviews ];
    
    //basically a refresh
    [ self changeTeamFilter:_TeamFilter ];
    [ self changePitcher:_pitcher ];
    
    [ self layoutZoneView ];
    [ self layoutFilterDisplay ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
}

//-----Pitcher info display-----//
-(void) loadInfoDisplay
{
    _shortNameLabel = [ [UILabel alloc] init ];
    
    _shortNameLabel.textColor = [UIColor whiteColor];
    _shortNameLabel.font = [_shortNameLabel.font fontWithSize:INFO_LABEL_TEXT_SIZE];
    
    _shortNameLabel.text = @"Name";
    _shortNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [ _statsView addSubview:_shortNameLabel ];
}
//--------------------------------//

//-----Zone view and extras------//
-(void) loadZoneAndExtrasDisplay
{
    _calculatingIndicator = [ [UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    _calculatingIndicator.center = self.view.center;    //for now....
    [ self.view addSubview:_calculatingIndicator ];
    
    _zoneView = [ [ZoneView alloc] initWithInfo:true ];
    [ _statsView addSubview:_zoneView ];
    
    [ self loadPicker ];
    
    //default filter for stats??
    _StatFilters = OutZone | SwingMiss | Take;
}

-(void) layoutZoneView
{
    _zoneView.frame = CGRectMake(_statsView.frame.size.width/2,
                                 0,
                                 _statsView.frame.size.width/2,
                                 _statsView.frame.size.height/1.95);
}
//--------------------------------//

//-----Filter display-----//
-(void) loadFilterDisplay
{
    _filtersHeaderLabel = [ [UILabel alloc] init ];
    _filtersHeaderLabel.text = @"Result Filters";
    UIFont *f = _filtersHeaderLabel.font;
    _filtersHeaderLabel.font = [ f fontWithSize:30 ];
    _filtersHeaderLabel.textColor = [UIColor whiteColor];
    _filtersHeaderLabel.textAlignment = NSTextAlignmentCenter;
    
    _resetDefaultFiltersButton = [ [UIButton alloc] init ];
    [ _resetDefaultFiltersButton setTitle:@"Reset Default Result Filters" forState:UIControlStateNormal ];
    [ _resetDefaultFiltersButton setTitleColor:NICE_BUTTON_COLOUR forState:UIControlStateNormal ];
    f = _resetDefaultFiltersButton.titleLabel.font;
    _resetDefaultFiltersButton.titleLabel.font = [ f fontWithSize:30 ];
    [ _resetDefaultFiltersButton addTarget:self action:@selector(handleResetResultFiltersClicked) forControlEvents:UIControlEventTouchUpInside ];
    
    _inZoneFilter = [ [SelectableLabel alloc] initWithStr:@"In Zone" ];
    _outZoneFilter = [ [SelectableLabel alloc] initWithStr:@"Out Zone" ];
    _swingMissFilter = [ [SelectableLabel alloc] initWithStr:@"Miss" ];
    _swingHitFilter = [ [SelectableLabel alloc] initWithStr:@"Hit" ];
    _takeFilter = [ [SelectableLabel alloc] initWithStr:@"Take" ];
    _pitchFilter = [ [SelectableLabel alloc] initWithStr:@"Pitch Type" ];
    _pitchLabel = [ [UILabel alloc] init ];
    _followUpFilter = [ [SelectableLabel alloc] initWithStr:@"Follow Up Pitch" ];
    _followUpPitch = [ [UILabel alloc] init ];
    
    [ _statsView addSubview:_filtersHeaderLabel ];
    [ _statsView addSubview:_resetDefaultFiltersButton ];
    [ _statsView addSubview:_inZoneFilter ];
    [ _statsView addSubview:_outZoneFilter ];
    [ _statsView addSubview:_swingMissFilter ];
    [ _statsView addSubview:_swingHitFilter ];
    [ _statsView addSubview:_takeFilter ];
    [ _statsView addSubview:_pitchFilter ];
    //[ _statsView addSubview:_pitchLabel ];
    [ _statsView addSubview:_followUpFilter ];
    //[ _statsView addSubview:_followUpPitch ];
}

-(void) layoutFilterDisplay
{
    float h = INFO_LABEL_TEXT_SIZE + 5;
    float delta = ((_statsView.frame.size.height/2) - (NUMBER_DISPLAY_ROWS*h))/(NUMBER_DISPLAY_ROWS + 1);
    
    //row 0
    CGRect f1 = CGRectMake( INFO_LABEL_INSET, delta, _statsView.frame.size.width/2 - INFO_LABEL_INSET, h );
    _shortNameLabel.frame = f1;
    
    //row 1
    f1.origin.y += h + delta;
    _filtersHeaderLabel.frame = f1;
    
    //row 2
    f1.origin.y += h + delta;
    _resetDefaultFiltersButton.frame = f1;
    
    //row 3
    f1.origin.y += h + delta;
    CGRect f2 = f1;
    f2.size.width /= 2;
    _inZoneFilter.frame = f2;
    
    f2.origin.x += f2.size.width;
    _outZoneFilter.frame = f2;
    
    //row 4
    f1.origin.y += h + delta;
    f2 = f1;
    f2.size.width /= 3;
    _swingHitFilter.frame = f2;
    
    f2.origin.x += f2.size.width;
    _swingMissFilter.frame = f2;
    
    f2.origin.x += f2.size.width;
    _takeFilter.frame = f2;
    
    //row 5
    f1.origin.y += h + delta;
}

-(void) handleResetResultFiltersClicked
{
    _StatFilters = InZone | OutZone | SwingMiss | SwingHit | Take;
    [ self highlightCurrentResultFilters ];
}
//------------------------//

- (IBAction)handleButtonClicked:(id)sender
{
    if( sender == _teamFilterButton )
        [ self togglePickerHidden ];
}

-(void) changeTeamFilter:(TeamNames) team
{
    _TeamFilter = team;
    [ _teamFilterButton setTitle:TEAM_NAME_STR[team] forState:UIControlStateNormal ];
    [_pitcherScrollView changeTeam:team];
}

-(void) changePitcher:(Pitcher *) pitcher
{
    _pitcher = pitcher;
 
    if( _pitcher != nil )
    {
        _shortNameLabel.text = _pitcher.info.getShortDisplayString;
    }
    else
    {
        LocalPitcherDatabase *db = [ LocalPitcherDatabase sharedDatabase ];
        NSArray *pitchers = [ db getTeamArray:_TeamFilter ];
        
        if( pitchers.count > 0 )
        {
            _pitcher = [ pitchers objectAtIndex:0 ];
            _shortNameLabel.text = _pitcher.info.getShortDisplayString;
        }
        else
        {
            _shortNameLabel.text = @"No Pitcher";
        }
    }
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

//-----locals-----//
-(void) highlightCurrentResultFilters
{
    [ _inZoneFilter setSelect:(_StatFilters & InZone) ];
    [ _outZoneFilter setSelect:(_StatFilters & OutZone) ];
    [ _swingHitFilter setSelect:(_StatFilters & SwingHit) ];
    [ _swingMissFilter setSelect:(_StatFilters & SwingMiss) ];
    [ _takeFilter setSelect:(_StatFilters & Take) ];
}
//----------------//


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
