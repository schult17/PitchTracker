//
//  Pitcher.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "Pitcher.h"

@implementation Pitcher

@synthesize team = _team;
@synthesize first_name = _first_name;
@synthesize last_name = _last_name;
@synthesize jersey_num = _jersey_num;
@synthesize hand = _hand;
@synthesize pitches = _pitches;
@synthesize stats = _stats;

-(id) init
{
    [ self setDetails:@"Toronto" with:@"Tyler" with:@"Durden" with:7 with:SWITCH with:[[NSMutableArray alloc] init] ];
    
    _stats = [[PitchStats alloc] init];         //if we remove *, does alloc go away?
    
    return self;
}

-(id) initWithDetailsStr:(NSString *) team with:(NSString *)first_name with:(NSString *)last_name with:(int)jersey_num with:(Hand)hand with:(NSMutableArray *)pitches
{
    [ self setDetails:team with:first_name with:last_name with:jersey_num with:hand with:pitches ];
    _stats = [[PitchStats alloc] init];         //if we remove *, does alloc go away?
    
    return self;
}

-(id) initWithDetailsNum:(TeamNames)team with:(NSString *)first_name with:(NSString *)last_name with:(int)jersey_num with:(Hand)hand with:(NSMutableArray *)pitches
{
    if( team < TEAMCOUNT )
    {
        [ self setDetails:TEAM_NAMES[team] with:first_name with:last_name with:jersey_num with:hand with:pitches ];
        _stats = [[PitchStats alloc] init];         //if we remove *, does alloc go away?
    }
    else
    {
        NSLog( @"Invalid team number, pitcher not created" );
    }
    
    return self;
}

-(void) setDetails:(NSString *) team with:(NSString *)first_name with:(NSString *)last_name with:(int)jersey_num with:(Hand)hand with:(NSMutableArray *)pitches
{
    _team = team;
    _first_name = first_name;
    _last_name = last_name;
    _jersey_num = jersey_num;
    _hand = hand;
    _pitches = pitches;
}

@end
