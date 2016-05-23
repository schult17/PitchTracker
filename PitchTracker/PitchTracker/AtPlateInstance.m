//
//  AtPlateInstance.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-22.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "AtPlateInstance.h"
#import "PitchInstance.h"

#define STRIKES_JSON_KEY @"Strikes"
#define BALLS_JSON_KEY @"Balls"
#define FOUL_JSON_KEY @"Foul"
#define BATTER_HAND_JSON_KEY @"BatterHand"
#define RESULT_JSON_KEY @"Result"
#define DATE_JSON_KEY @"Date"
#define PITCHES_JSON_KEY @"Pitches"
#define DATE_FORMAT_STR @"yyyy-MM-dd"

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

-(id) initWithJSON:(NSDictionary *)json
{
    self = [ super init ];
    
    //I guess we don't need to save at bat strikes/balls/foul? They can be re calculated too...
    _atbat_strikes = 0;
    _atbat_balls = 0;
    _atbat_foul = 0;
    _batter_hand = [ [json objectForKey:BATTER_HAND_JSON_KEY] intValue ];
    _atbat_result = [ [json objectForKey:RESULT_JSON_KEY] intValue ];
    _atbat_pitches = [ [NSMutableArray alloc] init ];
    
    NSDateFormatter *df = [ [NSDateFormatter alloc] init ];
    [ df setDateFormat:DATE_FORMAT_STR ];
    _atbat_date = [ df dateFromString:[ json objectForKey:DATE_JSON_KEY ] ];
    
    NSArray *atbat_pitches = [ json objectForKey:PITCHES_JSON_KEY ];
    
    PitchInstance *pitch = nil;
    for( int i = 0; i < atbat_pitches.count; i++ )
    {
        pitch = [ [PitchInstance alloc] initWithJSON:[atbat_pitches objectAtIndex:i ] ];
        
        switch( pitch.pitch_result )
        {
            case S_LOOK:
            case S_SWING:
                _atbat_strikes += 1;
                break;
            case FOUL:
                _atbat_foul += 1;
                break;
            case BALL:
                _atbat_balls += 1;
                break;
            default:
                break;
        }
        
        [ _atbat_pitches addObject:pitch ];
    }
    
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
    [dateFormatter setDateFormat:DATE_FORMAT_STR];
    return [ dateFormatter stringFromDate:_atbat_date ];
}

-(void) addPitch:(PitchTypes) type with:(PitchLocation) X with:(PitchLocation) Y with:(int) balls with: (int) strikes with:(PitchOutcome) pitch_result
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
    
    [_atbat_pitches addObject: [[PitchInstance alloc] initWithPitch:type with:X with:Y with:balls with:strikes with:pitch_result] ];
}

-(void) endAtPlate:(AtPlateOutcome)atbat_result
{
    _atbat_result = atbat_result;
}

-(NSDictionary*) getAsJSON
{
    NSMutableArray* json_array = [ [NSMutableArray alloc] init ];
    for( PitchInstance* i in _atbat_pitches )
        [ json_array addObject:i.getAsJSON ];
    
    return  [ NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithInt:(int)_batter_hand], BATTER_HAND_JSON_KEY,
             [NSNumber numberWithInt:(int)_atbat_result], RESULT_JSON_KEY,
             [ self getDateString ], DATE_JSON_KEY,
             json_array, PITCHES_JSON_KEY, nil];
}

@end
