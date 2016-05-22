//
//  StatsViewController.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "PitcherSideScrollView.h"
#import "Pitcher.h"
#import "ZoneView.h"

typedef enum _StatTypes
{
    Count = 1 << 0,
    InZone = 1 << 2,
    OutZone = 1 << 3,
    SwingMiss = 1 << 4,
    SwingHit = 1 << 5,
    Take = 1 << 6,
    Pitch = 1 << 7,
    FollowUp = 1 << 7
} StatTypes;

@interface StatsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *teamFilterButton;
@property (strong, nonatomic) IBOutlet PitcherSideScrollView *pitcherScrollView;
@property (strong, nonatomic) IBOutlet UIView *statsView;

@property Pitcher *pitcher;
@property TeamNames TeamFilter;
@property StatTypes StatFilters;
@property UIActivityIndicatorView *calculatingIndicator;
@property UIPickerView *teamPicker;

-(void) changeTeamFilter:(TeamNames) team;
-(void) changePitcher:(Pitcher *) pitcher;

@end
