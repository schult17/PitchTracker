//
//  Globals.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-23.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

//Global helper functions for conversions to do with translation of pitch type to string and index.
NSString* getPitchString(PitchTypes type)
{
    NSString *ret;
    
    switch( type )
    {
        case FASTBALL_4:
            ret = @"Fastball(4)";
            break;
        case FASTBALL_2:
            ret = @"Fastball(2)";
            break;
        case CUTTER:
            ret = @"Cutter";
            break;
        case CURVE_1:
            ret = @"Curve(1)";
            break;
        case CURVE_2:
            ret = @"Curve(2)";
            break;
        case SLIDER:
            ret = @"Slider";
            break;
        case CHANGE:
            ret = @"Changeup";
            break;
        case SPLITTER:
            ret = @"Splitter";
            break;
        default:
            ret = @"Unknown";
            break;
    }
    
    return ret;
}

PitchTypes getPitchTypeFromString(NSString *str)
{
    NSString *cmp_str = [ str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];

    if( [cmp_str caseInsensitiveCompare:@"Fastball(4)"] == NSOrderedSame )
        return FASTBALL_4;
    else if( [cmp_str caseInsensitiveCompare:@"Fastball(2)"] == NSOrderedSame )
        return FASTBALL_2;
    else if( [cmp_str caseInsensitiveCompare:@"Cutter"] == NSOrderedSame )
        return CUTTER;
    else if( [cmp_str caseInsensitiveCompare:@"Curve(1)"] == NSOrderedSame )
        return CURVE_1;
    else if( [cmp_str caseInsensitiveCompare:@"Curve(2)"] == NSOrderedSame )
        return CURVE_2;
    else if( [cmp_str caseInsensitiveCompare:@"Slider"] == NSOrderedSame )
        return SLIDER;
    else if( [cmp_str caseInsensitiveCompare:@"Changeup"] == NSOrderedSame )
        return CHANGE;
    else if( [cmp_str caseInsensitiveCompare:@"Splitter"] == NSOrderedSame )
        return SPLITTER;
    else
        return 0;
}

int pitchTypeToIndex(PitchTypes type)
{
    int ret = 0;
    int type_num = type;
    
    while( type_num != 0 )
    {
        type_num = type_num >> 1;
        
        if( type_num == 0 )
            return ret;
        
        ret++;
    }
    
    NSLog(DEBUG_VERBOSE, @"Could not convert pitch type to integer index, returning 0...");
    
    return 0;
}

//globals for stat filters
StatTypes getFilterTypeFromCellString(NSString *str)
{
    NSString *cmp_str = [ str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    
    if( [cmp_str caseInsensitiveCompare:SWING_MISS_FILTER_STR] == NSOrderedSame )
        return SwingMiss;
    else if( [cmp_str caseInsensitiveCompare:SWING_CONTACT_FILTER_STR] == NSOrderedSame )
        return SwingHit;
    else if( [cmp_str containsString:TOGGLE_COUNT_FILTER_STR] ) //note this is different
        return Count;
    else if( [cmp_str caseInsensitiveCompare:TAKE_FILTER_STR] == NSOrderedSame )
        return Take;
    else if( [cmp_str caseInsensitiveCompare:HIT_FILTER_STR] == NSOrderedSame )
        return Hit;
    else if( [cmp_str caseInsensitiveCompare:WALK_FILTER_STR] == NSOrderedSame )
        return Walk;
    else if( [cmp_str caseInsensitiveCompare:OUT_FILTER_STR] == NSOrderedSame )
        return Out;
    else if( [cmp_str caseInsensitiveCompare:STRIKE_FILTER_STR] == NSOrderedSame )
        return Strike;
    else if( [cmp_str caseInsensitiveCompare:BALL_FILTER_STR] == NSOrderedSame )
        return Ball;
    else if( [cmp_str caseInsensitiveCompare:FOUL_FILTER_STR] == NSOrderedSame )
        return Foul;
    else if( [cmp_str caseInsensitiveCompare:INZONE_FILTER_STR] == NSOrderedSame )
        return InZone;
    else if( [cmp_str caseInsensitiveCompare:OUTZONE_FILTER_STR] == NSOrderedSame )
        return OutZone;
    else
        return NoFilter;   //no filter, unknown, or other filter
}

bool cellIsApplyFiltersButton(NSString *str)
{
    NSString *cmp_str = [ str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ];
    return (  [cmp_str caseInsensitiveCompare:APPLY_FILTERS_STR] == NSOrderedSame );
}

