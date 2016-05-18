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
@synthesize displayStatsLabel = _displayStatsLabel;

-(id) init
{
    self = [ super init ];
    [ self initDisplay:nil ];
    
    return self;
}

-(id) initWithPitchStats:(PitchStats*)stats
{
    self = [ super init ];
    [ self initDisplay:stats ];
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [ super initWithCoder:aDecoder ];
    [ self initDisplay:nil ];
    
    return self;
}

-(void) initDisplay:(PitchStats*)stats
{
    _displayStatsLabel = [ [UILabel alloc] init ];
    
    _displayStatsLabel.textColor = [ UIColor lightTextColor ];
    _displayStatsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _displayStatsLabel.numberOfLines = 0;
    
    UIFont *font = _displayStatsLabel.font;
    _displayStatsLabel.font = [font fontWithSize:22];
    
    [ self addSubview:_displayStatsLabel ];
    
    [ self changePitcherStats:stats ];
    [ self fillStatsFields ];
}

-(void) setFrame:(CGRect)frame
{
    [ super setFrame:frame ];
    
    _displayStatsLabel.frame = CGRectMake(SIDE_BUF, 0, self.frame.size.width - SIDE_BUF, self.frame.size.height);
}

-(void) changePitcherStats:(PitchStats*) stats
{
    _stats = stats;
    [ self fillStatsFields ];
}

-(void) fillStatsFields
{
    NSString *text = @"";
    
    if( _stats != nil )
    {
        text = [ self getFormattedDisplayString ];
    }
    else
    {
        text = [ NSString stringWithFormat:@"\t\tNo Stats for Current Pitcher" ];
    }
    
    _displayStatsLabel.text = text;
}

-(NSString*) getFormattedDisplayString
{
    NSString *line1 = [ NSString stringWithFormat:@"\t\tStrikes: %i\t\t Balls: %i\t\t StrikePer: %.02f\t\t BallPer: %.02f\n\n", _stats.total_strikes, _stats.total_balls, [_stats getStrikePercentage], [_stats getBallPercentage] ];
    
    NSString *line2 = [ NSString stringWithFormat:@"\t\tStrike Outs: %i\t\t Walks: %i\n\n", _stats.total_k, _stats.total_walks ];
    
    NSString *line345 = [ NSString stringWithFormat:@"PitchPer: %@\n\nFirst PitchPer: %@\n\nStrike Out PitchPer: %@", [self getPitchPercentageString], [self getFirstPitchPercentageString], [self getStrikeOutPitchPercentageString] ];
    
    line1 = [ line1 stringByAppendingString:line2 ];
    
    return [ line1 stringByAppendingString:line345 ];
}

-(NSString *) percentageArrayToDisplayString:(NSArray*) array
{
    NSMutableString *ret = [ [NSMutableString alloc] init ];
    
    int index = 0;
    
    for( NSNumber *i in array )
    {
        if( [ i floatValue ] > 0 )  //no pitches, don't show it
        {
            NSString* add = [ NSString stringWithFormat:@"  - %@  %.02f", [self getPitchString:(PitchType)index], [i floatValue] ];
            [ ret appendString: add ];
        }
        
        index ++;
    }
    
    return ret;
}

-(NSString *) getPitchPercentageString
{
    return [ self percentageArrayToDisplayString:[_stats getPitchPercentage] ];
}

-(NSString *) getFirstPitchPercentageString
{
    return [ self percentageArrayToDisplayString:[_stats getFirstPitchPercentage] ];
}

-(NSString *) getStrikeOutPitchPercentageString
{
    return [ self percentageArrayToDisplayString:[_stats getStrikeoutPitchPercentage] ];
}

-(NSString*) getPitchString:(PitchType)type
{
    NSString *ret;
    
    switch( type )
    {
        case FASTBALL_4:
            ret = @"Fastball(4)";
            break;
        case FASTBALL_2:
            ret = @"Fastball(2)";
            break;
        case CUTTER:
            ret = @"Cutter";
            break;
        case CURVE_1:
            ret = @"Curve";
            break;
        case CURVE_2:
            ret = @"Curve(2)";
            break;
        case SLIDER:
            ret = @"Slider";
            break;
        case CHANGE:
            ret = @"Changeup";
            break;
        case SPLITTER:
            ret = @"Splitter";
            break;
        default:
            ret = @"Unknown";
            break;
    }
    
    return ret;
}


@end
