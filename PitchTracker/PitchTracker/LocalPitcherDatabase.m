//
//  LocalPitcherDatabase.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "LocalPitcherDatabase.h"

@implementation LocalPitcherDatabase
@synthesize team_to_pitchers = _team_to_pitchers;
@synthesize next_pitcher_id = _next_pitcher_id;

-(id) init
{
    if( self = [ super init ] )
    {
        _team_to_pitchers = [ [NSMutableArray alloc] initWithCapacity:TEAMCOUNT ];
    
        for( int i = 0; i < TEAMCOUNT; i++ )
            [ _team_to_pitchers insertObject:[[NSMutableArray alloc] init] atIndex:i ];
        
        _next_pitcher_id = 1;
    }
    
    return self;
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

-(unsigned int) getNewPitcherID
{
    return _next_pitcher_id;   //get the ID for the new pitcher
}

-(NSArray*) getTeamArray: (TeamNames)team
{
    NSAssert(team >= 0 && team < TEAMCOUNT, @"Team name out of range");
    return [ _team_to_pitchers objectAtIndex:team ];
}

-(bool) addPitcher:(Pitcher*)pitcher;
{
    //Consider only storing PitcherInfo and going to disk to get PitchStats?
    //Second thought - consider making this database a cache for the file system?
    [ [_team_to_pitchers objectAtIndex:pitcher.info.team] addObject:pitcher ];
    
    _next_pitcher_id += 1;
    
    return true;    //success, didn't already exist
}

-(bool) editPitcher:(Pitcher*)pitcher
{
    NSMutableArray *pitchers = [ _team_to_pitchers objectAtIndex:pitcher.info.team ];
    
    int replace_index = -1;
    int i = 0;
    for( Pitcher *curr in pitchers )
    {
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
        [ _team_to_pitchers replaceObjectAtIndex:pitcher.info.team withObject:pitchers ];
        return true;
    }
    else
    {
        return false;
    }
}

-(void) deletePitcher:(Pitcher *)pitcher;
{
    if( pitcher != nil )
    {
        NSArray *team_pitchers = [ self getTeamArray:pitcher.info.team ];
        
        //find the index of the pitcher to delete on this team
        int index = 0;
        for( Pitcher *i in team_pitchers )
        {
            if( i.pitcher_id == pitcher.pitcher_id )
                break;
            
            index ++;
        }
        
        if( index < team_pitchers.count )   //should always be true...
            [ [_team_to_pitchers objectAtIndex:pitcher.info.team] removeObjectAtIndex:index ];
    }
}

-(void) writeDatabaseToDisk;
{
    NSLog(@"Saving to disk...");
    
    NSError *error;
    
    NSMutableDictionary *json = [ [NSMutableDictionary alloc] init ];
    
    //get all the teams JSON arrays
    for( int i = 0; i < TEAMCOUNT; i++ )
        [ json setValue:[self getTeamJSONArray:i] forKey:TEAM_NAME_STR[i] ];
    
    NSData* json_data = [ NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&error ];
    
    //--Debuging--//
    //NSString* newStr = [[NSString alloc] initWithData:json_data encoding:NSUTF8StringEncoding];
    //NSLog(newStr);
    //----------//
    
    [ json_data writeToFile:[self getSaveFilePath] atomically:YES ]; //atomically, Yes? No? Maybe so?
    
    NSLog(@"Finished saving to disk");
}

-(void) loadDatabaseFromDisk
{
    NSLog(@"Loading from disk...");
    
    NSData *json_data = [ NSData dataWithContentsOfFile:[self getSaveFilePath] ];
    
    if( json_data != nil )
    {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:json_data options:0 error:&error];
        [ self loadTeamsFromJSON:json ];
    }
    else
    {
        NSAssert(false, @"JSON WAS NIL!");
    }
    
    NSLog(@"Finished loading from disk");
}



//--------------------locals--------------------//
-(NSString *) getSaveFilePath
{
    
#ifdef DEBUG_PRINTS
    NSLog([ NSHomeDirectory() stringByAppendingString:SAVE_FILE_NAME ]);    //debugging (finding file path)
#endif
    
    return [ NSHomeDirectory() stringByAppendingString:SAVE_FILE_NAME ];
}

//-----Writing-----//
-(NSArray *) getTeamJSONArray:(TeamNames)team
{
    NSMutableArray *json_array = [ [NSMutableArray alloc] init ];
    
    NSArray *pitchers = _team_to_pitchers[team];
    
    for( Pitcher *pitcher in pitchers )
        [ json_array addObject:pitcher.getAsJSON ];
    
    return json_array;
}
//------------------//

//-----Reading------//
-(void) loadTeamsFromJSON:(NSDictionary *) teams
{
    for( NSString *team in teams )
        [ self loadTeamFromJSON:[self teamEnumFromString:team] with:[teams objectForKey:team] ];
}

-(void) loadTeamFromJSON:(TeamNames) team with:(NSArray *) team_pitchers
{
    NSMutableArray *pitchers = [ [NSMutableArray alloc] init ];
    
    for( int i = 0; i < team_pitchers.count; i++ )
        [ pitchers addObject:[[Pitcher alloc] initWithJSON:[team_pitchers objectAtIndex:i]] ];
    
    [ _team_to_pitchers replaceObjectAtIndex:team withObject:pitchers ];
}

-(TeamNames) teamEnumFromString:(NSString *)team_str
{
    for( int i = 0; i < TEAMCOUNT; i++ )
    {
        if( [ team_str isEqualToString:TEAM_NAME_STR[i] ] )
            return i;
    }
    
    NSAssert(false, @"Unrecognizable team name string");
    
    return TEAMCOUNT;   //dummy, we will fail the assert above always (stupid compiler)
}
//------------------//
//----------------------------------------------//

@end
