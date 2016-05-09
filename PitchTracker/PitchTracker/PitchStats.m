//
//  PitchStats.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitchStats.h"

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

-(void) newBatter:(Hand)batter_hand
{
    [ _at_plates addObject:[[AtPlate alloc] initWithBatter:batter_hand ] ];
}

-(bool) addPitchToRecentBatter:(PitchType)type with:(PitchLocation)X with:(PitchLocation)Y with:(PitchOutcome)pitch_result
{
    if( _at_plates.count > 0 )
    {
        //maybe move this to endRecentBatter?
        if( pitch_result == S_SWING || pitch_result == S_LOOK || pitch_result == FOUL )
            _total_strikes += 1;
        else
            _total_balls += 1;
        
        [ [_at_plates objectAtIndex:0] addPitch:type with:X with:Y with:pitch_result ];
        
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
                NSLog( @"Unknown end at plate outcome" );
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
    return ( (float)_total_strikes/(float)_total_pitches );
}

-(float) getBallPercentage
{
    return ( (float)_total_balls/(float)_total_pitches );
}

-(NSArray*) getPitchPercentage
{
    NSMutableArray *pitchs_count = [ NSMutableArray array ];
    for( int i = 0; i < COUNTPITCHES; i++ )
        [ pitchs_count addObject:[ NSNumber numberWithFloat:0 ] ];
    
    NSNumber *temp_count;
    
    for( AtPlate* i in _at_plates )
    {
        for( PitchInstance* inst in i.atbat_pitches )
        {
            temp_count = (NSNumber*)[ pitchs_count objectAtIndex:inst.type ];
            temp_count = [ NSNumber numberWithFloat:( [temp_count intValue] + 1 ) ];
            [ pitchs_count replaceObjectAtIndex:inst.type withObject:temp_count ];
        }
    }
    
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        temp_count = (NSNumber*)[ pitchs_count objectAtIndex:i ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] / (float)_total_pitches ) ];
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
    
    for( AtPlate* i in _at_plates )
    {
        if( i.atbat_pitches.count > 0 )
        {
            temp_count = (NSNumber*)[ first_pitchs_count objectAtIndex:inst.type ];
            temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] + 1 ) ]; //temp_count ++;
            [ first_pitchs_count replaceObjectAtIndex:inst.type withObject:temp_count ];
        }
    }
    
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        temp_count = (NSNumber*)[ first_pitchs_count objectAtIndex:i ];
        temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] / (float)_at_plates.count ) ];
        [ first_pitchs_count replaceObjectAtIndex:i withObject:temp_count ];
    }
    
    return first_pitchs_count;
}

-(NSArray*) getStrikeoutPitchPercentage
{
    //TODO
    NSMutableArray *pitchs_count = [ [NSMutableArray alloc] initWithCapacity:COUNTPITCHES ];
    return pitchs_count;
}

-(NSString*) getAsJSONString
{
    NSError *error;
    
    NSMutableArray* json_array;
    for( AtPlate *i in _at_plates )
        [ json_array addObject:i.getAsString ];
    
    //total strikes/balls can be re calculated when re opened, saves space
    NSDictionary* json = [ NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:_total_walks], @"Walks",
                          [NSNumber numberWithInt:_total_k], @"K",
                          [NSNumber numberWithInt:_total_errors], @"Errors",
                          [NSNumber numberWithInt:_total_hits], @"Hits",
                          json_array, @"AtPlates", nil];
    
    //TODO get rid of pretty, make it compact
    NSData* json_data = [ NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error ];
    
    return [ [NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding ];
}

@end
