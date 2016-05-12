//
//  PitcherSideScrollView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PitcherSideView.h"
#import "LocalPitcherDatabase.h"

#define PLAYERVIEW_HEIGHT 80
#define SELECTED_COLOUR blackColor

@interface PitcherSideScrollView : UIScrollView

@property TeamNames curr_team;
@property UIColor *normalColour;
@property int tappedIndex;
@property NSMutableArray *pitcherViews;

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithCoder:(NSCoder *)aDecoder;
-(void) changeTeam: (TeamNames) team;
-(void) clearContents;
-(void) addPitchersToView: (NSArray *) pitchers;
-(Pitcher*) findPitcherFromTouch:(CGPoint)tap;
-(void) setBackgroundColor:(UIColor *)backgroundColor;

@end
