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
@synthesize calculatingIndicator = _calculatingIndicator;
@synthesize teamPicker = _teamPicker;
@synthesize shortNameLabel = _shortNameLabel;

@synthesize filterTable = _filterTable;
@synthesize arrayOriginal =_arrayOriginal;
@synthesize arrayForTable = _arrayForTable;

- (void)viewDidLoad
{
    [ super viewDidLoad ];
    
    [ self loadZoneAndExtrasDisplay ];
    [ self loadInfoDisplay ];
    [ self loadFilterTable ];
}

-(void) viewDidLayoutSubviews
{
    [ super viewDidLayoutSubviews ];
    
    //basically a refresh
    [ self changeTeamFilter:_TeamFilter ];
    [ self changePitcher:_pitcher ];
    
    [ self layoutZoneView ];
    [ self layoutFilterTable ];
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
    _StatFilters = OutZone | Ball | Strike | SwingMiss | Take;
    _PitchFilters = 0;  //All off by default
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
    
    if( _pitcher != nil )
        [self loadStatsWithFilter];
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

//-----Loading stats to view-----//
-(void) loadStatsWithFilter
{
    [_calculatingIndicator startAnimating];
    
    PitchStatsFiltered *filter = [ [PitchStatsFiltered alloc] initWithInfo:_pitcher.stats with:_StatFilters with:ALL_PITCHES_FILTER ];
    
    NSArray *zone_percentages = [filter getZonePercentages];
    [ _zoneView displayPercentages:zone_percentages ];
    
    [_calculatingIndicator stopAnimating];
}
//-------------------------------//

//-----FILTER TREE VIEW-----//
-(void) loadFilterTable
{
    NSDictionary *dTmp = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FilterList" ofType:@"plist"]];
    
    self.arrayOriginal = [dTmp valueForKey:@"Objects"];
    
    self.arrayForTable = [[NSMutableArray alloc] init];
    [self.arrayForTable addObjectsFromArray:self.arrayOriginal];
    self.filterTable = [ [UITableView alloc] init ];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//TODO -- format the header better
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Statistics Filters";
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
    
    cell.textLabel.text=[[_arrayForTable objectAtIndex:indexPath.row] valueForKey:@"name"];
    [cell setIndentationLevel:[[[_arrayForTable objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [cell.textLabel.font fontWithSize:25];
    
    //Dummy call to set these filters coloured if they are default
    StatTypes type_filter = getFilterTypeFromCellString(cell.textLabel.text);
    
    if( _StatFilters & type_filter )
        [ cell.textLabel setTextColor:SELECTED_FILTER_COLOUR ];
    else
        [ cell.textLabel setTextColor:UNSELECTED_FILTER_COLOUR ];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *d=[_arrayForTable objectAtIndex:indexPath.row];
    
    if([d valueForKey:@"Objects"])  //expanding rows
    {
        NSArray *ar=[d valueForKey:@"Objects"];
        
        BOOL isAlreadyInserted=NO;
        
        for(NSDictionary *dInner in ar )
        {
            NSInteger index=[_arrayForTable indexOfObjectIdenticalTo:dInner];
            isAlreadyInserted = (index > 0 && index != NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        
        if(isAlreadyInserted)
        {
            [self miniMizeThisRows:ar];
        }
        else
        {
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            NSString *key_str = [d objectForKey:FILTER_NAME_KEY];
            bool pitch_type_filter = [self headerClickedIsPitchType:key_str];
            
            //If we are choosing a pitch filter, only add pitches pitcher has to array, otherwise add default stuff
            //essentially hides pitches pitcher does not have
            for(NSDictionary *dInner in ar )
            {
                if( !pitch_type_filter || (getPitchTypeFromString([dInner objectForKey:FILTER_NAME_KEY]) & _pitcher.info.pitches) )
                {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [_arrayForTable insertObject:dInner atIndex:count++];
                }
            }
            
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
    else    //clicking on actual filter
    {
        //mask in filter, set background
        NSString *value_str = [d objectForKey:FILTER_NAME_KEY];
        
        if( !getPitchTypeFromString(value_str) )    //not a pitch filter
        {
            StatTypes new_filter = getFilterTypeFromCellString(value_str);
            _StatFilters = _StatFilters ^ new_filter;
            
            UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
            bool new_filter_enabled = (_StatFilters & new_filter);
            
            [ self setTextColourOnFilterClicked:cell with:new_filter_enabled ];
        }
        else
        {
            PitchTypes new_filter = getPitchTypeFromString(value_str);
            _PitchFilters = _PitchFilters ^ new_filter;
            
            UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
            bool new_filter_enabled = (_PitchFilters & new_filter);
            
            [ self setTextColourOnFilterClicked:cell with:new_filter_enabled ];
        }
    }
}

-(void) setTextColourOnFilterClicked:(UITableViewCell *) cell with: (bool) selected
{
    if(selected)
        cell.textLabel.textColor = SELECTED_FILTER_COLOUR;
    else
        cell.textLabel.textColor = UNSELECTED_FILTER_COLOUR;
}

-(void)miniMizeThisRows:(NSArray*)ar
{
    for(NSDictionary *dInner in ar )
    {
        NSUInteger indexToRemove=[_arrayForTable indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"Objects"];
        
        if(arInner && [arInner count]>0)
            [self miniMizeThisRows:arInner];
        
        if([self.arrayForTable indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [_arrayForTable removeObjectIdenticalTo:dInner];
            [_filterTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexToRemove inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}
//------------------------//

//-----Locals for filter table-----//
-(NSArray *) getPitchFilterArray
{
    NSMutableArray *ret = [ [NSMutableArray alloc] init ];
    
    int pitch_mask = 0;
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        pitch_mask = 1 << i;
        if( _pitcher.info.pitches & pitch_mask )
            [ ret addObject:getPitchString(pitch_mask) ];
    }
    
    return ret;
}

-(bool) headerClickedIsPitchType:(NSString *)str
{
    NSString *cmp_str = [ str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    return ( [cmp_str caseInsensitiveCompare:PITCH_TYPE_FILTER_STR] == NSOrderedSame );
}

-(bool) headerClickedIsCount:(NSString *)str
{
    NSString *cmp_str = [ str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    return ( [cmp_str caseInsensitiveCompare:COUNT_TYPE_FILTER_STR] == NSOrderedSame );
}
//---------------------------------//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
