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

#define SELECTED_COLOUR blackColor

typedef enum _ScrollTouchLocation
{
    IN_PITCHER,
    IN_PITCHER_DELETE,
    OUTSIDE_PITCHERS
}ScrollTouchLocation;

@interface PitcherSideScrollView : UIScrollView <UIScrollViewDelegate>

@property TeamNames curr_team;
@property UIColor *normalColour;
@property int tappedIndex;
@property NSMutableArray *pitcherViews;
@property CGPoint scrollPointStart;
@property CGPoint scrollPointEnd;
@property ScrollTouchLocation lastTouchLocation;

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithCoder:(NSCoder *)aDecoder;
-(void) changeTeam: (TeamNames) team;
-(void) clearContents;
-(void) addPitchersToView: (NSArray *) pitchers;
-(Pitcher*) findPitcherFromTouch:(CGPoint)tap;
-(void) setBackgroundColor:(UIColor *)backgroundColor;
-(void) highlightPitcher:(int)pitcher_id;

@end
