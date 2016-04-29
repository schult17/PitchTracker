//
//  PitchInstance.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitchInstance.h"


//-----One pitch-----//
@implementation PitchInstance

@synthesize type = _type;
@synthesize X = _X;
@synthesize Y = _Y;
@synthesize pitch_result = _pitch_result;

-(id)init
{
    _type = FASTBALL_4;
    _X = C;
    _Y = C;
    _pitch_result = S_SWING;
    return self;
}

-(id)initWithPitch:(PitchType) type with:(PitchLocation) X with:(PitchLocation) Y with:(PitchOutcome) pitch_result
{
    _type = type;
    _X = X;
    _pitch_result = pitch_result;
    return self;
}

-(void) setPitchPosition:(PitchLocation)X with:(PitchLocation)Y
{
    _X = X;
    _Y = Y;
}

-(void)setPitchResult:(PitchOutcome)result
{
    _pitch_result = result;
}

-(void)setPitchType:(PitchType)type
{
    _type = type;
}

@end
//-------------------//


//-----An at plate-----//
@implementation AtPlate

@synthesize atbat_pitches = _atbat_pitches;
@synthesize atbat_strikes = _atbat_strikes;
@synthesize atbat_balls = _atbat_balls;
@synthesize atbat_foul = _atbat_foul;
@synthesize atbat_result = _atbat_result;
@synthesize batter_hand = _batter_hand;

-(id)init
{
    _atbat_pitches = [[NSMutableArray alloc] init];
    _atbat_strikes = 0;
    _atbat_balls = 0;
    _atbat_foul = 0;
    _atbat_result = SO_LOOK;
    _batter_hand = LEFT;
    
    return self;
}

-(id) initWithBatter:(Hand)batter_hand
{
    _atbat_pitches = [[NSMutableArray alloc] init];
    _atbat_strikes = 0;
    _atbat_balls = 0;
    _atbat_foul = 0;
    _atbat_result = SO_LOOK;
    _batter_hand = batter_hand;
    
    return self;
}

-(void) addPitch:(PitchType)type with:(PitchLocation)X with:(PitchLocation)Y with:(PitchOutcome)pitch_result
{
    if( pitch_result == S_SWING || pitch_result == S_LOOK || pitch_result == FOUL )
    {
        _atbat_strikes += 1;
        
        if( pitch_result == FOUL )
            _atbat_foul += 1;
    }
    else
    {
        _atbat_balls += 1;
    }
    
    [_atbat_pitches addObject: [[PitchInstance alloc] initWithPitch: type with: X with: Y with:pitch_result] ];
}

-(void) endAtPlate:(AtPlateOutcome)atbat_result
{
    _atbat_result = atbat_result;
}

@end
//-------------------//
