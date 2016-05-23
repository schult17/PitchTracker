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

#define NUMBER_DISPLAY_ROWS 5
#define INFO_LABEL_TEXT_SIZE 25
#define INFO_LABEL_INSET 15

@interface StatsViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *teamFilterButton;
@property (strong, nonatomic) IBOutlet PitcherSideScrollView *pitcherScrollView;
@property (strong, nonatomic) IBOutlet UIView *statsView;

@property ZoneView *zoneView;

@property Pitcher *pitcher;
@property TeamNames TeamFilter;
@property StatTypes StatFilters;
@property UIActivityIndicatorView *calculatingIndicator;
@property UIPickerView *teamPicker;

@property UILabel *shortNameLabel;

@property UILabel *filtersHeaderLabel;
@property UIButton *resetDefaultFiltersButton;
@property SelectableLabel *inZoneFilter;
@property SelectableLabel *outZoneFilter;
@property SelectableLabel *swingMissFilter;
@property SelectableLabel *swingHitFilter;
@property SelectableLabel *takeFilter;
@property SelectableLabel *pitchFilter;
@property UILabel *pitchLabel;
@property SelectableLabel *followUpFilter;
@property UILabel *followUpPitch;

-(void) changeTeamFilter:(TeamNames) team;
-(void) changePitcher:(Pitcher *) pitcher;

@end
