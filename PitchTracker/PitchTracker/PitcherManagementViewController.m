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
@synthesize pitcherView = _pitcherView;
@synthesize currTeamFilter = _currTeamFilter;
@synthesize currViewType = _currViewType;
@synthesize disable_editing = _disable_editing;
@synthesize seguePitcher = _seguePitcher;

//NOTE: Consider using database of pitchers to store pitcher info and
//      pulling from disk for pitcher stats (memory already climbing).

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ _pitcherScrollView setDelegate:self ];
    
    [ self initButtons ];
    [ self setUpPitcherView:nil ];
    [ self setUpScrollTouch ];
    
    [ self loadPicker ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _teamPicker.hidden = YES;
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
    //TODO -- why is there a big space in this scroll view, but not in new game one...
    [ self addPitchersToScroll ];
}

-(void) viewWillLayoutSubviews
{
    //important this is here
    [ _pitcherView layoutView ];
}

-(void) setUpPitcherView:(Pitcher*) pitcher
{
    //If the pitcher is nil (sometimes called with nil), get the shared database,
    //and use the current team to find the first pitcher in the list (by default)
    if( pitcher == nil )
    {
        LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
        NSArray *pitchers = [ database getTeamArray:self.currTeamFilter ];
        
        if( pitchers.count > 0 && !_disable_editing )
            [ _pitcherView changePitcher:[ pitchers objectAtIndex:0 ] ];
        else
            [ _pitcherView changePitcher:_seguePitcher ];
    }
    else
    {
        [ _pitcherView changePitcher:pitcher ];
    }
    
    //Setup the gesture recognizer for tapping on the pitcher view (the info and stats)
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(pitcherViewTap:)];
    tapper.cancelsTouchesInView = NO;
    [ _pitcherView addGestureRecognizer:tapper ];
}

//Handle the tap of the pitcher view
-(void)pitcherViewTap:(UITapGestureRecognizer *) sender
{
    bool refresh = false;
    
    if( [_addPitcherButton.titleLabel.text isEqualToString:@"Cancel"] && !_disable_editing )
    {
        //if the text of the button is currently "Cancel", we are already editing, check if
        //the 'Add Pitcher' button for adding a new pitcher has been tapped
        [ _pitcherView.arm_view endEditing:YES ];
        refresh = [ _pitcherView.arm_view checkTouchInSelectableLabels:[sender locationInView:_pitcherView] ];
    }
    else
    {
        //if editing is enabled (we can get to this controller from the In Game controller, where
        //editing is disabled) and the click was inside the edit button....
        if( [_pitcherView clickInsideEdit:[sender locationInView:_pitcherView]] && !_disable_editing )
        {
            //switch to edit pitcher mode
            _currViewType = MODE_EDIT;
            [ self changePitcherViewToEditPitcher ];
        }
    }
    
    //refreshes the scroll view, set pitcher view to the new added pitcher or update
    if( refresh )
    {
        if( _currViewType == MODE_NEW )
        {
            Pitcher *new_pitcher = [ _pitcherView.arm_view getPitcherWithInfo:_currTeamFilter ];
            //TODO - check for duplicates, stop exiting... once addNewPitcherLeaveView is called
            //the addition is 'permanent'
            [ self addNewPitcherLeaveView:new_pitcher ];
        }
        else
        {
            Pitcher *edit_pitcher = [ _pitcherView.arm_view getPitcherWithInfo:_currTeamFilter ];
            [ self editPitcherLeaveView:edit_pitcher ];
        }
    }
}

-(void) editPitcherLeaveView:(Pitcher*) pitcher
{
    //edit the pitcher in the database
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    
    //pitcher is a copy of the edited pitcher, must add the exisiting ID
    [ pitcher setID:_pitcherView.pitcher.pitcher_id ];
    [ database editPitcher:pitcher ];
    
    //refreshing scroll and pitcher view when pitcher is edited
    [ _pitcherScrollView changeTeam:pitcher.info.team ];  //possibly write a 'refresh' instead of dummy team change
    [ _pitcherScrollView highlightPitcher:pitcher.pitcher_id ];
    [ _pitcherView changePitcher:pitcher ];
    
    //Leave editing of pitcher
    [ _pitcherView cancelNewEditPitcherView ];
    [ _addPitcherButton setTitle:@"New Arm+" forState:UIControlStateNormal ];
    [ _pitcherView.arm_view endEditing:YES ];
    [ _pitcherView.arm_view clearFields ];
    
    _currViewType = MODE_VIEW;
}

-(void) addNewPitcherLeaveView:(Pitcher*) pitcher
{
    //add new pitcher to database
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    [ pitcher setID:[database getNewPitcherID] ];   //get the new ID for new pitcher
    [ database addPitcher:pitcher ];
    
    //switch the view and update all views
    [ _pitcherView cancelNewEditPitcherView ];
    [ _addPitcherButton setTitle:@"New Arm+" forState:UIControlStateNormal ];
    [ _pitcherView.arm_view endEditing:YES ];
    [ _pitcherView.arm_view clearFields ];
    
    //highlight the new pitcher in the scroll
    [ _pitcherScrollView changeTeam:pitcher.info.team ];
    [ _pitcherScrollView highlightPitcher:pitcher.pitcher_id ];
    [ self changePitcherViewToNewPitcher ];
    
    _currViewType = MODE_VIEW;
}

-(void) changePitcherViewToEditPitcher
{
    _currViewType = MODE_EDIT;
    [ _pitcherView switchToEditPitcher ];
    [ _addPitcherButton setTitle:@"Cancel" forState:UIControlStateNormal ];
}

-(void) changePitcherViewToNewPitcher
{
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    NSArray *pitchers =[ database getTeamArray:_currTeamFilter ];
    
    [ self changePitcherView:[pitchers lastObject] ];
}

//presenting a new pitcher in the pitcher view
-(void) changePitcherView:(Pitcher*)pitcher
{
    //if pitcher is nil (sometimes called this way), use the current team
    //to get the first pitcher in the list (default)
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

//add the pitchers of the current team to the scroll view
- (void) addPitchersToScroll
{
    [ _pitcherScrollView changeTeam:_currTeamFilter ];
    
    if( _seguePitcher != nil )
        [ _pitcherScrollView highlightPitcher:_seguePitcher.pitcher_id ];
}

//handle storyboard button clicks
- (IBAction)handleButtonClick:(id)sender
{
    if( sender == _filterButton )
        [ self togglePickerHidden ];
    else if( sender == _addPitcherButton )
        [ self addEditPitcher ];
}

//changing the current team
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

//called when _addPitcherButton is clicked, could be Cancel or New Arm+
-(void) addEditPitcher
{
    if( !_disable_editing )
    {
        NSString *text = _addPitcherButton.titleLabel.text;
        
        if( [text isEqualToString:@"Cancel"] )
        {
            [ self cancelNewEditPitcher ];
        }
        else    //button text is 'New Arm+"
        {
            _currViewType = MODE_NEW;
            [ _pitcherView switchToNewPitcher ];
            [ _addPitcherButton setTitle:@"Cancel" forState:UIControlStateNormal ];
        }
    }
}

-(void) initButtons
{
    _filterButton.backgroundColor = _addPitcherButton.backgroundColor = _pitcherScrollView.backgroundColor;
    _filterButton.alpha = _addPitcherButton.alpha = _pitcherScrollView.alpha;
    _filterButton.layer.borderColor = _addPitcherButton.layer.borderColor = [UIColor blackColor].CGColor;
    _filterButton.layer.borderWidth = _addPitcherButton.layer.borderWidth = 2.0f;
    
    //maybe black(or hidden) for disabled?
    if( _disable_editing )
    {
        [ _addPitcherButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal ];
        _pitcherView.editButton.textColor = [UIColor lightGrayColor];
    }
    else
    {
        [ _addPitcherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal ];
        _pitcherView.editButton.textColor = [UIColor whiteColor];
    }
}

//cancel the editing or addition of a new pitcher
-(void) cancelNewEditPitcher
{
    NSString *_message = @"Are you sure you want to cancel the recent changes?";
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:_message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
    {
        [ _pitcherView cancelNewEditPitcherView ];
        [ _addPitcherButton setTitle:@"New Arm+" forState:UIControlStateNormal ];
        [ _pitcherView.arm_view endEditing:YES ];
        [ _pitcherView.arm_view clearFields ];
        _currViewType = MODE_VIEW;
    }];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){}];
    
    [ alert addAction:yesAction ];
    [ alert addAction:noAction ];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    CGPoint tap = [ gesture locationInView: _pitcherScrollView ];
    Pitcher *clicked_guy = [ _pitcherScrollView findPitcherFromTouch:tap ];
    
    if( clicked_guy != nil )
    {
        if( _pitcherScrollView.lastTouchLocation == IN_PITCHER_DELETE )
            [ self deleteSelectedPitcher:clicked_guy ];
        else
            [ self changePitcherView:clicked_guy ];
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
                                    [ self changePitcherView:nil ];
                                }];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){}];
    
    [ alert addAction:yesAction ];
    [ alert addAction:noAction ];
    
    [ self presentViewController:alert animated:YES completion:nil ];
}
//-----------------------------------------//

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
