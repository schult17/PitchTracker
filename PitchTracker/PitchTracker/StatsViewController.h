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
#include "SelectableLabel.h"

#define NUMBER_DISPLAY_ROWS 6
#define INFO_LABEL_TEXT_SIZE 25
#define INFO_LABEL_INSET 15
#define FILTER_HEADER_TEXT_SIZE 30
#define NODE_OBJECTS_KEY_IN_TREE @"Objects"

@interface StatsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *teamFilterButton;
@property (strong, nonatomic) IBOutlet PitcherSideScrollView *pitcherScrollView;
@property (strong, nonatomic) IBOutlet UIView *statsView;

@property ZoneView *zoneView;

@property Pitcher *pitcher;
@property TeamNames TeamFilter;
@property StatTypes StatFilters;
@property int countBallsFilter;
@property int countStrikesFilter;
@property PitchTypes PitchFilters;
@property UIActivityIndicatorView *calculatingIndicator;
@property UIPickerView *teamPicker;
@property UILabel *shortNameLabel;

@property UITableView *filterTable;
@property NSArray *arrayOriginal;
@property NSMutableArray *arrayForTable;

-(void) changeTeamFilter:(TeamNames) team;
-(void) changePitcher:(Pitcher *) pitcher;


@end
