//
//  ViewController.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "ViewController.h"
#import "PitcherManagementViewController.h"
#import "Globals.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize gameButton = _gameButton;
@synthesize manageButton = _manageButton;
@synthesize statsButton = _statsButton;

- (IBAction)handleButtonClick:(id)sender
{
    //Not needed due to segue's, keep for now
    if( sender == _gameButton )
    {
        //NSLog( @"New Game" );
    }
    else if( sender == _manageButton )
    {
        //NSLog( @"Manage Pitchers" );
    }
    else if ( sender == _statsButton )
    {
        NSLog( @"Advanced Statistics" );
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    
#ifdef RESET_DEFAULT_PITCHER
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    Pitcher *add;
    
    //[ add setID:[database getNewPitcherID] ];
    //[ database addPitcher:add ];
    
    NSMutableArray *def = [ [NSMutableArray alloc] init ];
    [ def addObject:@(FASTBALL_4) ];
    [ def addObject:@(FASTBALL_2) ];
    [ def addObject:@(CURVE_1) ];
    [ def addObject:@(CUTTER)];
    [ def addObject:@(CHANGE)];
    
    add = [ [Pitcher alloc] initWithDetails:UOFT with:@"Tanner" with:@"Young-Schultz" with:14 with:RIGHT with:22 with: 187 with:6 with:0 with:def ];
    [ add setID:[database getNewPitcherID] ];
    [ database addPitcher:add ];
#endif
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if( [ [segue destinationViewController] isKindOfClass:[PitcherManagementViewController class] ] )
    {
        PitcherManagementViewController *cont = (PitcherManagementViewController*)[ segue destinationViewController ];
        cont.disable_editing = false;
        cont.seguePitcher = nil;
        cont.currTeamFilter = UOFT;
    }
}

@end
