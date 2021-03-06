//
//  PitcherView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PitcherStatsView.h"
#import "PitcherInfoView.h"
#import "EditPitcherView.h"
#import "Globals.h"
#import "Pitcher.h"

@interface PitcherView : UIView

@property PitcherInfoView *info_view;
@property EditPitcherView *arm_view;
@property PitcherStatsView *stats_view;
@property Pitcher* pitcher;
@property UILabel *editButton;
@property UIButton *advancedStatsButton;

-(id) init;
-(id) initWithCoder:(NSCoder *)aDecoder;
-(id) initWithPlayer:(Pitcher*)pitcher;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher;
-(void) changePitcher:(Pitcher*)pitcher;
-(void) setPitcherViews: (Pitcher*)pitcher;
-(void) setBackground;
-(void) switchToNewPitcher;
-(void) cancelNewEditPitcherView;
-(void) switchToEditPitcher;

-(bool) clickInsideEdit:(CGPoint)tap;
-(void) layoutView;

@end
