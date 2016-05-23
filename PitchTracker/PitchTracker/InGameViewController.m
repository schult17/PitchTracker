//
//  InGameViewController.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

//TODO -- if _currentAtPlate has UKNWN hand, ask to input batters hand
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
@synthesize countLabel = _countLabel;
@synthesize countStrikes = _countStrikes;
@synthesize countBalls = _countBalls;

@synthesize teamLabel = _teamLabel;
@synthesize nameLabel = _nameLabel;
@synthesize bodyLabel = _bodyLabel;
@synthesize numHandLabel = _numHandLabel;
@synthesize statsButton = _statsButton;
@synthesize pitchLabels = _pitchLabels;

@synthesize currPitcher1 = _currPitcher1;
@synthesize currPitcher2 = _currPitcher2;

@synthesize zoneView = _zoneView;

@synthesize team1Label = _team1Label;
@synthesize pitch1Label = _pitch1Label;
@synthesize vsLabel = _vsLabel;
@synthesize team2Label = _team2Label;
@synthesize pitch2Label = _pitch2Label;
@synthesize nextBatterButton = _nextBatterButton;
@synthesize currAtPlate = _currAtPlate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _currPitcher1 = _currPitcher2 = nil;
    
    //team 1 is visible first by default
    _team1visible = true;
    
    [ self createGameDisplay ];
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
    
    //basically a refresh, toggle bool, then toggle again...
    _team1visible = !_team1visible;
    [ self toggleTeam ];
}

//IMPORTANT: all layouts relative to storyboard frames should be done here
//          to layout properly (this is called after layout of storyboard views)
-(void) viewDidLayoutSubviews
{
    [ self layoutGameDisplay ];
    [ self layoutInfoElements ];
    [ self layoutZoneDisplay ];
    [ self layoutPitchLabels ];
}

-(void)toggleTeam
{
    if( _team1visible )
    {
        _team1visible = false;  //important first
        [ _teamToggleButton setTitle:TEAM_NAME_STR[_team2] forState:UIControlStateNormal ];
        [ _pitcherScrollView changeTeam:_team2 ];
        [ self changeInfoView:_currPitcher2 ];
        [ _pitcherScrollView highlightPitcher:_currPitcher2.pitcher_id ];
    }
    else
    {
        _team1visible = true; //important first
        [ _teamToggleButton setTitle:TEAM_NAME_STR[_team1] forState:UIControlStateNormal ];
        [ _pitcherScrollView changeTeam:_team1 ];
        [ self changeInfoView:_currPitcher1 ];
        [ _pitcherScrollView highlightPitcher:_currPitcher1.pitcher_id ];
    }
    
    [ self onTeamChangeChangeGameDisplay ];
}

- (IBAction)handleButtonClick:(id)sender
{
    if( sender == _teamToggleButton )
        [ self toggleTeam ];
}

//-----Game Display-----//
-(void) createGameDisplay
{
    _currAtPlate = [ [AtPlate alloc] init ];
    _team1Label = [ [UILabel alloc] init ];
    _pitch1Label = [ [UILabel alloc] init ];
    _vsLabel = [ [UILabel alloc] init ];
    _team2Label = [ [UILabel alloc] init ];
    _pitch2Label = [ [UILabel alloc] init ];
    _countLabel = [ [UILabel alloc] init ];
    
    _nextBatterButton = [ [UIButton alloc] init ];
    [ _nextBatterButton addTarget:self action:@selector(nextBatterButtonClicked) forControlEvents:UIControlEventTouchUpInside ];
    
    [ self setGameLabels ];
    [ _zoneTeamView addSubview:_team1Label ];
    [ _zoneTeamView addSubview:_pitch1Label ];
    [ _zoneTeamView addSubview:_vsLabel ];
    [ _zoneTeamView addSubview:_team2Label ];
    [ _zoneTeamView addSubview:_pitch2Label ];
    [ _zoneTeamView addSubview:_countLabel ];
    [ _zoneTeamView addSubview:_nextBatterButton ];
}

-(void) layoutGameDisplay
{
    float h = DISPLAY_LABEL_HEIGHT;
    
    //+1 on label count GONE due to aligning next batter button to bottom of frame (MATHHHHH)
    float delta = ( _zoneTeamView.frame.size.height - (NUM_LABELS_IN_GAME_INFO)*h) / (NUM_LABELS_IN_GAME_INFO);
    
    CGRect f = CGRectMake( GAME_LABEL_INSET, delta, _zoneTeamView.frame.size.width/2, h );
    
    [ _team1Label setFrame:f ];
    
    f.origin.y += h + delta;
    [ _pitch1Label setFrame:f ];
    
    f.origin.y += h + delta;
    [ _vsLabel setFrame:f ];
    
    f.origin.y += h + delta;
    [ _team2Label setFrame:f ];
    
    f.origin.y += h + delta;
    [ _pitch2Label setFrame:f ];
    
    f.origin.y += h + delta;
    [ _countLabel setFrame:f ];
    
    f.origin.y += h + delta;
    [ _nextBatterButton setFrame:f ];
}

-(void) setGameLabels
{
    [ _team1Label setText:TEAM_NAME_STR[_team1] ];
    [ _team2Label setText:TEAM_NAME_STR[_team2] ];
    [ _vsLabel setText:@"VS" ];
    [ _vsLabel setTextColor:[UIColor whiteColor] ];
    [ _countLabel setTextColor:[UIColor whiteColor] ];
    [ _countLabel setTextAlignment:NSTextAlignmentCenter ];
    
    [ self resetPitcherLabels ];
    [ self onTeamChangeChangeGameDisplay ];
    
    UIFont *f = _pitch1Label.font;
    f = [ f fontWithSize:FONT_DISPLAY_SIZE ];
    _team1Label.font = _pitch1Label.font = _vsLabel.font = _team2Label.font = _pitch2Label.font = _countLabel.font = _nextBatterButton.titleLabel.font = f;
    
    [ _countLabel setText:@"Strikes 0 : Balls 0" ];
    
    [ _nextBatterButton setTitle:@"NEW BATTER" forState:UIControlStateNormal ];
    [ _nextBatterButton setTitleColor:BUTTON_COLOUR_CODE forState:UIControlStateNormal ];
}

-(void) onTeamChangeChangeGameDisplay
{
    //highlight currently selected team and pitcher of that team
    if( _team1visible )
    {
        [ _pitch1Label setTextColor:[UIColor greenColor] ];
        [ _team1Label setTextColor:[UIColor greenColor] ];
        
        [ _pitch2Label setTextColor:[UIColor whiteColor] ];
        [ _team2Label setTextColor:[UIColor whiteColor] ];
    }
    else
    {
        [ _pitch1Label setTextColor:[UIColor whiteColor] ];
        [ _team1Label setTextColor:[UIColor whiteColor] ];
        
        [ _pitch2Label setTextColor:[UIColor greenColor] ];
        [ _team2Label setTextColor:[UIColor greenColor] ];
    }
}

-(void) resetPitcherLabels
{
    if( _currPitcher1 != nil )[ _pitch1Label setText:_currPitcher1.info.getNameDisplayString ];
    else [ _pitch1Label setText:@"No Pitchers" ];
    
    if( _currPitcher2 != nil )[ _pitch2Label setText:_currPitcher2.info.getNameDisplayString ];
    else [ _pitch2Label setText:@"No Pitchers" ];
}

-(void) changeCount:(PitchOutcome)new_pitch
{
    if( new_pitch == INPLAY )
    {
        [self nextBatterButtonClicked]; //fake call to next batter clicked, the balls in play
    }
    else
    {
        switch( new_pitch )
        {
            case S_SWING:
            case S_LOOK:
            {
                //Automatic ending of at bat
                if( _countStrikes == 2 )
                {
                    //return to avoid multiple setting of count label
                    [ self endCurrentBatterWithOutcome:( (new_pitch == S_SWING ) ? SO_SWING : SO_LOOK ) ];
                    return;
                }
                else
                {
                    _countStrikes += 1;
                }
                
                break;
            }
            case FOUL:
            {
                if( _countStrikes < 2 )
                    _countStrikes += 1;
                
                break;
            }
            case BALL:
            {
                //Automatic ending of at bat
                if( _countBalls == 3 )
                {
                    //return to avoid multiple setting of count label
                    [ self endCurrentBatterWithOutcome:WALK ];
                    return;
                }
                else
                {
                    _countBalls += 1;
                }
                
                break;
            }
            default:
            {
                break;
            }
        }
        
        [ self changeCountLabel ];
    }
}

-(void) resetCount
{
    _countBalls = _countStrikes = 0;
    [ self changeCountLabel ];
}

-(void) changeCountLabel
{
    [ _countLabel setText:[ NSString stringWithFormat:@"Strikes %i : Balls %i", _countStrikes, _countBalls ] ];
}
//----------------------//

//-----Zone display-----//
-(void) createZoneDisplay
{
    _zoneView = [ [ZoneView alloc] initWithInfo:false ];
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
    [ _addPitchButton setTitleColor:BUTTON_COLOUR_CODE forState:UIControlStateNormal ];   //TODO -- better colour
    
    //TODO -- animate button like storyboard button?
    [ _addPitchButton addTarget:self action:@selector(addPitchButtonClicked) forControlEvents:UIControlEventTouchUpInside ];
    UIFont *f = _addPitchButton.titleLabel.font;
    f = [ f fontWithSize:FONT_DISPLAY_SIZE ];
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
    
    int enum_mask = 0;
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        enum_mask = 1 << i;
        if( curr.info.pitches & enum_mask )
        {
            SelectableLabel *add = [ [SelectableLabel alloc] initWithStr:getPitchString(enum_mask) ];
            [ _pitchLabels addObject:add ];
        }
    }
    
    CGFloat x = _infoView.frame.size.width/2;
    CGFloat w = _infoView.frame.size.width/2;
    CGFloat h = DISPLAY_LABEL_HEIGHT;
    
    //being explicit with the math ( - 1 + 2 ) to find distance between labels
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
    f = [ f fontWithSize:FONT_DISPLAY_SIZE ];
    _teamLabel.font = _nameLabel.font = _bodyLabel.font = _numHandLabel.font = _statsButton.titleLabel.font = f;
    
    //TODO -- animate button like storyboard button?
    [ _statsButton setTitle:@"VIEW PITCHER STATS" forState:UIControlStateNormal ];
    [ _statsButton setTitleColor:NICE_BUTTON_COLOUR forState:UIControlStateNormal ];   //TODO -- better colour??
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

//setting selected pitcher (from scroll view) for current team
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
        _nameLabel.text = @"\t\tNo pitchers to display";
        _bodyLabel.text = @"";
        _numHandLabel.text = @"";
    }
    
    if( _team1visible )
        _currPitcher1 = pitcher;
    else
        _currPitcher2 = pitcher;
    
    [ self resetPitcherLabels ];
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
            _selectedPitch = [(_team1visible ? _currPitcher1 : _currPitcher2).info  pitchByIndex:index];
            return;
        }
        index += 1;
    }
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
    {
        if( _pitcherScrollView.lastTouchLocation == IN_PITCHER_DELETE )
            [ self deleteSelectedPitcher:clicked_guy ];
        else
            [ self changeInfoView:clicked_guy ];
    }
}

-(void) deleteSelectedPitcher:(Pitcher *)pitcher
{
    NSString *_message = @"Are you sure you want to delete this pitcher?";
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:_message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action)
                                {
                                    TeamNames team = pitcher.info.team;
                                    
                                    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
                                    [ database deletePitcher:pitcher];
                                    
                                    //refresh after delete
                                    [ _pitcherScrollView changeTeam:team ];
                                    [ self changeInfoView:nil ];
                                }];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){}];
    
    [ alert addAction:yesAction ];
    [ alert addAction:noAction ];
    
    [ self presentViewController:alert animated:YES completion:nil ];
}
//-----------------------------------------//

//-----Clicking the stats button-----//
-(void) statsButtonClicked
{
    //go to manage pitcher controller to view quick stats, can navigate to advanced stats from there
    [ self performSegueWithIdentifier:@"statsSegue" sender:self ];
}
//-----------------------------------//

//-----Clicking in add Pitch Button-----//
-(void) addPitchButtonClicked
{
    if( _selectedView == nil || _selectedPitchLabel == nil )
    {
        NSString *_message = ( _selectedView == nil ) ? @"You must select the zone of the pitch" : @"You must select the pitch type by clicking on the label";
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:_message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){}];
        
        [ alert addAction:okAction ];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        NSString *_message = @"Select the outcome of the pitch";
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:_message
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* strikeSwingAction = [UIAlertAction actionWithTitle:@"Strike Swinging" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                     { [self addPitchWithPitchOutcome:S_SWING]; }];
        
        UIAlertAction* strikeLookAction = [UIAlertAction actionWithTitle:@"Strike Looking" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                     { [self addPitchWithPitchOutcome:S_LOOK]; }];
        
        UIAlertAction* foulAction = [UIAlertAction actionWithTitle:@"Foul" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     { [self addPitchWithPitchOutcome:FOUL]; }];
        
        UIAlertAction* ballAction = [UIAlertAction actionWithTitle:@"Ball" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                     { [self addPitchWithPitchOutcome:BALL]; }];
        
        UIAlertAction* inPlayAction = [UIAlertAction actionWithTitle:@"In Play" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       { [self addPitchWithPitchOutcome:INPLAY]; }];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action){}];

        
        [ alert addAction:strikeSwingAction ];
        [ alert addAction:strikeLookAction ];
        [ alert addAction:foulAction ];
        [ alert addAction:ballAction ];
        [ alert addAction:inPlayAction ];
        [ alert addAction:cancelAction ];
        
        UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = _addPitchButton;
        popPresenter.sourceRect = _addPitchButton.bounds;
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionDown;
        
        //Surpresses snapshotting error from popover view...
        [ alert.view layoutIfNeeded ];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void) addPitchWithPitchOutcome:(PitchOutcome)result
{
    //Must add pitch before changing count!
    [ _currAtPlate addPitch:_selectedPitch with:_selectedView.X with:_selectedView.Y with:_countBalls with:_countStrikes with:result ];
    [ _zoneView deSelectZone ];
    [ _selectedPitchLabel setSelect:false ];
    
    _selectedView = nil;
    _selectedPitchLabel = nil;
    _selectedPitch = FASTBALL_4;
    [ self changeCount:result ];
}
//--------------------------------------//

//-----Clicking in next batter button-----//
-(void) nextBatterButtonClicked
{
    NSString *_message = @"Select the outcome of the at plate";
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:_message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* kLookAction = [UIAlertAction actionWithTitle:@"K Swinging" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        { [self endCurrentBatterWithOutcome:SO_SWING]; }];
    
    UIAlertAction* kSwingAction = [UIAlertAction actionWithTitle:@"K Looking" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action)
                                       { [self endCurrentBatterWithOutcome:SO_LOOK]; }];
    
    UIAlertAction* hitAction = [UIAlertAction actionWithTitle:@"Hit" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 { [self endCurrentBatterWithOutcome:HIT]; }];
    
    UIAlertAction* walkAction = [UIAlertAction actionWithTitle:@"Walk" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 { [self endCurrentBatterWithOutcome:WALK]; }];
    
    UIAlertAction* errorAction = [UIAlertAction actionWithTitle:@"Error" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                 { [self endCurrentBatterWithOutcome:ERROR]; }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action){}];
    
    [ alert addAction:kSwingAction ];
    [ alert addAction:kLookAction ];
    [ alert addAction:hitAction ];
    [ alert addAction:walkAction ];
    [ alert addAction:errorAction ];
    [ alert addAction:cancelAction ];
    
    UIPopoverPresentationController *popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = _nextBatterButton;
    popPresenter.sourceRect = _nextBatterButton.bounds;
    popPresenter.permittedArrowDirections = UIPopoverArrowDirectionUp;
    
    //Surpresses snapshotting error from popover view
    [ alert.view layoutIfNeeded ];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) endCurrentBatterWithOutcome:(AtPlateOutcome)result
{
    //TODO -- get batter hand!
    _currAtPlate.atbat_result = result;
    Pitcher *pitcher = _team1visible ? _currPitcher1 : _currPitcher2;
    [ pitcher.stats addAtPlate:_currAtPlate ];
    
    _currAtPlate = [ [AtPlate alloc] init ];
    [ self resetCount ];
}
//----------------------------------------//

 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PitcherManagementViewController *cont = (PitcherManagementViewController*)[ segue destinationViewController ];
    
    cont.seguePitcher = _team1visible ? _currPitcher1 : _currPitcher2;
    cont.currTeamFilter = _team1visible ? _team1 : _team2;
    cont.disable_editing = true;
}

@end
