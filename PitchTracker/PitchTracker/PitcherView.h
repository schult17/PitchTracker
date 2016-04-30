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
#import "Globals.h"
#import "Pitcher.h"

@interface PitcherView : UIView

@property PitcherInfoView *info_view;
@property PitcherStatsView *stats_view;

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher;
-(void) changePitcher:(Pitcher*)pitcher;
-(void) setPitcherViews: (Pitcher*)pitcher;
-(void) setBackground;

@end
