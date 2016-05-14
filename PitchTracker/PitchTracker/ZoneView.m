//
//  StrikeZoneView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "ZoneView.h"
#import "SingleZoneView.h"

@implementation ZoneView

@synthesize zones = _zones;
@synthesize curr_zone_x = _curr_zone_x;
@synthesize curr_zone_y = _curr_zone_y;

-(id) init
{
    self = [ super init ];
    [ self broadInit ];
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [ super initWithCoder:aDecoder ];
    [ self broadInit ];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    [ self broadInit ];
    
    return self;
}

-(void) broadInit
{
    _zones = [ [NSMutableArray alloc] init ];
    
    for( int i = 0; i < ZONEDIM; i++ )
    {
        [ _zones insertObject:[[NSMutableArray alloc] init] atIndex:i ];
        
        for( int j = 0; j < ZONEDIM; j++ )
        {
            SingleZoneView *single_zone = [[SingleZoneView alloc] initWithLocation:i with:j];
            [ [ _zones objectAtIndex:i ] insertObject:single_zone atIndex:j ];
            [ self addSubview:single_zone ];
        }
    }
    
    _curr_zone_x = _curr_zone_y = -1;
}

-(void) setFrame:(CGRect)frame
{
    [ super setFrame:frame ];
    
    CGFloat zone_w = self.frame.size.width / ZONEDIM;
    CGFloat zone_h = self.frame.size.height / ZONEDIM;
    CGRect f;
    
    for( int i = 0; i < ZONEDIM; i++ )
    {
        for( int j = 0; j < ZONEDIM; j++ )
        {
            f = CGRectMake(i*zone_w, j*zone_h, zone_w, zone_h);
            [ [[_zones objectAtIndex:i] objectAtIndex:j] setFrame:f ];
        }
    }
}

-(SingleZoneView*) handleTapInZone:(CGPoint) tap
{
    SingleZoneView *ret = nil;
    CGFloat zone_w = self.frame.size.width / ZONEDIM;
    CGFloat zone_h = self.frame.size.height / ZONEDIM;
    
    int x = floor( tap.x / zone_w );
    int y = floor( tap.y / zone_h );
    
    //De select old zone by switching back to original colour
    //NOTE: setZoneSelected knows if it was already selected, and will de select
    if( _curr_zone_x != -1 && _curr_zone_y != -1 )
        [ [[_zones objectAtIndex:_curr_zone_x] objectAtIndex:_curr_zone_y] setZoneSelected ];
    
    //Select new tapped zone if not same as old zone (allows de selecting of old zone)
    if( !( _curr_zone_x == x && _curr_zone_y == y) )
    {
        ret = [[_zones objectAtIndex:x] objectAtIndex:y];
        [ ret setZoneSelected ];
        _curr_zone_x = x;
        _curr_zone_y = y;
    }
    else    //clicked on same zone, no zones selected
    {
        _curr_zone_x = -1;
        _curr_zone_y = -1;
    }
    
    return ret;
}

-(void) deSelectZone
{
    if( _curr_zone_x != -1 && _curr_zone_y != -1 )
        [ [[_zones objectAtIndex:_curr_zone_x] objectAtIndex:_curr_zone_y] setZoneColour ];
    
    _curr_zone_x = _curr_zone_y = -1;
}

@end
