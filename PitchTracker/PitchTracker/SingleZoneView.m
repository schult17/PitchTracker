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
@synthesize percentageLabel = _percentageLabel;

-(id) initWithLocation:(PitchLocation) X with: (PitchLocation) Y with:(bool) perc_visible
{
    self = [ super init ];
    
    //Order important here
    _X = X;
    _Y = Y;
    [ self locationToZoneType ];
    [ self setZoneColour ];
    
    if( perc_visible )
    {
        _percentageLabel = [ [UILabel alloc] init ];
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        _percentageLabel.textColor = [UIColor lightTextColor];
        _percentageLabel.text = @"0%";
        _percentageLabel.font = [_percentageLabel.font fontWithSize:PERCENTAGE_FONT_SIZE];
        [ self addSubview:_percentageLabel ];
    }
    else
    {
        _percentageLabel = nil;
    }
    
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [ super setFrame:frame ];
    [ self setPercentageFrame ];
}

-(void) setPercentageToDisplay:(CGFloat) perc
{
    if( _percentageLabel != nil )
        _percentageLabel.text = [ NSString stringWithFormat:@"%.0f%%", perc ];
}

//-----locals-----//
-(void) locationToZoneType
{
    if( (_X > A && _X < E) && (_Y > A && _Y < E) )
        _type = STRIKE_ZONE;
    else
        _type = BALL_ZONE;
}

-(void) setZoneColour
{
    [ self setZoneNormalBackgroundColour ];
    [ self setAlpha:0.65 ];
    
    [ self.layer setBorderColor:[UIColor blackColor].CGColor ];
    [ self.layer setBorderWidth:1.5f ];
}

-(void) setZoneNormalBackgroundColour
{
    if( _type == STRIKE_ZONE )
        [ self setBackgroundColor:[UIColor redColor] ];
    else
        [ self setBackgroundColor:[UIColor blueColor] ];
}

-(void) setZoneSelectedBackgroundColour
{
    //Consider changing alpha value for selection? (usually invisible, increase alpha?)
    [ self setBackgroundColor:[UIColor greenColor] ];   //TODO -- better selection colour??
}

-(void) setPercentageFrame
{
    if( _percentageLabel != nil )
        _percentageLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
}
//----------------//

-(void) toggleZoneSelected
{
    if( !_zoneSelected )
        [ self setZoneSelectedBackgroundColour ];
    else
        [ self setZoneNormalBackgroundColour ];
    
    _zoneSelected = !_zoneSelected;
}

@end
