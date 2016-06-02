//
//  Globals.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#ifndef Globals_h
#define Globals_h

#import <Foundation/Foundation.h>

//#define RESET_DEFAULT_PITCHER

//debug levels
#define DEBUG_VERBOSE 3
#define DEBUG_NORMAL 2
#define DEBUG_FATAL 1
#define DEBUG_SILENT 0

//setting debug level
#define __DEBUGLEVEL__ DEBUG_NORMAL

#define NICE_BUTTON_COLOUR [UIColor colorWithRed:0 green:122 blue:255 alpha:1]

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
    FASTBALL_4 = 1 << 0, //4 seam fastball
    FASTBALL_2 = 1 << 1, //2 seam fastball (sinker)
    CUTTER = 1 << 2,     //Cut fastball
    CURVE_1 = 1 << 3,    //Curveball
    CURVE_2 = 1 << 4,    //Second curveball (in case they have 2)
    SLIDER = 1 << 5,     //Slider
    CHANGE = 1 << 6,     //Changeup
    SPLITTER = 1 << 7,   //Splitter/Forkball
    COUNTPITCHES = 8
}PitchTypes;

#define ALL_PITCHES_FILTER (FASTBALL_4 | FASTBALL_2 | CUTTER | CURVE_1 | CURVE_2 | SLIDER | CHANGE | SPLITTER)

NSString* getPitchString(PitchTypes type);
PitchTypes getPitchTypeFromString(NSString *str);
int pitchTypeToIndex(PitchTypes type);
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
    BALL,
    FOUL,
    INPLAY
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
    HBP     //deprecated (just a walk now)
}AtPlateOutcome;


//----------------------------------------------//
#define APPLY_FILTERS_STR @"Apply Filters"

//Pitch Result filter strings
#define SWING_MISS_FILTER_STR @"Swing and Miss"
#define SWING_CONTACT_FILTER_STR @"Swing and Contact"
#define TAKE_FILTER_STR @"Take"
#define HIT_FILTER_STR @"Hit"
#define OUT_FILTER_STR @"Out"
#define WALK_FILTER_STR @"Walk"

//Pitch call filter strings
#define STRIKE_FILTER_STR @"Strike"
#define BALL_FILTER_STR @"Ball"
#define FOUL_FILTER_STR @"Foul"

//Pitch location filter strings
#define INZONE_FILTER_STR @"In Strike Zone (Red)"
#define OUTZONE_FILTER_STR @"Out of Strike Zone (Blue)"

//Filter header labels
#define PITCH_TYPE_FILTER_STR @"+ Pitch Type"

#define TOGGLE_COUNT_FILTER_STR @"Count Filter:"

#define BALLS_COUNT_SUBSTRING @"Balls"
#define STRIKES_COUNT_SUBSTRING @"Strikes"
#define OFF_SUBSTRING @"OFF"
#define ON_SUBSTRING @"ON"

//Stat type filters (bit shift is for masking multiple in)
typedef enum _StatTypes
{
    NoFilter = 0,
    Count = 1 << 0,
    InZone = 1 << 2,
    OutZone = 1 << 3,
    SwingMiss = 1 << 4,
    SwingHit = 1 << 5,
    Take = 1 << 6,
    Foul = 1 << 7,
    Strike = 1 << 8,
    Ball = 1 << 9,
    Hit = 1 << 10,
    Out = 1 << 11,
    Walk = 1 << 12,
    Pitch = 1 << 13,
} StatTypes;

#define DEFAULT_STATS_FILTERS InZone | OutZone | SwingMiss | SwingHit | Strike | Ball | Hit | Out | Walk

bool cellIsApplyFiltersButton(NSString *str);
StatTypes getFilterTypeFromCellString(NSString *str);
//-------------------------------------------------------//

#endif /* Globals_h */
