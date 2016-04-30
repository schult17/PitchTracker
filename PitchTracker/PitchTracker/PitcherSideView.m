//
//  PitcherView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherSideView.h"

@implementation PitcherSideView

@synthesize pitcher = _pitcher;
@synthesize team_label = _team_label;
@synthesize name_label = _name_label;

//shouldn't be used...
-(id) init
{
    self = [ super init ];
    _pitcher = [ [Pitcher alloc] init ];
    [ self setLabels ];
    NSLog( @"Here - bad" );
    
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    _pitcher = [ [Pitcher alloc] init ];
    [ self setLabels ];
    
    return self;
}

-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher
{
    self = [ super initWithFrame:frame ];
    _pitcher = pitcher;
    [ self setLabels ];
    
    return self;
}

-(void) updatePitcher:(Pitcher*)pitcher
{
    _pitcher = pitcher;
    [ self updateLabelText ];
}

-(void) updateLabelText
{
    if( _pitcher != nil )
    {
        _team_label.text = _pitcher.info.getTeamDisplayString;
        _name_label.text = _pitcher.info.getShortDisplayString;
    }
    else
    {
        NSLog(@"nil pitcher");
    }
}

-(void) setLabels
{
    CGFloat seg_height = self.frame.size.height/4;
    
    _team_label = [ [UILabel alloc] initWithFrame:CGRectMake(0, seg_height, self.frame.size.width, seg_height) ];
    _team_label.text = _pitcher.info.getTeamDisplayString;
    _team_label.textColor = [UIColor lightTextColor];
    
    _name_label = [ [UILabel alloc] initWithFrame:CGRectMake(0, 2*seg_height, self.frame.size.width, seg_height)];
    _name_label.text = _pitcher.info.getShortDisplayString;
    _name_label.textColor = [UIColor lightTextColor];
    
    [ self addSubview:_team_label ];
    [ self addSubview:_name_label ];
}

@end
