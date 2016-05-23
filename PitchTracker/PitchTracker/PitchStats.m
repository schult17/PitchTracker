//
//  PitchStats.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitchStats.h"

#define STRIKES_JSON_KEY @"Strikes"
#define BALLS_JSON_KEY @"Balls"
#define WALKS_JSON_KEY @"Walks"
#define K_JSON_KEY @"Ks"
#define ERROR_JSON_KEY @"Errors"
#define HIT_JSON_KEY @"Hits"
#define ATPLATE_JSON_KEY @"AtPlates"

@implementation PitchStats

@synthesize at_plates = _at_plates;
@synthesize total_strikes = _total_strikes;
@synthesize total_balls = _total_balls;
@synthesize total_pitches = _total_pitches;
@synthesize total_walks = _total_walks;
@synthesize total_k = _total_k;
@synthesize total_hits = _total_hits;
@synthesize total_errors = _total_errors;

//essentially a new pitcher
-(id) init
{
    _at_plates = [[NSMutableArray alloc] init];
    _total_strikes = 0;
    _total_balls = 0;
    _total_pitches = 0;
    _total_walks = 0;
    _total_k = 0;
    
    return self;
}

-(id) initWithJSON:(NSDictionary *)json
{
    self = [ super init ];
    
    _total_walks = 0;
    _total_k = 0;
    _total_errors = 0;
    _total_hits = 0;
    _total_strikes = _total_balls = _total_pitches = 0;
    
    _at_plates = [ [NSMutableArray alloc] init ];
    
    NSArray *atplates_json = [ json objectForKey:ATPLATE_JSON_KEY ];
    for( int i = 0; i < atplates_json.count; i++ )
    {
        AtPlate *ap = [ [AtPlate alloc] initWithJSON:[atplates_json objectAtIndex:i] ];
        
        switch( ap.atbat_result )
        {
            case SO_LOOK:
            case SO_SWING:
                _total_k += 1;
                break;
            case WALK:
            case HBP:
                _total_walks += 1;
                break;
            case ERROR:
                _total_errors += 1;
                break;
            case HIT:
                _total_hits += 1;
                break;
            default:
                break;
        }
        
        _total_strikes += ap.atbat_foul + ap.atbat_strikes;
        _total_balls += ap.atbat_balls;
        _total_pitches += _total_strikes + _total_balls;
        
        [ _at_plates addObject:ap ];
    }
    
    return self;
}

-(void) newBatter:(Hand)batter_hand
{
    [ _at_plates addObject:[[AtPlate alloc] initWithBatter:batter_hand ] ];
}

-(void) addAtPlate:(AtPlate *)result
{
    _total_balls += result.atbat_balls;
    _total_strikes += result.atbat_strikes;
    _total_pitches += result.atbat_pitches.count;
    
    switch( result.atbat_result )
    {
        case SO_LOOK:
        case SO_SWING:
            _total_k += 1;
            break;
        case WALK:
            _total_walks += 1;
            break;
        case HIT:
            _total_hits += 1;
            break;
        default:
            break;
    }
    
    [ _at_plates addObject:result ];
}

-(bool) addPitchToRecentBatter:(PitchTypes) type with:(PitchLocation) X with:(PitchLocation) Y with: (int) balls with:(int) strikes with:(PitchOutcome) pitch_result
{
    if( _at_plates.count > 0 )
    {
        //maybe move this to endRecentBatter?
        if( pitch_result == S_SWING || pitch_result == S_LOOK || pitch_result == FOUL )
            _total_strikes += 1;
        else
            _total_balls += 1;
        
        [ [_at_plates objectAtIndex:0] addPitch:type with:X with:Y with:balls with:strikes with:pitch_result];
        
        return true;
    }
    else
    {
        //no batters availible
        return false;
    }
}

-(bool)endRecentBatter:(AtPlateOutcome)outcome
{
    if( _at_plates.count > 0 )
    {
        switch( outcome )
        {
            case SO_LOOK:
            case SO_SWING:
                _total_k += 1;
                break;
            case HBP:
            case WALK:
                _total_walks += 1;
                break;
            case HIT:
                _total_hits += 1;
                break;
            case ERROR:
                _total_errors += 1;
                break;
            default:
                NSLog( DEBUG_FATAL, @"Unknown end at plate outcome" );
                break;
        }
        
        AtPlate *curr = [_at_plates objectAtIndex:0];
        [ curr endAtPlate:outcome ];
        
        return true;
    }
    else
    {
        //no batters availible
        return false;
    }
}

-(float) getStrikePercentage;
{
    return ( ((float)_total_strikes/(float)_total_pitches) * 100.00 );
}

-(float) getBallPercentage
{
    return ( ((float)_total_balls/(float)_total_pitches) * 100.00 );
}

-(NSArray*) getPitchPercentage
{
    NSMutableArray *pitchs_count = [ NSMutableArray array ];
    for( int i = 0; i < COUNTPITCHES; i++ )
        [ pitchs_count addObject:[ NSNumber numberWithFloat:0 ] ];
    
    NSNumber *temp_count;
    int pitch_index = 0;
    
    for( AtPlate* i in _at_plates )
    {
        for( PitchInstance* inst in i.atbat_pitches )
        {
            pitch_index = pitchTypeToIndex(inst.type);
            temp_count = (NSNumber*)[ pitchs_count objectAtIndex:pitch_index ];
            temp_count = [ NSNumber numberWithFloat:( [temp_count intValue] + 1 ) ];
            [ pitchs_count replaceObjectAtIndex:pitch_index withObject:temp_count ];
        }
    }
    
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        temp_count = (NSNumber*)[ pitchs_count objectAtIndex:i ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] / (float)_total_pitches ) ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] * 100.00) ];
        [ pitchs_count replaceObjectAtIndex:i withObject:temp_count ];
    }
    
    return pitchs_count;
}

-(NSArray*) getFirstPitchPercentage
{
    NSMutableArray *first_pitchs_count = [ [NSMutableArray alloc] initWithCapacity:COUNTPITCHES ];
    for( int i = 0; i < COUNTPITCHES; i++ )
        [ first_pitchs_count addObject:[ NSNumber numberWithFloat:0 ] ];
    
    NSNumber *temp_count;
    PitchInstance *inst;
    int pitch_index = 0;
    
    for( AtPlate* i in _at_plates )
    {
        if( i.atbat_pitches.count > 0 ) //should be true...
        {
            pitch_index = pitchTypeToIndex(inst.type);
            temp_count = (NSNumber*)[ first_pitchs_count objectAtIndex:pitch_index];
            temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] + 1 ) ]; //temp_count ++;
            [ first_pitchs_count replaceObjectAtIndex:pitch_index withObject:temp_count ];
        }
    }
    
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        temp_count = (NSNumber*)[ first_pitchs_count objectAtIndex:i ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] / (float)_at_plates.count ) ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] * 100.00) ];
        [ first_pitchs_count replaceObjectAtIndex:i withObject:temp_count ];
    }
    
    return first_pitchs_count;
}

-(NSArray*) getStrikeoutPitchPercentage
{
    NSMutableArray *pitchs_count = [ [NSMutableArray alloc] initWithCapacity:COUNTPITCHES ];
    for( int i = 0; i < COUNTPITCHES; i++ )
        [ pitchs_count addObject:[ NSNumber numberWithFloat:0 ] ];
    
    NSNumber *temp_count;
    float two_strike_pitch_count = 0;
    int pitch_index = 0;
    
    for( AtPlate* i in _at_plates )
    {
        for( PitchInstance* inst in i.atbat_pitches )
        {
            if( inst.PitchIsWithTwoStrikes )
            {
                pitch_index = pitchTypeToIndex(inst.type);
                temp_count = (NSNumber*)[ pitchs_count objectAtIndex:pitch_index ];
                temp_count = [ NSNumber numberWithFloat:( [temp_count intValue] + 1 ) ];
                [ pitchs_count replaceObjectAtIndex:pitch_index withObject:temp_count ];
                two_strike_pitch_count++;
            }
        }
    }
    
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        temp_count = (NSNumber*)[ pitchs_count objectAtIndex:i ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] / two_strike_pitch_count ) ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] * 100.00) ];
        [ pitchs_count replaceObjectAtIndex:i withObject:temp_count ];
    }
    
    return pitchs_count;
}

-(NSDictionary*) getAsJSON
{
    NSMutableArray* json_array = [ [NSMutableArray alloc] init ];
    for( AtPlate *i in _at_plates )
        [ json_array addObject:i.getAsJSON ];
    
    //re calculate total balls and strikes
    return  [ NSDictionary dictionaryWithObjectsAndKeys:
                    json_array, ATPLATE_JSON_KEY, nil];
}

@end
