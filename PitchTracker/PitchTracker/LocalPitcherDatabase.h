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

#define SAVE_FILE_NAME @"/Documents/savefile.txt"

@interface LocalPitcherDatabase : NSObject

@property (atomic) NSMutableArray *team_to_pitchers;
@property (atomic) unsigned int next_pitcher_id;

-(id) init;
-(bool) addPitcher:(Pitcher*)pitcher;
-(bool) editPitcher:(Pitcher*)pitcher;
-(void) deletePitcher:(Pitcher *)pitcher;
-(unsigned int) getNewPitcherID;
-(NSArray*) getTeamArray:(TeamNames)team;
+(id) sharedDatabase;
-(void) loadDatabaseFromDisk;
-(void) writeDatabaseToDisk;

@end

static LocalPitcherDatabase* database;
