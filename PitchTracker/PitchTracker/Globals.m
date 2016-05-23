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
            ret = @"Curve";
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

