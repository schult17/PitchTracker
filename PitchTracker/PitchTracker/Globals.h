//
//  Globals.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#ifndef Globals_h
#define Globals_h

//debug levels
#define DEBUG_VERBOSE 3
#define DEBUG_NORMAL 2
#define DEBUG_FATAL 1
#define DEBUG_SILENT 0

//setting debug level
#define __DEBUGLEVEL__ DEBUG_NORMAL

//#define RESET_DEFAULT_PITCHER

//overriding NSLog

//-----team names-----//
static NSString * const TEAM_NAME_STR[] = {
    [0] = @"Toronto",
    [1] = @"Brock",
    [2] = @"Western",
    [3] = @"York",
    [4] = @"Ryerson",
    [5] = @"Queens",
    [6] = @"Laurier",
    [7] = @"Waterloo",
    [8] = @"Guelph",
    [9] = @"McMaster"
};

typedef enum _TeamNames //indices
{
    UOFT,
    BROCK,
    WESTERN,
    YORK,
    RYERSON,
    QUEENS,
    LAURIER,
    WATERLOO,
    GUELPH,
    MCMASTER,
    TEAMCOUNT
} TeamNames;
//--------------------//

//pitch types
typedef enum _PitchType
{
    FASTBALL_4, //4 seam fastball
    FASTBALL_2, //2 seam fastball (sinker)
    CUTTER,     //Cut fastball
    CURVE_1,    //Curveball
    CURVE_2,    //Second curveball (in case they have 2)
    SLIDER,     //Slider
    CHANGE,     //Changeup
    SPLITTER,   //Splitter/Forkball
    COUNTPITCHES
}PitchType;
//--------------------//

//Pitchers handedness
typedef enum _Hand
{
    LEFT,
    RIGHT,
    SWITCH,
    UNKWN
}Hand;
//--------------------//


//Grid format, XY -> X = column, Y = row
//AY, EY, XA, XE are always balls
typedef enum _PitchLocation
{
    A,
    B,
    C,
    D,
    E
}PitchLocation;

typedef enum _ZoneType
{
    STRIKE_ZONE,
    BALL_ZONE
}ZoneType;

//outcome of a pitch
typedef enum _PitchOutcome
{
    S_SWING,
    S_LOOK,
    FOUL,
    BALL
}PitchOutcome;

//outcome of an atbat (pitch sequence)
typedef enum _AtPlateOutcome
{
    SO_LOOK,
    SO_SWING,
    WALK,
    ERROR,
    HIT,
    PITCH_CHANGE,
    HBP     //deprecated
}AtPlateOutcome;

#endif /* Globals_h */
