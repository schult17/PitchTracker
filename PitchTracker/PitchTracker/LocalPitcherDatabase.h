//
//  LocalPitcherDatabase.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pitcher.h"
#import "Globals.h"

@interface LocalPitcherDatabase : NSObject

@property NSMutableArray *team_to_players;
@property unsigned int next_pitcher_id;

-(id) init;
-(bool) addPitcher:(Pitcher*)pitcher;
-(bool) editPitcher:(Pitcher*)pitcher;
-(void) deletePitcher:(Pitcher *)pitcher;
-(unsigned int) getNewPitcherID;
-(NSArray*) getTeamArray:(TeamNames)team;
+(id) sharedDatabase;
-(void) writeDatabaseToDisk:(NSString *)file_path;

@end

static LocalPitcherDatabase* database;
