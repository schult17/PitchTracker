//
//  InGameViewController.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "InGameViewController.h"
#import "LocalPitcherDatabase.h"
#import "PitcherManagementViewController.h"
#import "SelectableLabel.h"
#import "Pitcher.h"

@implementation InGameViewController

@synthesize team1 = _team1;
@synthesize team2 = _team2;
@synthesize team1visible = _team1visible;
@synthesize teamToggleButton = _teamToggleButton;
@synthesize pitcherScrollView = _pitcherScrollView;
@synthesize zoneTeamView = _zoneTeamView;
@synthesize infoView = _infoView;

@synthesize teamLabel = _teamLabel;
@synthesize nameLabel = _nameLabel;
@synthesize bodyLabel = _bodyLabel;
@synthesize numHandLabel = _numHandLabel;
@synthesize statsButton = _statsButton;
@synthesize pitchLabels = _pitchLabels;

@synthesize currPitcher1 = _currPitcher1;
@synthesize currPitcher2 = _currPitcher2;

@synthesize zoneView = _zoneView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _currPitcher1 = _currPitcher2 = nil;
    
    //team 1 is visible first
    _team1visible = true;
    [ self createInfoLabels ];
    [ self createZoneDisplay ];
    [ self createPitchLabels ];

    [ self setUpScrollTouch ];
    [ self setUpPitchTouch ];
    [ self setUpZoneTouch ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //To get text there quicker
    [ _teamToggleButton setTitle:TEAM_NAME_STR[_team1] forState:UIControlStateNormal ];
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
    //basically a refresh, toggle bool, then toggle again..
    _team1visible = !_team1visible;
    [ self toggleTeam ];
    
    //highlight default pitcher
    [ self changeInfoView:(_team1visible ? _currPitcher1 : _currPitcher2) ];
}

-(void) viewDidLayoutSubviews
{
    [ self layoutInfoElements ];
    [ self layoutZoneDisplay ];
    [ self layoutPitchLabels ];
}

-(void)toggleTeam
{
    if( _team1visible )
    {
        [ _teamToggleButton setTitle:TEAM_NAME_STR[_team2] forState:UIControlStateNormal ];
        _team1visible = false;
        [ _pitcherScrollView changeTeam:_team2 ];
        [ self changeInfoView:_currPitcher2 ];
        [ _pitcherScrollView highlightPitcher:_currPitcher2.pitcher_id ];
    }
    else
    {
        [ _teamToggleButton setTitle:TEAM_NAME_STR[_team1] forState:UIControlStateNormal ];
        _team1visible = true;
        [ _pitcherScrollView changeTeam:_team1 ];
        [ self changeInfoView:_currPitcher1 ];
        [ _pitcherScrollView highlightPitcher:_currPitcher1.pitcher_id ];
    }
}

- (IBAction)handleButtonClick:(id)sender
{
    if( sender == _teamToggleButton )
        [ self toggleTeam ];
}

//-----Zone display-----//
-(void) createZoneDisplay
{
    _zoneView = [ [ZoneView alloc] init ];
    [ _zoneTeamView addSubview:_zoneView ];
    _selectedView = nil;
}

-(void)layoutZoneDisplay
{
    CGRect f = CGRectMake(_zoneTeamView.frame.size.width/2,
                          0,
                          _zoneTeamView.frame.size.width/2,
                          _zoneTeamView.frame.size.height);
    
    [ _zoneView setFrame:f ];
}
//----------------------//

//-----Pitcher pitch labelbuttons-----//
-(void) createPitchLabels
{
    _pitchLabels = [ [NSMutableArray alloc] init ];
    _addPitchButton = [ [UIButton alloc] init ];
    [ _addPitchButton setTitle:@"ADD PITCH" forState:UIControlStateNormal ];
    [ _addPitchButton setTitleColor:[UIColor colorWithRed:0 green:122 blue:255 alpha:1] forState:UIControlStateNormal ];   //TODO -- better colour
    
    //TODO -- animate button like storyboard button?
    [ _addPitchButton addTarget:self action:@selector(addPitchButtonClicked) forControlEvents:UIControlEventTouchUpInside ];
    UIFont *f = _addPitchButton.titleLabel.font;
    f = [ f fontWithSize:30 ];
    _addPitchButton.titleLabel.font = f;
    
    _selectedPitch = FASTBALL_4;
    _selectedPitchLabel = nil;
}

-(void) layoutPitchLabels
{
    for( SelectableLabel *i in _pitchLabels )
        [ i removeFromSuperview ];
    
    [ _pitchLabels removeAllObjects ];
    
    Pitcher *curr = _team1visible ? _currPitcher1 : _currPitcher2;
    
    for( int i = 0; i < curr.info.pitches.count; i++ )
    {
        SelectableLabel *add = [ [SelectableLabel alloc] initWithStr:[self getPitchString:[curr.info.pitches[i] intValue]] ];
        [ _pitchLabels addObject:add ];
    }
    
    CGFloat x = _infoView.frame.size.width/2;
    CGFloat w = _infoView.frame.size.width/2;
    CGFloat h = DISPLAY_LABEL_HEIGHT;
    
    //being explicit with the math ( - 1 + 2 )
    float delta = ( _infoView.frame.size.height - (_pitchLabels.count + 1)*h) / ((_pitchLabels.count + 1) - 1 + 2 );
    
    CGRect f;
    int i;
    for( i = 0; i < _pitchLabels.count; i++ )
    {
        f = CGRectMake(x, i*(h + delta) + delta, w, h);
        [ _pitchLabels[i] setFrame:f ];
        [ _infoView addSubview:_pitchLabels[i] ];
    }
    
    f = CGRectMake(x, i*(h + delta) + delta, w, h);
    [ _addPitchButton setFrame:f ];
    [ _infoView addSubview:_addPitchButton ];
}
//------------------------------------//

//-----Pitcher info display-----//
-(void) createInfoLabels
{
    _teamLabel = [ [UILabel alloc] init ];
    _nameLabel = [ [UILabel alloc] init ];
    _bodyLabel = [ [UILabel alloc] init ];
    _numHandLabel = [ [UILabel alloc] init ];
    _statsButton = [ [UIButton alloc] init ];
    
    _teamLabel.textColor = _nameLabel.textColor = _bodyLabel.textColor = _numHandLabel.textColor /*= _pitchesLabel.textColor*/ = [ UIColor whiteColor ];
    
    UIFont *f = _nameLabel.font;
    f = [ f fontWithSize:30 ];
    _teamLabel.font = _nameLabel.font = _bodyLabel.font = _numHandLabel.font = _statsButton.titleLabel.font = f;
    
    //TODO -- animate button like storyboard button?
    [ _statsButton setTitle:@"VIEW PITCHER STATS" forState:UIControlStateNormal ];
    [ _statsButton setTitleColor:[UIColor colorWithRed:0 green:122 blue:255 alpha:1] forState:UIControlStateNormal ];   //TODO -- better colour
    [ _statsButton addTarget:self action:@selector(statsButtonClicked) forControlEvents:UIControlEventTouchUpInside ];
    
    [ _infoView addSubview:_teamLabel ];
    [ _infoView addSubview:_nameLabel ];
    [ _infoView addSubview:_bodyLabel ];
    [ _infoView addSubview:_numHandLabel ];
    [ _infoView addSubview:_statsButton ];
}

-(void) layoutInfoElements
{
    CGFloat w = _infoView.frame.size.width/2;
    CGFloat h = DISPLAY_LABEL_HEIGHT;
    
    //being explicit with the math ( - 1 + 2 )
    float delta = ( _infoView.frame.size.height - NUM_LABELS_IN_INFO_VIEW*h) / (NUM_LABELS_IN_INFO_VIEW - 1 + 2 );
    
    CGRect f = CGRectMake(0, delta, w, h);
    [ _teamLabel setFrame:f ];
    
    f.origin.y += h + delta;
    [ _nameLabel setFrame:f ];
    
    f.origin.y += h + delta;
    [ _bodyLabel setFrame:f ];
    
    f.origin.y += h + delta;
    [ _numHandLabel setFrame:f ];
    
    f.origin.y += h + delta;
    [ _statsButton setFrame:f ];
}

-(void) setPitcher:(Pitcher*)pitcher
{
    if( pitcher != nil )
    {
        _teamLabel.text = [ NSString stringWithFormat:@"\t%@", pitcher.info.getTeamDisplayString ];
        _nameLabel.text = [ NSString stringWithFormat:@"\t%@", pitcher.info.getNameDisplayString ];
        _bodyLabel.text = [ NSString stringWithFormat:@"\t%@", pitcher.info.getPhysicalDisplayString ];
        _numHandLabel.text = [ NSString stringWithFormat:@"\t%@", pitcher.info.getNumberHandDisplayString ];
    }
    else
    {
        _teamLabel.text = @"";
        _nameLabel.text = @"\t\tNo pitchers to display for this team";
        _bodyLabel.text = @"";
        _numHandLabel.text = @"";
    }
    
    if( _team1visible )
        _currPitcher1 = pitcher;
    else
        _currPitcher2 = pitcher;
    
    [ self layoutPitchLabels ];
}

-(void) changeInfoView:(Pitcher*)pitcher
{
    if( pitcher == nil )
    {
        LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
        NSArray *pitchers = [ database getTeamArray:(_team1visible ? _team1 : _team2) ];
        
        if( pitchers.count > 0 )
            [ self setPitcher:[pitchers objectAtIndex:0] ];
        else
            [ self setPitcher:nil ];
    }
    else
    {
        [ self setPitcher:pitcher ];
    }
}
//----------------------------------------//


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//----------Touching of zone view----------//
-(void) setUpZoneTouch
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoneTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    
    [_zoneView addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)zoneTap:(UITapGestureRecognizer *)gesture
{
    CGPoint tap = [ gesture locationInView: _zoneView ];
    _selectedView = [ _zoneView handleTapInZone:tap ];
}
//-----------------------------------------//

//-----Touching of pitch types-----//
-(void) setUpPitchTouch
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pitchTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    
    [_infoView addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)pitchTap:(UITapGestureRecognizer *)gesture
{
    int index = 0;
    CGPoint tap = [ gesture locationInView: _infoView ];
    for( SelectableLabel *i in _pitchLabels )
    {
        if( CGRectContainsPoint(i.frame, tap) )
        {
            [ i setSelect:true ];
            if(_selectedPitchLabel != nil)  [ _selectedPitchLabel setSelect:false ];
            _selectedPitchLabel = i;
            _selectedPitch = (PitchType)[ (_team1visible ? _currPitcher1 : _currPitcher2).info.pitches[index] intValue ];
            return;
        }
        index += 1;
    }

    _selectedPitch = FASTBALL_4;
    _selectedPitchLabel = nil;
}
//-----------------------------------------//

//-----Touching of pitcher scroll view-----//
-(void) setUpScrollTouch
{
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    singleTapGestureRecognizer.enabled = YES;
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
    
    [_pitcherScrollView addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)scrollTap:(UITapGestureRecognizer *)gesture
{
    //TODO -- add confirm they want to change pitchers
    CGPoint tap = [ gesture locationInView: _pitcherScrollView ];
    Pitcher *clicked_guy = [ _pitcherScrollView findPitcherFromTouch:tap ];
    
    if( clicked_guy != nil )
        [ self changeInfoView:clicked_guy ];
}
//-----------------------------------------//

//-----Clicking the stats button-----//
-(void) statsButtonClicked
{
    [ self performSegueWithIdentifier:@"statsSegue" sender:self ];
}
//-----------------------------------//

//-----Clicking in add Pitch Button-----//
-(void) addPitchButtonClicked
{
    NSLog(@"Add Current Pitch");
    //TODO -- make sure a zone is selected and a pitch is selected
    //then present them and ask the outcome of the pitch
}
//--------------------------------------//

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PitcherManagementViewController *cont = (PitcherManagementViewController*)[ segue destinationViewController ];
    
    cont.seguePitcher = _team1visible ? _currPitcher1 : _currPitcher2;
    cont.currTeamFilter = _team1visible ? _team1 : _team2;
    cont.disable_editing = true;
}

-(NSString*) getPitchString:(PitchType)type
{
    NSString *ret;
    
    switch( type )
    {
        case FASTBALL_4:
            ret = @"Fastball(4)";
            break;
        case FASTBALL_2:
            ret = @"Fastball(2)";
            break;
        case CUTTER:
            ret = @"Cutter";
            break;
        case CURVE_1:
            ret = @"Curve";
            break;
        case CURVE_2:
            ret = @"Curve(2)";
            break;
        case SLIDER:
            ret = @"Slider";
            break;
        case CHANGE:
            ret = @"Changeup";
            break;
        case SPLITTER:
            ret = @"Splitter";
            break;
        default:
            ret = @"Unknown";
            break;
    }
    
    return ret;
}

@end
