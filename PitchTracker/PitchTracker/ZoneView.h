//
//  StrikeZoneView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "SingleZoneView.h"

#define ZONEDIM 5       //5x5 single zones
#define ZONECOUNT 25

@interface ZoneView : UIView

@property NSMutableArray *zones;
@property int curr_zone_x;
@property int curr_zone_y;
@property bool interaction_enabled;

-(id) init;
-(id) initWithCoder:(NSCoder *)aDecoder;
-(id) initWithFrame:(CGRect)frame;

-(void) setFrame:(CGRect)frame;

-(SingleZoneView *) handleTapInZone:(CGPoint) tap;
-(void) deSelectZone;
-(void) setZoneInteractionEnabled:(bool)enabled;

@end
