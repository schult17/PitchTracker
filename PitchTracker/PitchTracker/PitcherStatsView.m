//
//  PitcherStatsView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherStatsView.h"

@implementation PitcherStatsView

@synthesize stats = _stats;

-(id) init
{
    self = [ super init ];
    [ self changePitcherStats:[[PitchStats alloc] init] ];
    
    return self;
}

-(id) initWithPitchStats:(PitchStats*)stats
{
    self = [ super init ];
    [ self changePitcherStats:stats ];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    [ self changePitcherStats:[[PitchStats alloc] init] ];
    
    return self;
}

-(id) initWithFrameAndPlayerStats:(CGRect)frame with:(PitchStats *)stats
{
    self = [super initWithFrame:frame];
    [ self changePitcherStats:stats ];
    
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [ super setFrame:frame ];
}

-(void) changePitcherStats:(PitchStats*) stats
{
    _stats = stats;
    [ self fillStatsFields ];
}

-(void) fillStatsFields
{
}


@end
