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
#import "ZoneView.h"

#define DISPLAY_LABEL_BUFFER 10
#define DISPLAY_LABEL_HEIGHT 30
#define NUM_LABELS_IN_INFO_VIEW 6

@interface InGameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *teamToggleButton;
@property (strong, nonatomic) IBOutlet PitcherSideScrollView *pitcherScrollView;
@property (strong, nonatomic) IBOutlet UIView *zoneTeamView;
@property (strong, nonatomic) IBOutlet UIView *infoView;

@property UILabel *teamLabel;
@property UILabel *nameLabel;
@property UILabel *bodyLabel;
@property UILabel *numHandLabel;
@property UILabel *pitchesLabel;
@property UIButton *statsButton;

@property TeamNames team1;
@property TeamNames team2;
@property bool team1visible;
@property Pitcher *currPitcher1;
@property Pitcher *currPitcher2;

@property ZoneView *zoneView;

@end
