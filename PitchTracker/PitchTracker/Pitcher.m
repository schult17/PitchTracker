//
//  Pitcher.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "Pitcher.h"

@implementation Pitcher

@synthesize info = _info;
@synthesize stats = _stats;
@synthesize pitcher_id = _pitcher_id;

-(id) init
{
    _info = [ [PitcherInfo alloc] initWithDetails:UOFT with:@"Tyler" with:@"Durden" with:7 with:RIGHT with: 19 with: 200 with: 6 with: 1 with:[[NSMutableArray alloc] initWithArray:[ NSMutableArray arrayWithArray:@[@(FASTBALL_4), @(CURVE_1), @(CHANGE) ]]] ];
    
    _stats = [[PitchStats alloc] init];         //if we remove *, does alloc go away?
    
    return self;
}

-(id) initWithDetails:(TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;
{
    if( team < TEAMCOUNT )
    {
        _info = [ [PitcherInfo alloc] initWithDetails:team with:first_name with:last_name with:jersey_num with:hand with:age with:weight with:height_f with:height_i with:pitches ];
        
        _stats = [ [PitchStats alloc] init ];         //if we remove *, does alloc go away?
    }
    else
    {
        NSLog( @"Invalid team number, pitcher not created" );
    }
    
    return self;
}

-(void) setDetails:(TeamNames) team with: (NSString *) first_name with: (NSString *) last_name with: (int) jersey_num with: (Hand) hand with: (int) age with: (int) weight with: (int) height_f with: (int) height_i with: (NSMutableArray *) pitches;
{
    [ _info setDetails:team with:first_name with:last_name with:jersey_num with:hand with:age with:weight with:height_f with:height_i with:pitches ];
}

-(void) setID:(int) new_id
{
    _pitcher_id = new_id;
}

@end
