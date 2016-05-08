//
//  PitcherManagementViewController.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PitcherSideView.h"
#import "PitcherView.h"
#import "PitcherSideScrollView.h"
#import "LocalPitcherDatabase.h"

#define MODE_VIEW 0
#define MODE_NEW 1
#define MODE_EDIT 2

@interface PitcherManagementViewController : UIViewController

@property (strong, nonatomic) IBOutlet PitcherSideScrollView *pitcherScrollView;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIButton *addPitcherButton;

@property (strong, nonatomic) IBOutlet UIPickerView *teamPicker;
@property (strong, nonatomic) IBOutlet PitcherView *pitcherView;

@property TeamNames currTeamFilter;

@property int currViewType;


-(void) addPitchersToScroll;

@end
