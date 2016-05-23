//
//  PitchInstance.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitchInstance.h"

#define X_JSON_KEY @"X"
#define Y_JSON_KEY @"Y"
#define TYPE_JSON_KEY @"Type"
#define COUNT_JSON_KEY @"Count"
#define PITCH_RESULT_JSON_KEY @"PitchResult"

#define COUNT_MASK 0x03
#define STRIKE_MASK COUNT_MASK
#define BALL_MASK (COUNT_MASK << 2)

@implementation PitchInstance

@synthesize type = _type;
@synthesize X = _X;
@synthesize Y = _Y;
@synthesize pitch_result = _pitch_result;
@synthesize count_before_pitch = _count_before_pitch;

-(id)init
{
    _type = FASTBALL_4;
    _X = C;
    _Y = C;
    _pitch_result = S_SWING;
    _count_before_pitch = 0;
    return self;
}

-(id) initWithJSON:(NSDictionary *)json
{
    self = [ super init ];
    
    _X = [ [json objectForKey:X_JSON_KEY] intValue ];
    _Y = [ [json objectForKey:Y_JSON_KEY] intValue ];
    _type = [ [json objectForKey:TYPE_JSON_KEY] intValue ];
    _count_before_pitch = [ [json objectForKey:COUNT_JSON_KEY] intValue ];
    _pitch_result = [ [json objectForKey:PITCH_RESULT_JSON_KEY] intValue ];
    
    return self;
}

-(id)initWithPitch:(PitchTypes) type with:(PitchLocation) X with:(PitchLocation)  Y with:(int)balls with:(int)strikes with:(PitchOutcome) pitch_result;
{
    _type = type;
    _X = X;
    _Y = Y;
    _pitch_result = pitch_result;
    [ self setPitchCount:balls with:strikes ];
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

-(void)setPitchType:(PitchTypes)type
{
    _type = type;
}

-(void)setPitchCount:(int)balls with:(int)strikes
{
    _count_before_pitch = ((balls & COUNT_MASK) << 2) | (strikes & COUNT_MASK);
}

-(int) PitchCountBalls
{
    return ( (_count_before_pitch & BALL_MASK) >> 2 );
}

-(int) PitchCountStrikes
{
    return ( _count_before_pitch & STRIKE_MASK );
}

-(bool) PitchIsWithTwoStrikes
{
    return ( [self PitchCountStrikes] == 2 );
}

-(NSDictionary*) getAsJSON
{
    return [ NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:(int)_X], X_JSON_KEY,
                    [NSNumber numberWithInt:(int)_Y], Y_JSON_KEY,
                    [NSNumber numberWithInt:(int)_type], TYPE_JSON_KEY,
                    [NSNumber numberWithInt:_count_before_pitch], COUNT_JSON_KEY,
                    [NSNumber numberWithInt:(int)_pitch_result], PITCH_RESULT_JSON_KEY, nil];
}

@end
