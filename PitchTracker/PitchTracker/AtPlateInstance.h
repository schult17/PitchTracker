//
//  AtPlateInstance.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-22.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"
#import "PitchInstance.h"

@interface AtPlate : NSObject

@property NSMutableArray *atbat_pitches;
@property int atbat_strikes;
@property int atbat_foul;
@property int atbat_balls;
@property AtPlateOutcome atbat_result;
@property Hand batter_hand;
@property NSDate *atbat_date;

-(id) init;
-(id) initWithJSON:(NSDictionary *)json;
-(id) initWithBatter:(Hand)batter_hand;
-(void) addPitch:(PitchTypes) type with:(PitchLocation) X with:(PitchLocation) Y with:(int) balls with: (int) strikes with:(PitchOutcome) pitch_result;
-(void) endAtPlate:(AtPlateOutcome) atbat_result;

-(NSDictionary *) getAsJSON;

@end
