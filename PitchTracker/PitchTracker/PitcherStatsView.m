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
    NSString *line1 = [ NSString stringWithFormat:@"\t\tStrikes: %i\t\t Balls: %i\t\t Strike %%: %.02f%%\t\t Ball %%: %.02f%%\n\n", _stats.total_strikes, _stats.total_balls, [_stats getStrikePercentage], [_stats getBallPercentage] ];
    
    NSString *line2 = [ NSString stringWithFormat:@"\t\tStrike Outs: %i\t\t Walks: %i\n\n", _stats.total_k, _stats.total_walks ];
    
    NSString *line345 = [ NSString stringWithFormat:@"Pitch %%: %@\n\nFirst Pitch %%: %@\n\nStrike Out Pitch %%: %@", [self getPitchPercentageString], [self getFirstPitchPercentageString], [self getStrikeOutPitchPercentageString] ];
    
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
            NSString* add = [ NSString stringWithFormat:@"  - %@  %.02f%%", getPitchString(1 << index), [i floatValue] ];
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

@end
