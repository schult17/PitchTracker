//
//  PitcherStatsView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "PitchStats.h"

#define SIDE_BUF 10
#define TOP_BUF 10

@interface PitcherStatsView : UIView

@property PitchStats *stats;
@property UILabel *displayStatsLabel;

-(id) init;
-(id) initWithPitchStats:(PitchStats*)stats;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndPlayerStats:(CGRect)frame with: (PitchStats*)stats;
-(void) initDisplay:(PitchStats*)stats;
-(void) changePitcherStats:(PitchStats*) stats;
-(void) fillStatsFields;
-(void) setFrame:(CGRect)frame;

-(NSString*) getFormattedDisplayString;

@end
