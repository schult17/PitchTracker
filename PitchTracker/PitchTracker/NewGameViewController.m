//
//  NewGameViewController.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "NewGameViewController.h"
#import "InGameViewController.h"

@interface NewGameViewController ()

@end

@implementation NewGameViewController

@synthesize team1Button = _team1Button;
@synthesize team2Button = _team2Button;
@synthesize startGameButton = _startGameButton;
@synthesize teamPicker = _teamPicker;
@synthesize team1 = _team1;
@synthesize team2 = _team2;
@synthesize button_num = _button_num;

- (void)viewDidLoad
{
    [ super viewDidLoad ];
    // Do any additional setup after loading the view from its nib.
    
    [ self setUpTeamButtons ];
    [ self loadPicker ];
}

-(void) setUpTeamButtons
{
    _team1 = UOFT;
    _team2 = GUELPH;
    _button_num = 1;
    
    _team1Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _team2Button.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)setButtonsStrings
{
    [ _team1Button setTitle:TEAM_NAME_STR[_team1] forState:UIControlStateNormal ];
    [ _team2Button setTitle:TEAM_NAME_STR[_team2] forState:UIControlStateNormal ];
}

- (IBAction)handleButtonClick:(id)sender
{
    /* One team button is clicked, center the picker on that
     * button and show it. Also hide the button itself to avoid
     * ugly overlap of text*/
    if( sender == _team1Button )
    {
        _button_num = 1;
        [ _teamPicker setCenter:_team1Button.center];
        _team1Button.hidden = YES;
    }
    else if( sender == _team2Button )
    {
        _button_num = 2;
        [ _teamPicker setCenter:_team2Button.center];
        _team2Button.hidden = YES;
    }
    
    _teamPicker.hidden = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [ self setButtonsStrings ];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//--Team picker delegate methods--//
-(void) loadPicker
{
    _teamPicker = [ UIPickerView new ];
    _teamPicker.delegate = self;
    _teamPicker.dataSource = self;
    _teamPicker.showsSelectionIndicator = YES;
    
    [ self.view addSubview:_teamPicker ];
    
    _teamPicker.hidden = YES;
}

//Returns a formatted string for a row of the picker view
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name;
    
    name = TEAM_NAME_STR[ row ];
    
    NSAttributedString *attString = [ [NSAttributedString alloc] initWithString:name attributes:@{NSForegroundColorAttributeName:_team1Button.titleLabel.textColor} ];
    
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
    {
        if( _button_num == 1 )
            [ _teamPicker selectRow:(int)_team1 inComponent:0 animated:NO ];
        else if( _button_num == 2 )
            [ _teamPicker selectRow:(int)_team2 inComponent:0 animated:NO ];
        else
            NSLog( DEBUG_NORMAL, @"Bad team 1 or 2");
    }
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    TeamNames temp = (TeamNames)row;    //to avoid same team in both
    
    if( _button_num == 1 )
    {
        if( temp == _team2 )
            _team2 = _team1;
        
        _team1 = temp;
    }
    else if( _button_num == 2 )
    {
        if( temp == _team1 )
            _team1 = _team2;
        
        _team2 = temp;
    }
    else
    {
        NSLog( DEBUG_NORMAL, @"Bad team 1 or 2");
    }
    
    
    [ self setButtonsStrings ];
    
    _teamPicker.hidden = YES;
    
    _team1Button.hidden = NO;
    _team2Button.hidden = NO;
    
}
//-----------------------//

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
 {
     /* NOTE - segue and unwind are not the same! Only called when moving "forward"
      * not unwinding backwards (if another button comes here, must distunguish between destination
      * view controllers*/
     
     //Set the two selected teams for the game
     InGameViewController *dest = (InGameViewController*)[ segue destinationViewController ];
     
     dest.team1 = _team1;
     dest.team2 = _team2;
}

@end
