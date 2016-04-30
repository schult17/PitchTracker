//
//  PitcherManagementViewController.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherManagementViewController.h"
#import "LocalPitcherDatabase.h"

@interface PitcherManagementViewController ()

@end

@implementation PitcherManagementViewController

@synthesize pitcherScrollView = _pitcherScrollView;
@synthesize filterButton = _filterButton;
@synthesize addPitcherButton = _addPitcherButton;
@synthesize teamPicker = _teamPicker;
@synthesize outerPitcherView = _outerPitcherView;
@synthesize pitcherView = _pitcherView;
@synthesize currTeamFilter = _currTeamFilter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ _pitcherScrollView setDelegate:self ];
    
    _filterButton.backgroundColor = _addPitcherButton.backgroundColor = _pitcherScrollView.backgroundColor;
    _filterButton.alpha = _addPitcherButton.alpha = _pitcherScrollView.alpha;
    _currTeamFilter = UOFT;
    
    [ self addPitchersToScroll ];
    [ self setUpPitcherView:nil ];
    
    [ self loadPicker ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _teamPicker.hidden = YES;
}

-(void) setUpPitcherView:(Pitcher*) pitcher
{
    //need to do this stupid math for some reason, storyboard is not fun
    CGRect out_frame = _outerPitcherView.frame;
    out_frame.size.width = self.view.frame.size.width - _pitcherScrollView.frame.size.width;
    out_frame.size.height = self.view.frame.size.height;
    _outerPitcherView.frame = out_frame;
    
    CGRect in_frame = CGRectMake(0, 0, _outerPitcherView.frame.size.width, _outerPitcherView.frame.size.height);
    
    if( pitcher == nil )
    {
        LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
        NSArray *pitchers = [ database getTeamArray:self.currTeamFilter ];
        
        if( pitchers.count <= 0 )
            _pitcherView = [ [PitcherView alloc] initWithFrame:in_frame];
        else
            _pitcherView = [ [PitcherView alloc] initWithFrameAndPlayer:in_frame with:[ pitchers objectAtIndex:0 ] ];
    }
    else
    {
        _pitcherView = [ [PitcherView alloc] initWithFrameAndPlayer: in_frame with: pitcher];
    }
    
    [ _outerPitcherView addSubview:_pitcherView ];
}

-(void) changePitcherView:(Pitcher*)pitcher
{
    if( pitcher == nil )
    {
        LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
        NSArray *pitchers =[ database getTeamArray:_currTeamFilter ];
        
        if( pitchers.count > 0 )
            [ _pitcherView changePitcher:[pitchers objectAtIndex:0] ];
        else
            [ _pitcherView changePitcher:nil ];
    }
    else
    {
        [ _pitcherView changePitcher:pitcher ];
    }
}

- (void) addPitchersToScroll
{
    [ _pitcherScrollView changeTeam:UOFT ];
}

- (IBAction)handleButtonClick:(id)sender
{
    if( sender == _filterButton )
        [ self togglePickerHidden ];
    else if( sender == _addPitcherButton )
        [ self addPitcher ];
}

-(void) teamFilterChanged: (TeamNames) team
{
    self.currTeamFilter = team;
    [ _pitcherScrollView changeTeam:team ];
    [ self changePitcherView:nil ];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) addPitcher
{
    NSLog(@"Add Pitcher");
}



//--Team picker methods--//
-(void) loadPicker
{
    _teamPicker = [ UIPickerView new ];
    _teamPicker.delegate = self;
    _teamPicker.dataSource = self;
    _teamPicker.showsSelectionIndicator = YES;
    
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
        [ _teamPicker selectRow:(int)_currTeamFilter inComponent:0 animated:NO ];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //New filter chosen
    [ self teamFilterChanged:(TeamNames)row ];
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
