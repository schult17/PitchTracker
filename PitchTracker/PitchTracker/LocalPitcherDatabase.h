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
@property int pitcher_id_count;

-(id) init;
-(bool) addPitcher:(Pitcher*)pitcher;
-(int) getNewPitcherID;
-(bool) editPitcher:(Pitcher*)pitcher;
-(NSArray*) getTeamArray: (TeamNames)team;
+(id) sharedDatabase;
-(void) writeDatabaseToDisk;

@end

static LocalPitcherDatabase* database;
