//
//  PitcherView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherView.h"

@implementation PitcherView

@synthesize info_view = _info_view;
@synthesize stats_view = _stats_view;

-(id) init
{
    self = [ super init ];
    
    [ self setPitcherViews:nil ];
    [ self setBackground ];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    
    [ self setPitcherViews:nil ];
    [ self setBackground ];
    
    return self;
}

-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher
{
    self = [ super initWithFrame:frame ];
    
    [ self setPitcherViews:pitcher ];
    [ self setBackground ];
    
    return self;
}

-(void) changePitcher:(Pitcher*)pitcher
{
    if( pitcher != nil )
    {
        [ _info_view changePitcherInfo:pitcher.info ];
        [ _stats_view changePitcherStats:pitcher.stats ];
    }
    else
    {
        [ _info_view changePitcherInfo:nil];
        [ _stats_view changePitcherStats:nil];
    }
}

-(void) setPitcherViews:(Pitcher *)pitcher
{
    CGRect frame_info, frame_stats;
    frame_info = frame_stats = self.frame;
    frame_info.origin.x = frame_stats.origin.x = 0;
    frame_info.origin.y = 0;
    frame_info.size.height = self.frame.size.height *  0.4; //must use decimal here? No fractions...
    frame_stats.size.height = self.frame.size.height *  0.6;
    frame_stats.origin.y = frame_info.size.height;
    
    if( pitcher == nil )
    {
        _info_view = [ [PitcherInfoView alloc] initWithFrame:frame_info ];
        _stats_view = [ [PitcherStatsView alloc] initWithFrame:frame_stats ];
    }
    else
    {
        _info_view = [ [PitcherInfoView alloc] initWithFrameAndPlayerInfo:frame_info with:pitcher.info ];
        _stats_view = [ [PitcherStatsView alloc] initWithFrameAndPlayerStats:frame_stats with:pitcher.stats ];
    }
    
    [ self addSubview:_info_view ];
    [ self addSubview:_stats_view ];
    [ self setBackground ];
}

-(void) setBackground
{
    self.backgroundColor = [ UIColor blackColor ];
    //self.alpha = 0.7;
}

@end
