//
//  SingleZoneView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

#define PERCENTAGE_FONT_SIZE 25

@interface SingleZoneView : UIView

@property ZoneType type;
@property PitchLocation X;
@property PitchLocation Y;
@property bool zoneSelected;
@property UILabel *percentageLabel;

/*
-(id) init;
-(id) initWithFrame:(CGRect)frame;*/
-(id) initWithLocation:(PitchLocation) X with: (PitchLocation) Y with:(bool) perc_visible;
-(void) setFrame:(CGRect)frame;
-(void) toggleZoneSelected;
-(void) setPercentageToDisplay:(CGFloat) perc;

@end
