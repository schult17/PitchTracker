//
//  PitcherSideScrollView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherSideScrollView.h"

@implementation PitcherSideScrollView

@synthesize curr_team = _curr_team;

-(void) changeTeam:(TeamNames)team
{
    _curr_team = team;
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    NSArray *pitchers = [ database getTeamArray:team ];
    [ self clearContents ];
    [ self addPitchersToView:pitchers ];
}

-(void) clearContents
{
    for( UIView *i in self.subviews )
    {
        if( [i isKindOfClass:[PitcherSideView class]] )
            [ i removeFromSuperview ];
    }
}

-(void) addPitchersToView:(NSArray *)pitchers
{
    [ self setContentSize:CGSizeMake(self.frame.size.width, PLAYERVIEW_HEIGHT * pitchers.count) ];
    
    CGRect frame = CGRectMake(SCROLL_INSET, 0, self.frame.size.width, PLAYERVIEW_HEIGHT);
    
    PitcherSideView *view = nil;
    
    //view.translatesAutoresizingMaskIntoConstraints = NO;
    
    for( int i = 0; i < pitchers.count ; i++ )
    {
        frame.origin.y = PLAYERVIEW_HEIGHT * i;
        view = [ [PitcherSideView alloc] initWithFrameAndPlayer:frame with:[ pitchers objectAtIndex:i ] ];
        [ self addSubview:view ];
        /*
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(view)]];
        [self addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
                                   options:NSLayoutFormatDirectionLeadingToTrailing
                                   metrics:nil
                                   views:NSDictionaryOfVariableBindings(view)]];*/
    }
}

-(Pitcher*) findPitcherFromTouch:(CGPoint)tap
{
    int index = floor(tap.y / PLAYERVIEW_HEIGHT);
    
    if( index < 0 ) index = 0;
    
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    NSArray *pitchers = [ database getTeamArray:_curr_team ];
    
    if( index < pitchers.count )
        return [ pitchers objectAtIndex:index ];
    else
        return nil;
}

@end
