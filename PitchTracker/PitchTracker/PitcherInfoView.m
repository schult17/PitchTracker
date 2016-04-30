//
//  PitcherInfoView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherInfoView.h"

@implementation PitcherInfoView

@synthesize info = _info;
@synthesize displayInfoLabel = _displayInfoLabel;


-(id) init
{
    self = [ super init ];
    [ self broadInit:nil ];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    [ self broadInit:nil ];
    
    return self;
}

-(id) initWithFrameAndPlayerInfo:(CGRect)frame with:(PitcherInfo *)info
{
    self = [ super initWithFrame:frame ];
    [ self broadInit:info ];
    
    return self;
}

-(void) broadInit:(PitcherInfo *)info
{
    _displayInfoLabel = [ [UILabel alloc] initWithFrame:CGRectMake(SIDE_BUFFER, 0, self.frame.size.width - SIDE_BUFFER, self.frame.size.height) ];
    
    _displayInfoLabel.textColor = [ UIColor lightTextColor ];
    _displayInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _displayInfoLabel.numberOfLines = 0;
    
    [ self addSubview:_displayInfoLabel ];
    [ self changePitcherInfo:info ];
}

-(void) changePitcherInfo:(PitcherInfo*)info
{
    _info = info;
    [ self fillInfo ];
}

-(void) fillInfo
{
    NSString *text = @"";
    
    if( _info != nil )
    {
        text = [ NSString stringWithFormat:@"\t\t%@\n\n\t\t%@\n\n\t\t%@\n\n\t\t%@\n\n\t\t%@\n", _info.getTeamDisplayString, _info.getNameDisplayString, _info.getPhysicalDisplayString, _info.getNumberHandDisplayString, _info.getPitchDisplayString ];
    }
    else
    {
        text = [ NSString stringWithFormat:@"No Pitchers for Current Filter" ];
    }
    
    _displayInfoLabel.text = text;
}

@end
