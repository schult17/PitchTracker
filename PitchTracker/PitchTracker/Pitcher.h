//
//  Pitcher.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PitchStats.h"
#import "Globals.h"

@interface Pitcher : NSObject

@property NSString *team;
@property NSString *first_name;
@property NSString *last_name;
@property int jersey_num;
@property Hand hand;
@property NSMutableArray *pitches;
@property PitchStats *stats;        //maybe not *?

-(id) init; //shouldn't really be used

-(id) initWithDetailsStr: (NSString *) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (NSMutableArray *) pitches;

-(id) initWithDetailsNum: (TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (NSMutableArray *) pitches;

-(void) setDetails: (NSString *) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with:(NSMutableArray *) pitches;

@end
