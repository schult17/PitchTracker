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

@interface PitcherStatsView : UIScrollView

@property PitchStats *stats;
//Tables and labels and shit to fill with stats

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndPlayerStats:(CGRect)frame with: (PitchStats*)stats;
-(void) changePitcherStats:(PitchStats*) stats;
-(void) fillStatsFields;

@end
