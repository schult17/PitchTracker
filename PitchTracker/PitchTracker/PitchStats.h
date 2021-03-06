//
//  PitchStats.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PitchInstance.h"
#import "AtPlateInstance.h"
#import "Globals.h"

@interface PitchStats : NSObject

//For a quick overview, we can use balls, strikes and pitches.
//For more in depth view, use pitch_instances
@property NSMutableArray *at_plates;
@property int total_strikes;
@property int total_balls;
@property int total_pitches;
@property int total_walks;  //and HBP
@property int total_k;
@property int total_hits;
@property int total_errors;

-(id) init;
-(id) initWithJSON:(NSDictionary *)json;
-(void) newBatter:(Hand)batter_hand;
-(bool) addPitchToRecentBatter:(PitchTypes) type with:(PitchLocation) X with:(PitchLocation) Y with: (int) balls with:(int) strikes with:(PitchOutcome) pitch_result;
-(void) addAtPlate:(AtPlate *)result;
-(bool) endRecentBatter:(AtPlateOutcome) outcome;

-(float) getStrikePercentage;
-(float) getBallPercentage;
-(NSArray*) getPitchPercentage;
-(NSArray*) getFirstPitchPercentage;
-(NSArray*) getStrikeoutPitchPercentage;

-(NSDictionary*) getAsJSON;

@end
