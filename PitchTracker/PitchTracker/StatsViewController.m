//
//  StatsViewController.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "StatsViewController.h"
#import "PitchStatsFiltered.h"

#define FILTER_NAME_KEY @"name"

//Filter display colurs
#define UNSELECTED_FILTER_COLOUR [UIColor whiteColor]
#define SELECTED_FILTER_COLOUR [UIColor greenColor]

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
@synthesize countBallsFilter = _countBallsFilter;
@synthesize countStrikesFilter = _countStrikesFilter;
@synthesize calculatingIndicator = _calculatingIndicator;
@synthesize teamPicker = _teamPicker;
@synthesize shortNameLabel = _shortNameLabel;

@synthesize filterTable = _filterTable;
@synthesize arrayOriginal =_arrayOriginal;
@synthesize arrayForTable = _arrayForTable;

@synthesize strikesBallsLabel = _strikesBallsLabel;
@synthesize strikeBallPercLabel = _strikeBallPercLabel;
@synthesize walksHitsLabel = _walksHitsLabel;

- (void)viewDidLoad
{
    [ super viewDidLoad ];
    
    [ self loadZoneAndExtrasDisplay ];
    [ self loadInfoDisplay ];
    [ self loadFilterTable ];
    [ self loadOverallDisplay ];
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
    //basically a refresh, better here than didLayoutSubview
    [ self changeTeamFilter:_TeamFilter ];
    [ self changePitcher:_pitcher ];
    
    [ self layoutZoneView ];
    [ self layoutOverallDisplay ];  //must be done after zone view!
    [ self layoutFilterTable ];
}

//-----Pitcher info display-----//
-(void) loadInfoDisplay
{
    
}
//--------------------------------//

//-----Zone view and extras------//
-(void) loadZoneAndExtrasDisplay
{
    _calculatingIndicator = [ [UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    _calculatingIndicator.center = _zoneView.center;    //for now....
    [ self.view addSubview:_calculatingIndicator ];
    
    _zoneView = [ [ZoneView alloc] initWithInfo:true ];
    [ _statsView addSubview:_zoneView ];
    
    [ self loadPicker ];
    
    //default filters
    _StatFilters = DEFAULT_STATS_FILTERS;
    _PitchFilters = ALL_PITCHES_FILTER;
    _countBallsFilter = 0;
    _countStrikesFilter = 0;
}

-(void) layoutZoneView
{
    _zoneView.frame = CGRectMake(_statsView.frame.size.width/2,
                                 0,
                                 _statsView.frame.size.width/2,
                                 _statsView.frame.size.height/1.95);
}
//--------------------------------//

- (IBAction)handleButtonClicked:(id)sender
{
    if( sender == _teamFilterButton )
        [ self togglePickerHidden ];
}

-(void) changeTeamFilter:(TeamNames) team
{
    _TeamFilter = team;
    [ _teamFilterButton setTitle:TEAM_NAME_STR[team] forState:UIControlStateNormal ];
    [ _pitcherScrollView changeTeam:team ];
    [ self changePitcher:nil ];
    [ self loadStatsWithFilter ];
    
    //TODO -- minimize all the rows??? Or update
    [ _filterTable reloadData ];
}

-(void) changePitcher:(Pitcher *) pitcher
{
    _pitcher = pitcher;
    
    //reset pitch filter
    _PitchFilters = ALL_PITCHES_FILTER;
 
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
    
    if( _pitcher != nil )
        [ self loadStatsWithFilter ];
    
    [ self setOverallLabels ];
    
    //reset when pitcher changes
    [ self resetPitchFilterBranch ];
}

//-----Loading stats to view-----//
-(void) loadStatsWithFilter
{
    [_calculatingIndicator startAnimating];
    
    //TODO -- this needs to also take a count
    PitchStatsFiltered *filter = [ [PitchStatsFiltered alloc] initWithInfo:_pitcher.stats with:_StatFilters with:_PitchFilters ];
    
    NSArray *zone_percentages = [filter getZonePercentages];
    [ _zoneView displayPercentages:zone_percentages ];
    
    [_calculatingIndicator stopAnimating];
}
//-------------------------------//

//--Team picker methods--//
//TODO -- move location of the team picker
-(void) loadPicker
{
    _teamPicker = [ UIPickerView new ];
    _teamPicker.delegate = self;
    _teamPicker.dataSource = self;
    _teamPicker.showsSelectionIndicator = YES;
    _teamPicker.hidden = YES;
    
    [ _teamPicker setCenter:_pitcherScrollView.center ];    //TODO --  better place?
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

//---------------FILTER TREE VIEW---------------//
-(void) loadFilterTable
{
    NSDictionary *dTmp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FilterList" ofType:@"plist"]];
    
    _arrayOriginal = [dTmp valueForKey:@"Objects"];
    
    _arrayForTable = [[NSMutableArray alloc] init];
    [ _arrayForTable addObjectsFromArray:_arrayOriginal ];
    _filterTable = [ [UITableView alloc] init ];
    _filterTable.delegate = self;
    _filterTable.dataSource = self;
    _filterTable.backgroundColor = [UIColor blackColor];
    _filterTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ _statsView addSubview:_filterTable ];
}

-(void) layoutFilterTable
{
    _filterTable.frame = CGRectMake(0, 0, _zoneView.frame.size.width, _statsView.frame.size.height);
}

//----------TABLE TREE VIEW DELEGATES----------//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* custom_view = [ [UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, FILTER_HEADER_TEXT_SIZE + 5) ];
    
    // create the button object
    UILabel * header_label = [[UILabel alloc] initWithFrame:CGRectZero];
    header_label.backgroundColor = [UIColor clearColor];
    header_label.textColor = UNSELECTED_FILTER_COLOUR;
    header_label.font = [UIFont boldSystemFontOfSize:FILTER_HEADER_TEXT_SIZE];
    header_label.frame = custom_view.frame;
    header_label.textAlignment = NSTextAlignmentCenter;
    
    header_label.text = @"Statistics Filters";
    [custom_view addSubview:header_label];
    
    return custom_view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FILTER_HEADER_TEXT_SIZE + 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrayForTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    
    bool expanded = [ cell.textLabel.text containsString:@"-" ];
    NSString *value_str = [ [_arrayForTable objectAtIndex:indexPath.row] valueForKey:@"name" ];
    if(expanded)
        value_str = [value_str stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        
    
    cell.textLabel.text = value_str;
    [cell setIndentationLevel:[ [[_arrayForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue] ];
    cell.backgroundColor = [ UIColor clearColor ];
    cell.textLabel.font = [ cell.textLabel.font fontWithSize:25 ];
    
    StatTypes type_filter = getFilterTypeFromCellString(value_str);
    
    [ self setTextColourOnFilterClicked:cell with:(_StatFilters & type_filter) ];
    [ self checkHandleSpecialCaseCellType:cell with:type_filter with:value_str ];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *d=[_arrayForTable objectAtIndex:indexPath.row];
    NSMutableString *key_str = [d objectForKey:FILTER_NAME_KEY];
    NSArray *ar= [ d valueForKey:NODE_OBJECTS_KEY_IN_TREE ];
    
    if( ar != nil )  //expanding rows (internal nodes)
    {
        if( [self isInternalNodeAlreadyExpanded:ar] )
        {
            [self miniMizeThisRows:ar];
            key_str = (NSMutableString *)[ key_str stringByReplacingOccurrencesOfString:@"-" withString:@"+" ];
        }
        else
        {
            [ self expandInternalNode:tableView with:indexPath with:ar with:key_str ];
            key_str = (NSMutableString *)[ key_str stringByReplacingOccurrencesOfString:@"+" withString:@"-" ];
        }
        
        //+ or - based on expanding or minimizing (this if statement is only for internal nodes, not leaves)
        UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
        cell.textLabel.text = key_str;
    }
    else    //clicking on actual filter (leaf nodes)
    {
        //mask in filter, set background
        NSMutableString *value_str = [ d objectForKey:FILTER_NAME_KEY ];
        UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
        
        [ self handleLeafNodeClicked:cell with:value_str ];
    }
}
//----------------------------------------//




//----------TABLE VIEW DELEGATE HELPERS (local)----------//
-(void) checkHandleSpecialCaseCellType:(UITableViewCell *)cell with:(StatTypes) type_filter with:(NSString *)value_str
{
    PitchTypes pitch_filter = getPitchTypeFromString(value_str);
    
    if( cellIsApplyFiltersButton(value_str) )
    {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = NICE_BUTTON_COLOUR;
    }
    else if( type_filter == Count )  //Count leaf that shows YES or NO for filtering by count
    {
        if( _StatFilters & Count )
        {
            cell.textLabel.text = [value_str stringByReplacingOccurrencesOfString:OFF_SUBSTRING withString:ON_SUBSTRING];
            cell.textLabel.textColor = SELECTED_FILTER_COLOUR;
        }
        else
        {
            cell.textLabel.text = [value_str stringByReplacingOccurrencesOfString:ON_SUBSTRING withString:OFF_SUBSTRING];
            cell.textLabel.textColor = UNSELECTED_FILTER_COLOUR;
        }
    }
    else if( [value_str containsString:BALLS_COUNT_SUBSTRING] ) //click on BALLS leaf, increases ball count
    {
        if( _StatFilters & Count )  //only increase if filtering by count is enabled
        {
            NSMutableString *label = [value_str mutableCopy];
            NSString *number = [NSString stringWithFormat:@"%d", _countBallsFilter];
            [ label replaceCharactersInRange:NSMakeRange(value_str.length - 1, 1) withString:number ];
            cell.textLabel.text = label;
        }
    }
    else if( [value_str containsString:STRIKES_COUNT_SUBSTRING] )   //click on STRIKES leaf, increas strike count
    {
        if( _StatFilters & Count )  //only increase if filtering by count is enabled
        {
            NSMutableString *label = [value_str mutableCopy];
            NSString *number = [NSString stringWithFormat:@"%d", _countStrikesFilter];
            [ label replaceCharactersInRange:NSMakeRange(value_str.length - 1, 1) withString:number ];
            cell.textLabel.text = label;
        }
    }
    else if( pitch_filter )     //if this cell is a pitch
    {
        //if pitch is in current set of filters AND the pitcher has the pitch, highlight it
        if( (_PitchFilters & pitch_filter) && (_pitcher.info.pitches & pitch_filter) )
            cell.textLabel.textColor = SELECTED_FILTER_COLOUR;
        else
            cell.textLabel.textColor = UNSELECTED_FILTER_COLOUR;
    }
}

-(BOOL) isInternalNodeAlreadyExpanded:(NSArray *)ar
{
    NSInteger index = 0;
    for(NSDictionary *dInner in ar )
    {
        index = [_arrayForTable indexOfObjectIdenticalTo:dInner];
        
        if(index > 0 && index != NSIntegerMax)
            return YES;
    }
    
    return NO;
}

-(void)miniMizeThisRows:(NSArray*)ar
{
    NSUInteger index_to_remove;
    NSArray *array_inner = nil;
    for(NSDictionary *dict_inner in ar )
    {
        index_to_remove = [ _arrayForTable indexOfObjectIdenticalTo:dict_inner ];
        array_inner = [ dict_inner valueForKey:NODE_OBJECTS_KEY_IN_TREE ];
        
        if( array_inner && [array_inner count] > 0 )
            [ self miniMizeThisRows:array_inner ];
        
        if([self.arrayForTable indexOfObjectIdenticalTo:dict_inner]!=NSNotFound)
        {
            [_arrayForTable removeObjectIdenticalTo:dict_inner];
            [_filterTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index_to_remove inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

-(void) expandInternalNode:(UITableView *)tableView with:(NSIndexPath *)indexPath with:(NSArray *) ar with:(NSString *) key_str
{
    NSUInteger count = indexPath.row+1;
    NSMutableArray *arCells=[NSMutableArray array];
    bool pitch_type_filter = [self headerClickedIsPitchType:key_str];
    
    if( !pitch_type_filter )    //if this is not the pitch type header
    {
        for(NSDictionary *dInner in ar )
        {
            [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
            [_arrayForTable insertObject:dInner atIndex:count++];
        }
    }
    else
    {
        PitchTypes pitch_mask = 0;
        
        //Array will hold all possible pitches, only add rows for pitches pitcher has
        for( NSDictionary *dInner in ar )
        {
            pitch_mask = getPitchTypeFromString( [dInner objectForKey:FILTER_NAME_KEY] );
            if( _pitcher.info.pitches & pitch_mask )    //pitcher has pitch
            {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [_arrayForTable insertObject:dInner atIndex:count++];
            }
            else    //does not have pitch, mask it out current PitchFilters
            {
                _PitchFilters = _PitchFilters & ~pitch_mask;
            }
        }
    }
    
    [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
}

-(void) handleLeafNodeClicked:(UITableViewCell *)cell with:(NSString *) value_str
{
    if( cellIsApplyFiltersButton(value_str) )
    {
        [ self loadStatsWithFilter ];
    }
    else if( getFilterTypeFromCellString(value_str) == Count )   //click on toggle of filter by count (ON/OFF)
    {
        [ self toggleCountFilterClicked:cell with:value_str ];
    }
    else if( [value_str containsString:BALLS_COUNT_SUBSTRING] ) //click on BALLS
    {
        if( _StatFilters & Count )  //only if filtering by count is enabled
        {
            _countBallsFilter = (_countBallsFilter + 1) % 4;
            [ self checkHandleSpecialCaseCellType:cell with:0 with:value_str ];
        }
    }
    else if( [value_str containsString:STRIKES_COUNT_SUBSTRING] ) //click on STRIKES
    {
        if( _StatFilters & Count )  //only if filtering by count is enabled
        {
            _countStrikesFilter = (_countStrikesFilter + 1) % 3;
            [ self checkHandleSpecialCaseCellType:cell with:0 with:value_str ];
        }
    }
    else if( !getPitchTypeFromString(value_str) )    //not a pitch filter
    {
        StatTypes new_filter = getFilterTypeFromCellString(value_str);
        _StatFilters = _StatFilters ^ new_filter;
        
        bool new_filter_enabled = (_StatFilters & new_filter);
        [ self setTextColourOnFilterClicked:cell with:new_filter_enabled ];
    }
    else    //must be one of the pitches
    {
        PitchTypes new_filter = getPitchTypeFromString(value_str);
        _PitchFilters = _PitchFilters ^ new_filter;
        
        bool new_filter_enabled = (_PitchFilters & new_filter);
        [ self setTextColourOnFilterClicked:cell with:new_filter_enabled ];
    }
}

-(void) toggleCountFilterClicked:(UITableViewCell *) cell with:(NSString *)value_str
{
    if( _StatFilters & Count )
    {
        cell.textLabel.text = [value_str stringByReplacingOccurrencesOfString:@"ON" withString:@"OFF"];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.textLabel.text = [value_str stringByReplacingOccurrencesOfString:@"OFF" withString:@"ON"];
        cell.textLabel.textColor = [UIColor greenColor];
    }
    
    _StatFilters = _StatFilters ^ Count;    //flips bit of count (toggle ON/OFF)
}

-(void) setTextColourOnFilterClicked:(UITableViewCell *) cell with: (bool) selected
{
    if(selected)
        cell.textLabel.textColor = SELECTED_FILTER_COLOUR;
    else
        cell.textLabel.textColor = UNSELECTED_FILTER_COLOUR;
}

-(bool) headerClickedIsPitchType:(NSString *)str
{
    NSString *cmp_str = [ str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    return ( [cmp_str caseInsensitiveCompare:PITCH_TYPE_FILTER_STR] == NSOrderedSame );
}

-(void) resetPitchFilterBranch
{
    NSDictionary *d=[_arrayForTable objectAtIndex:5];
    NSArray *ar= [ d valueForKey:NODE_OBJECTS_KEY_IN_TREE ];
    
    //only minimize if already expanded
    if( [self isInternalNodeAlreadyExpanded:ar] )
        [self miniMizeThisRows:ar];
    
    [ _filterTable reloadData ];
}
//-----------------------------------------------------------------//

//---------------Overall Display Labels---------------//
//TODO -- add more stuff here?
-(void) loadOverallDisplay
{
    _shortNameLabel = [ [UILabel alloc] init ];
    _shortNameLabel.textColor = [UIColor whiteColor];
    _shortNameLabel.text = @"Name";
    _shortNameLabel.textAlignment = NSTextAlignmentCenter;
    [ _statsView addSubview:_shortNameLabel ];
    
    _strikesBallsLabel = [ [UILabel alloc] init ];
    _strikeBallPercLabel = [ [UILabel alloc] init ];
    _walksHitsLabel = [ [UILabel alloc] init ];
    _walksHitsLabel.textColor = _strikeBallPercLabel.textColor = _strikesBallsLabel.textColor = UNSELECTED_FILTER_COLOUR;
    _walksHitsLabel.font = _strikesBallsLabel.font = _strikeBallPercLabel.font = _shortNameLabel.font = [ _walksHitsLabel.font fontWithSize:INFO_LABEL_TEXT_SIZE ];
    
    [ self setOverallLabels ];
    [ _statsView addSubview:_strikesBallsLabel ];
    [ _statsView addSubview:_strikeBallPercLabel ];
    [ _statsView addSubview:_walksHitsLabel ];
}

-(void) setOverallLabels
{
    if(_pitcher != nil)
    {
        _strikesBallsLabel.text = [NSString stringWithFormat:@"Strikes: %d\t Balls: %d\t Ratio: %.2f", _pitcher.stats.total_strikes, _pitcher.stats.total_balls, (float)_pitcher.stats.total_strikes/(float)_pitcher.stats.total_balls];
        _strikeBallPercLabel.text = [NSString stringWithFormat:@"Strike%%: %.2f  \t  Ball%%: %.2f", _pitcher.stats.getStrikePercentage, _pitcher.stats.getBallPercentage];
        _walksHitsLabel.text = [NSString stringWithFormat:@"K: %d\tWalks: %d\tK/W Ratio: %.2f", _pitcher.stats.total_k, _pitcher.stats.total_walks, (float)_pitcher.stats.total_k/(float)_pitcher.stats.total_balls];
    }
    else
    {
        _strikesBallsLabel.text = @"";
        _strikeBallPercLabel.text = @"No Pitchers";
        _walksHitsLabel.text = @"";
    }
}

-(void) layoutOverallDisplay
{
    float h = DISPLAY_LABEL_HEIGHT;
    CGRect big_frame = _statsView.frame;
    float delta = ( _statsView.frame.size.height/2 - (LABEL_COUNT_OVERALL + 1)*h) / (LABEL_COUNT_OVERALL + 1);
    
    CGRect f = CGRectMake(big_frame.size.width/2, _zoneView.frame.size.height + delta, _zoneView.frame.size.width, h);
    _shortNameLabel.frame = f;
    
    f.origin.y += delta + h;
    _strikesBallsLabel.frame = f;
    
    f.origin.y += h + delta;
    _strikeBallPercLabel.frame = f;
    
    f.origin.y += h + delta;
    _walksHitsLabel.frame = f;
}
//----------------------------------------------------//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
