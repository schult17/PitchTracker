//
//  PitcherInfo.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Globals.h"

@interface PitcherInfo : NSObject

@property TeamNames team;
@property NSString *first_name;
@property NSString *last_name;
@property int jersey_num;
@property Hand hand;
@property int age;
@property int weight;
@property int height_f;
@property int height_i;
@property NSMutableArray *pitches;

-(id) init; //shouldn't really be used

-(id) initWithJSON:(NSDictionary *)json;
-(id) initWithDetails: (TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;

-(void) setDetails: (TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;

-(NSString *) getShortDisplayString;
-(NSString*) getTeamDisplayString;
-(NSString*) getNameDisplayString;
-(NSString*) getNumberHandDisplayString;
-(NSString*) getPhysicalDisplayString;
-(NSString*) getPitchDisplayString;
-(NSString*) getPitchString:(PitchType)type;
-(NSString*) getHandString:(Hand)hand;

-(NSDictionary*) getAsJSON;

@end
