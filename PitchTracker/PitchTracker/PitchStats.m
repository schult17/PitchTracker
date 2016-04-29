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
        AtPlate *curr = [_at_plates objectAtIndex:0];
        
        //maybe move this to endRecentBatter?
        if( pitch_result == S_SWING || pitch_result == S_LOOK || pitch_result == FOUL )
            _total_strikes += 1;
        else
            _total_balls += 1;
        
        [ curr addPitch:type with:X with:Y with:pitch_result ];
        
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

@end
