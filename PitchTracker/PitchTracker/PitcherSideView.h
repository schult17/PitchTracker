//
//  PitcherView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "Pitcher.h"

#define PLAYERVIEW_HEIGHT 100

#define TEXT_INSET 10
#define DEL_BUTTON_DIM PLAYERVIEW_HEIGHT
#define DEL_BUTTON_TEXT_SIZE 25

@interface PitcherSideView : UIScrollView

@property Pitcher *pitcher;
@property UILabel *team_label;
@property UILabel *name_label;

//-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher;
-(void) updatePitcher:(Pitcher*)pitcher;
-(void) setLabels;
-(void) updateLabelText;
-(bool) touchInsideDelete:(CGPoint) tap;

@end
