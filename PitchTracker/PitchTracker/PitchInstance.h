//
//  PitchInstance.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"

@interface PitchInstance : NSObject

@property PitchTypes type;
@property PitchLocation X;
@property PitchLocation Y;
@property PitchOutcome pitch_result;
@property int count_before_pitch;

-(id)init;
-(id) initWithJSON:(NSDictionary *)json;
-(id)initWithPitch:(PitchTypes) type with:(PitchLocation) X with:(PitchLocation)  Y with:(int)balls with:(int)strikes with:(PitchOutcome) pitch_result;

//Not currently used...
-(void)setPitchPosition:(PitchLocation) X with:(PitchLocation) Y;
-(void)setPitchResult:(PitchOutcome) result;
-(void)setPitchType:(PitchTypes) type;
-(void)setPitchCount:(int)balls with:(int)strikes;
//-------------------//

-(int) PitchCountBalls;
-(int) PitchCountStrikes;
-(bool) PitchIsWithTwoStrikes;

-(NSDictionary *) getAsJSON;

@end
