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

-(NSString*) getAsString
{
    NSError *error;
    
    NSDictionary* json = [ NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:(int)_X], @"X",
                          [NSNumber numberWithInt:(int)_Y], @"Y",
                          [NSNumber numberWithInt:(int)_type], @"Type",
                          [NSNumber numberWithInt:(int)_pitch_result], @"Result", nil];
    
    //TODO -- get rid of pretty, make it compact
    NSData* json_data = [ NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error ];
    
    //TODO -- do something with error
    return [ [NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding ];
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
@synthesize atbat_date = _atbat_date;
@synthesize batter_hand = _batter_hand;

-(id)init
{
    _atbat_pitches = [[NSMutableArray alloc] init];
    _atbat_strikes = 0;
    _atbat_balls = 0;
    _atbat_foul = 0;
    _atbat_result = SO_LOOK;
    _batter_hand = UNKWN;
    [ self setDate:[NSDate date] ];
    
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
    [ self setDate:[NSDate date] ];
    
    return self;
}

-(void) setDate:(NSDate*)date
{
    _atbat_date = date;
}

-(NSString*) getDateString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [ dateFormatter stringFromDate:_atbat_date ];
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

-(NSString*) getAsString
{
    NSError *error;
    NSMutableArray* json_array = [ [NSMutableArray alloc] init ];
    for( PitchInstance* i in _atbat_pitches )
        [ json_array addObject:i.getAsString ];
    
    NSDictionary* json = [ NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:_atbat_strikes], @"Strikes",
                          [NSNumber numberWithInt:_atbat_balls], @"Balls",
                          [NSNumber numberWithInt:_atbat_foul], @"Foul",
                          [NSNumber numberWithInt:(int)_batter_hand], @"Hand",
                          [NSNumber numberWithInt:(int)_atbat_result], @"Result",
                          json_array, @"Pitches",
                          [ self getDateString ], @"Date", nil];
    
    //TODO get rid of pretty, make it compact
    NSData* json_data = [ NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error ];
    
    return [ [NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding ];
}

@end
//-------------------//
