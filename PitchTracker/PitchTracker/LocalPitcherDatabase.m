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
@synthesize pitcher_id_count = _pitcher_id_count;

-(id) init
{
    if( self = [ super init ] )
    {
        //-1 is for All Players 'team'
        _team_to_players = [ [NSMutableArray alloc] initWithCapacity:TEAMCOUNT ];
    
        for( int i = 0; i < TEAMCOUNT - 1; i++ )
            [ _team_to_players insertObject:[[NSMutableArray alloc] init] atIndex:i ];
        
        _pitcher_id_count = 1;
    }
    
    return self;
}

-(int) getNewPitcherID
{
    return _pitcher_id_count;   //get the ID for the new pitcher
}

-(NSArray*) getTeamArray: (TeamNames)team
{
    NSAssert(team >= 0 && team < TEAMCOUNT, @"Team name out of range");
    return [ _team_to_players objectAtIndex:team ];
}

-(bool) addPitcher:(Pitcher*)pitcher;
{
    //TODO - check for duplicates
    //Consider only storing PitcherInfo and going to disk to get PitchStats?
    //Second thought - consider making this database a cache for the file system?
    [ [_team_to_players objectAtIndex:pitcher.info.team] addObject:pitcher ];
    
    _pitcher_id_count += 1;
    
    return true;    //success, didn't already exist
}

-(bool) editPitcher:(Pitcher*)pitcher
{
    //TODO - make sure found
    NSMutableArray *pitchers = [ _team_to_players objectAtIndex:pitcher.info.team ];
    
    int replace_index = -1;
    int i = 0;
    for( Pitcher *curr in pitchers )
    {
        //this needs to be changed, what if they want to edit first/last name?
        //consider adding creation tag id for each pitcher
        if( curr.pitcher_id == pitcher.pitcher_id )
        {
            replace_index = i;
            break;
        }
        
        i += 1;
    }
    
    if( replace_index >= 0 )
    {
        [ pitchers replaceObjectAtIndex:replace_index withObject:pitcher ];
        [ _team_to_players replaceObjectAtIndex:pitcher.info.team withObject:pitchers ];
    }
    
    return true;
}

//Singleton access - only one instance of the database
+(id) sharedDatabase
{
    static LocalPitcherDatabase *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(NSArray *) getTeamJSONArray:(TeamNames)team
{
    NSError *error;
    NSMutableArray *json_array = [ [NSMutableArray alloc] init ];
    
    NSArray *pitchers = _team_to_players[team];
    
    for( Pitcher *pitcher in pitchers )
        [ json_array addObject:pitcher.getAsJSONString ];
    
    return json_array;
}

-(void) writeDatabaseToDisk:(NSString *)file_path
{
    NSError *error;
    
    NSMutableDictionary *json = [ [NSMutableDictionary alloc] init ];
    
    //get all the teams JSON arrays
    for( int i = 0; i < TEAMCOUNT; i++ )
        [ json setValue:[self getTeamJSONArray:i] forKey:TEAM_NAME_STR[i] ];
    
    NSData* json_data = [ NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error ];
    
    [ json_data writeToFile:file_path atomically:YES ]; //YES??
}

@end
