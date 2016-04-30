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

@interface PitcherSideView : UIView

@property Pitcher *pitcher;
@property UILabel *team_label;
@property UILabel *name_label;

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher;
-(void) updatePitcher:(Pitcher*)pitcher;
-(void) setLabels;
-(void) updateLabelText;

@end
