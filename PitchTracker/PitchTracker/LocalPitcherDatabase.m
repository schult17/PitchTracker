//
//  LocalPitcherDatabase.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "LocalPitcherDatabase.h"

@implementation LocalPitcherDatabase
@synthesize team_to_players = _team_to_players;

-(id) init
{
    if( self = [ super init ] )
    {
        //-1 is for All Players 'team'
        _team_to_players = [ [NSMutableArray alloc] initWithCapacity:TEAMCOUNT ];
    
        for( int i = 0; i < TEAMCOUNT - 1; i++ )
            [ _team_to_players insertObject:[[NSMutableArray alloc] init] atIndex:i ];
    }
    
    return self;
}

-(NSArray*) getTeamArray: (TeamNames)team
{
    NSAssert(team >= 0 && team < TEAMCOUNT, @"Team name out of range");
    return [ _team_to_players objectAtIndex:team ];
}

-(bool) addPitcher:(Pitcher*)pitcher;
{
    //TODO - check for duplicates
    [ [_team_to_players objectAtIndex:pitcher.info.team] addObject:pitcher ];
    
    return true;    //success, didn't already exist
}

-(bool) editPitcher:(Pitcher*)pitcher
{
    //TODO
    return true;
}

+(id) sharedDatabase
{
    static LocalPitcherDatabase *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
