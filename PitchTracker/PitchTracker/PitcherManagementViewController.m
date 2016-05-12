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

//NOTE: Consider using database of pitchers to store pitcher info and
//      pulling from disk for pitcher stats (memory already climbing).

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [ _pitcherScrollView setDelegate:self ];
    
    _currTeamFilter = UOFT;
    
    [ self initButtons ];
    [ self addPitchersToScroll ];
    [ self setUpPitcherView:nil ];
    [ self setUpScrollTouch ];
    
    [ self loadPicker ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _teamPicker.hidden = YES;
}

-(void) viewWillLayoutSubviews
{
    CGRect out_frame = _pitcherView.frame;
    out_frame.size.width = self.view.frame.size.width - _pitcherScrollView.frame.size.width;
    out_frame.size.height = self.view.frame.size.height;
    
    [ _pitcherView setFrame:out_frame ];
}

-(void) setUpPitcherView:(Pitcher*) pitcher
{
    //need to do this stupid math for some reason, storyboard is not fun
    CGRect out_frame = _pitcherView.frame;
    out_frame.size.width = self.view.frame.size.width - _pitcherScrollView.frame.size.width;
    out_frame.size.height = self.view.frame.size.height;
    
    if( pitcher == nil )
    {
        LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
        NSArray *pitchers = [ database getTeamArray:self.currTeamFilter ];
        
        if( pitchers.count > 0 )
            [ _pitcherView changePitcher:[ pitchers objectAtIndex:0 ] ];
    }
    else
    {
        [ _pitcherView changePitcher:pitcher ];
    }
    
    [ _pitcherView setFrame:out_frame ];
    
    //Gesture setup
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
              initWithTarget:self action:@selector(pitcherViewTap:)];
    tapper.cancelsTouchesInView = NO;
    [ _pitcherView addGestureRecognizer:tapper ];
}

-(void)pitcherViewTap:(UITapGestureRecognizer *) sender
{
    bool refresh = false;
    
    if( [_addPitcherButton.titleLabel.text isEqualToString:@"Cancel"] )
    {
        [ _pitcherView.arm_view endEditing:YES ];
        refresh = [ _pitcherView.arm_view checkTouchInSelectableLabels:[sender locationInView:_pitcherView] ];
    }
    else
    {
        if( [_pitcherView clickInsideEdit:[sender locationInView:_pitcherView]] )
        {
            _currViewType = MODE_EDIT;
            [ self changePitcherViewToEditPitcher ];
        }
    }
    
    //refreshes the scroll view, set pitcher view to the new added pitcher
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
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    [ database editPitcher:pitcher ];
    
    [ _pitcherScrollView changeTeam:_currTeamFilter ];  //possibly write a 'refresh' instead of dummy team change
    [ _pitcherView changePitcher:pitcher ];
    
    [ _pitcherView cancelNewEditPitcherView ];
    [ _addPitcherButton setTitle:@"New Arm+" forState:UIControlStateNormal ];
    [ _pitcherView.arm_view endEditing:YES ];
    [ _pitcherView.arm_view clearFields ];
    
    _currViewType = MODE_VIEW;
}

-(void) addNewPitcherLeaveView:(Pitcher*) pitcher
{
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    [ pitcher setID:[database getNewPitcherID] ];   //get the new ID for new pitcher
    [ database addPitcher:pitcher ];
    
    [ _pitcherView cancelNewEditPitcherView ];
    [ _addPitcherButton setTitle:@"New Arm+" forState:UIControlStateNormal ];
    [ _pitcherView.arm_view endEditing:YES ];
    [ _pitcherView.arm_view clearFields ];
    
    [ _pitcherScrollView changeTeam:_currTeamFilter ];
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

-(void) initButtons
{
    _filterButton.backgroundColor = _addPitcherButton.backgroundColor = _pitcherScrollView.backgroundColor;
    _filterButton.alpha = _addPitcherButton.alpha = _pitcherScrollView.alpha;
    _filterButton.layer.borderColor = _addPitcherButton.layer.borderColor = [UIColor blackColor].CGColor;
    _filterButton.layer.borderWidth = _addPitcherButton.layer.borderWidth = 1.0f;
}

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
       [ self changePitcherView:clicked_guy ];
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
