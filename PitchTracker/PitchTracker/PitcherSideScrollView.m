//
//  PitcherSideScrollView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherSideScrollView.h"

@implementation PitcherSideScrollView

-(void) changeTeam:(TeamNames)team
{
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
    [ self setContentSize:CGSizeMake(self.frame.size.height, PLAYERVIEW_HEIGHT * pitchers.count) ];
    
    CGRect frame = CGRectMake(SCROLL_INSET, 0, self.frame.size.width, PLAYERVIEW_HEIGHT);
    
    PitcherSideView *view = nil;
    
    for( int i = 0; i < pitchers.count ; i++ )
    {
        frame.origin.y = PLAYERVIEW_HEIGHT * i;
        view = [ [PitcherSideView alloc] initWithFrameAndPlayer:frame with:[ pitchers objectAtIndex:i ] ];
        [ self addSubview:view ];
    }
}

@end
