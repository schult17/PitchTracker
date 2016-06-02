//
//  PitchStatsFiltered.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-22.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitchStatsFiltered.h"
#import "ZoneView.h"

@implementation PitchStatsFiltered

@synthesize stats = _stats;
@synthesize statsFilters = _statsFilters;
@synthesize pitchFilters = _pitchFilters;
@synthesize countBalls = _countBalls;
@synthesize countStrikes = _countStrikes;

//TODO -- need to deal with count, and new filters

-(id) initWithInfo:(PitchStats*) stats with: (StatTypes) statFilters with:(PitchTypes) pitchFilters
{
    self = [ super init ];
    
    _stats = stats;
    _statsFilters = statFilters;
    _pitchFilters = pitchFilters;
    
    return self;
}

-(NSArray*) getZonePercentages
{
    NSMutableArray *zone_percentages = [ [NSMutableArray alloc] init ];
    for( int i = 0; i < ZONEDIM; i++ )
    {
        NSMutableArray *row = [ [NSMutableArray alloc] init ];
        for( int j = 0; j < ZONEDIM; j++ )
            [ row addObject:[ NSNumber numberWithFloat:0 ] ];
        
        [ zone_percentages addObject:row ];
    }
    
    int total_count = 0;
    NSNumber *temp_count = 0;
    
    for( AtPlate* i in _stats.at_plates )
    {
        for( PitchInstance* inst in i.atbat_pitches )
        {
            if( [self pitchMatchesAllFilters:i with:inst] )
            {
                temp_count =(NSNumber *)[ [zone_percentages objectAtIndex:inst.X] objectAtIndex:inst.Y ];
                temp_count = [ NSNumber numberWithFloat:( [temp_count floatValue] + 1 ) ];
                [ [zone_percentages objectAtIndex:inst.X] replaceObjectAtIndex:inst.Y withObject:temp_count ];
                total_count++;
            }
        }
    }
    
    for( int i = 0; i < ZONEDIM; i++ )
    {
        for( int j = 0; j < ZONEDIM; j++ )
        {
            temp_count =(NSNumber *)[ [zone_percentages objectAtIndex:i] objectAtIndex:j ];
            temp_count = [ NSNumber numberWithFloat:( ([temp_count floatValue] / (float)total_count)*100 )];
            [ [zone_percentages objectAtIndex:i] replaceObjectAtIndex:j withObject:temp_count ];
        }
    }
    
    return zone_percentages;
}

//----------Locals----------//
-(bool) pitchMatchesAllFilters:(AtPlate *) ap with:(PitchInstance *) pitch
{
    bool ret = ((pitch.type & _pitchFilters) && [self pitchInfoMatchesFilters:pitch]);
    ret = ( (ret && [self pitchMatchesCountFilter:pitch]) || [self pitchMatchesAtPlateFilter:ap with:pitch] );
    
    return ret;
}

-(bool) pitchInfoMatchesFilters:(PitchInstance *)pitch
{
    if( [self pitchInZone:pitch.X with:pitch.Y] )
        return ([self pitchResultMatchesFilters:pitch.pitch_result] && (_statsFilters & InZone));
    else
        return ([self pitchResultMatchesFilters:pitch.pitch_result] && (_statsFilters & OutZone));
    
    return true;
}

-(bool) pitchMatchesAtPlateFilter:(AtPlate *)ap with:(PitchInstance *)pi
{
    bool ret = (pi.pitch_result == INPLAY);
    
    ret = ret || ((ap.atbat_result == HIT) && (_statsFilters & Hit));
    ret = ret || ((ap.atbat_result == WALK) && (_statsFilters & Walk));
    ret = ret || ((ap.atbat_result == HIT) && (_statsFilters & Walk));
    
    return ret;
}

-(bool) pitchResultMatchesFilters:(PitchOutcome) result
{
    bool ret = ( (result == S_SWING) && (_statsFilters & SwingMiss) );
    ret = ret || ( (result == S_LOOK) && (_statsFilters & Take) );
    ret = ret || ( (result == S_SWING || result == S_LOOK || result == FOUL) && (_statsFilters & Strike) );
    ret = ret || ( (result == BALL ) && (_statsFilters & Ball) );
    ret = ret || ( (result == BALL) && (_statsFilters & Take) );
    ret = ret || ( (result == INPLAY) && (_statsFilters & SwingHit) );
    ret = ret || ( (result == FOUL) && (_statsFilters & SwingHit) );

    return ret;
}

-(bool) pitchMatchesCountFilter:(PitchInstance *) pitch
{
    bool ret = (pitch.PitchCountBalls == _countBalls) && (pitch.PitchCountStrikes == _countStrikes);
    ret = ret || !(_statsFilters & Count);  //not filtering by count? Return true
    
    return ret;
}

-(bool) pitchInZone:(PitchLocation) X with: (PitchLocation) Y
{
    return ( X > A && X < E && Y > A && Y < E );
}
//--------------------------//

@end
