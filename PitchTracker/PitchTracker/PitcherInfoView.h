//
//  PitcherInfoView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "Pitcher.h"

#define SIDE_BUFFER 10
#define TOP_BUFFER 20

@interface PitcherInfoView : UIView

@property PitcherInfo *info;

@property UILabel *displayInfoLabel;

-(id) init;
-(id) initWithPlayer:(PitcherInfo*) info;
-(id) initWithFrame:(CGRect)frame;
-(id) initWithFrameAndPlayerInfo:(CGRect)frame with: (PitcherInfo*)info;
-(void) broadInit:(PitcherInfo*)info;
-(void) changePitcherInfo:(PitcherInfo*)info;
-(void) fillInfo;
-(void) setFrame:(CGRect)frame;

-(NSString *) percentageArrayToDisplayString:(NSArray*) array;
-(NSString *) getPitchPercentageString;
-(NSString *) getFirstPitchPercentageString;
-(NSString *) getStrikeOutPitchPercentage;

@end
