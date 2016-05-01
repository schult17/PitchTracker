//
//  PitchInstance.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"

//-----One pitch-----//
@interface PitchInstance : NSObject

@property PitchType type;
@property PitchLocation X;
@property PitchLocation Y;
@property PitchOutcome pitch_result;

-(id)init;
-(id)initWithPitch:(PitchType) type with:(PitchLocation) X with:(PitchLocation)  Y with:(PitchOutcome) pitch_result;
-(void)setPitchPosition:(PitchLocation) X with:(PitchLocation) Y;
-(void)setPitchResult:(PitchOutcome) result;
-(void)setPitchType:(PitchType) type;

@end
//-------------------//

//-----An at plate-----//
@interface AtPlate : PitchInstance

@property NSMutableArray *atbat_pitches;
@property int atbat_strikes;
@property int atbat_foul;
@property int atbat_balls;
@property AtPlateOutcome atbat_result;
@property Hand batter_hand;

-(id) init;
-(id) initWithBatter:(Hand)batter_hand;
-(void) addPitch:(PitchType) type with:(PitchLocation) X with:(PitchLocation) Y with:(PitchOutcome) pitch_result;
-(void) endAtPlate:(AtPlateOutcome) atbat_result;

@end
//-------------------//
