//
//  PitcherInfo.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherInfo.h"

@implementation PitcherInfo

@synthesize team = _team;
@synthesize first_name = _first_name;
@synthesize last_name = _last_name;
@synthesize jersey_num = _jersey_num;
@synthesize hand = _hand;
@synthesize age = _age;
@synthesize weight = _weight;
@synthesize height_f = _height_f;
@synthesize height_i = _height_i;
@synthesize pitches = _pitches;

-(id) init
{
    NSMutableArray *def = [ [NSMutableArray alloc] init ];
    
    [ def addObject:@(FASTBALL_4) ];
    [ def addObject:@(CURVE_1) ];
    [ def addObject:@(CHANGE)];
    [ self setDetails:UOFT with:@"Tyler" with:@"Durden" with:7 with:SWITCH with: 19 with: 200 with: 6 with: 1 with: def];
    
    return self;
}

-(id) initWithDetails:(TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;
{
    [ self setDetails:team with:first_name with:last_name with:jersey_num with:hand with:age with:weight with:height_f with:height_i with:pitches ];
    
    return self;
}

-(void) setDetails:(TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;
{
    _team = team;
    _first_name = first_name;
    _last_name = last_name;
    _jersey_num = jersey_num;
    _hand = hand;
    _age = age;
    _weight = weight;
    _height_f = height_f;
    _height_i = height_i;
    _pitches = pitches;
}

-(NSString *) getShortDisplayString
{
    NSString *ret = [ [NSString alloc] initWithString:self.last_name ];
    ret = [ ret stringByAppendingString:@", " ];
    ret = [ ret stringByAppendingString:[_first_name substringWithRange:NSMakeRange(0, 1)] ];   //first initial
    ret = [ ret stringByAppendingString:[NSString stringWithFormat:@" - #%i, %@", self.jersey_num, [self getHandString:_hand] ] ];
    
    return ret;
}

-(NSString*) getTeamDisplayString
{
    return TEAM_NAME_STR[_team];
}

-(NSString*) getNameDisplayString
{
    return [ [NSString alloc] initWithString:[ NSString stringWithFormat:@"%@ %@", _first_name, _last_name ] ];
}

-(NSString*) getNumberHandDisplayString;
{
    return [ [NSString alloc] initWithString:[ NSString stringWithFormat:@"#%i - %@", _jersey_num, [ self getHandString:_hand ] ] ];
}

-(NSString*) getHandString:(Hand)hand
{
    NSString *ret;
    
    switch( hand )
    {
        case LEFT:
            ret = @"Left";
            break;
        case RIGHT:
            ret = @"Right";
            break;
        case SWITCH:
            ret = @"Switch";
            break;
        default:
            ret = @"Uknown?";
            break;
    }
    
    return ret;
}

-(NSString*) getPhysicalDisplayString
{
    return [ [NSString alloc] initWithString:[ NSString stringWithFormat:@"%i yrs - %i'%i\" - %i lbs", _age, _height_f, _height_i, _weight ] ];
}

-(NSString*) getPitchDisplayString;
{
    NSString *ret = [ [NSString alloc] init ];
    
    for( int i = 0; i < _pitches.count; i++ )
    {
        ret = [ ret stringByAppendingString:[self getPitchString:[_pitches[i] intValue]] ];
        
        if( i != _pitches.count - 1 )
            ret = [ ret stringByAppendingString:@" - " ];
    }
    
    return ret;
}

-(NSString*) getAsJSONString
{
    NSError *error;
    
    NSMutableArray* json_array;
    for( int i = 0; i < _pitches.count; i++ )
        [ json_array addObject:[self getPitchString:(PitchType)_pitches[i]] ];
    
    
    //total strikes/balls can be re calculated when re opened, saves space
    NSDictionary* json = [ NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:(int)_team], @"TeamID",
                          _first_name, @"First",
                          _last_name, @"Last",
                          [NSNumber numberWithInt:_jersey_num], @"Number",
                          [NSNumber numberWithInt:(int)_hand], @"Hand",
                          [NSNumber numberWithInt:_age], @"Age",
                          [NSNumber numberWithInt:_weight], @"Weight",
                          [NSNumber numberWithInt:_height_f], @"HeightF",
                          [NSNumber numberWithInt:_height_i], @"HeightI",
                          json_array, @"Pitches", nil];
    
    //TODO get rid of pretty, make it compact
    NSData* json_data = [ NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error ];
    
    return [ [NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding ];
}

-(NSString*) getPitchString:(PitchType)type
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

@end
