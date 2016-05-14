//
//  SingleZoneView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-05-12.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "SingleZoneView.h"

@implementation SingleZoneView

@synthesize type = _type;
@synthesize X = _X;
@synthesize Y = _Y;
@synthesize zoneSelected = _zoneSelected;

-(id) initWithLocation:(PitchLocation) X with: (PitchLocation) Y
{
    self = [ super init ];
    
    //Order important here
    _X = X;
    _Y = Y;
    
    [ self locationToZoneType ];
    [ self setZoneColour ];
    
    return self;
}

-(void) locationToZoneType
{
    if( (_X > A && _X < E) && (_Y > A && _Y < E) )
        _type = STRIKE_ZONE;
    else
        _type = BALL_ZONE;
}

-(void) setZoneColour
{
    if( _type == STRIKE_ZONE )
        [ self setBackgroundColor:[UIColor redColor] ];
    else
        [ self setBackgroundColor:[UIColor blueColor] ];
    
    [ self setAlpha:0.6 ];
    
    [ self.layer setBorderColor:[UIColor blackColor].CGColor ];
    [ self.layer setBorderWidth:1.5f ];
}

-(void) setZoneSelected
{
    if( !_zoneSelected )
    {
        [ self setBackgroundColor:[UIColor greenColor] ];   //TODO -- better selection colour
        _zoneSelected = true;
    }
    else
    {
        [ self setZoneColour ];
        _zoneSelected = false;
    }
}

@end
