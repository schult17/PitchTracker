//
//  InGameViewController.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "PitcherSideScrollView.h"
#import "PitcherInfoView.h"
#import "Pitcher.h"
#import "SelectableLabel.h"
#import "ZoneView.h"
#import "AtPlateInstance.h"
#import "PitchInstance.h"

#define GAME_LABEL_INSET 15
#define DISPLAY_LABEL_HEIGHT 35
#define NUM_LABELS_IN_INFO_VIEW 5
#define NUM_LABELS_IN_GAME_INFO 7
#define FONT_DISPLAY_SIZE DISPLAY_LABEL_HEIGHT - 5
#define BUTTON_COLOUR_CODE [UIColor colorWithRed:0 green:122 blue:255 alpha:1]

@interface InGameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *teamToggleButton;
@property (strong, nonatomic) IBOutlet PitcherSideScrollView *pitcherScrollView;
@property (strong, nonatomic) IBOutlet UIView *zoneTeamView;
@property (strong, nonatomic) IBOutlet UIView *infoView;

//--Pitcher info--//
@property UILabel *teamLabel;
@property UILabel *nameLabel;
@property UILabel *bodyLabel;
@property UILabel *numHandLabel;
@property UIButton *statsButton;
@property NSMutableArray *pitchLabels;
@property UIButton *addPitchButton;
//----------------//

@property ZoneView *zoneView;

//--game info--//
@property TeamNames team1;
@property TeamNames team2;
@property bool team1visible;
@property Pitcher *currPitcher1;
@property Pitcher *currPitcher2;

@property UILabel *team1Label;
@property UILabel *pitch1Label;
@property UILabel *vsLabel;
@property UILabel *team2Label;
@property UILabel *pitch2Label;
@property UILabel *countLabel;
@property UIButton *nextBatterButton;
@property int countStrikes;
@property int countBalls;

@property AtPlate *currAtPlate;
//-------------//

//--Pitch info--//
@property SingleZoneView *selectedView;
@property SelectableLabel *selectedPitchLabel;
@property PitchTypes selectedPitch;
//--------------//

@end
