//
//  Pitcher.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PitchStats.h"
#import "PitcherInfo.h"
#import "Globals.h"

@interface Pitcher : NSObject

@property PitcherInfo *info;
@property PitchStats *stats;
@property int pitcher_id;

-(id) init; //shouldn't really be used

-(id) initWithDetails: (TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;

-(void) setDetails: (TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;

-(void) setID:(int) new_id;

@end
