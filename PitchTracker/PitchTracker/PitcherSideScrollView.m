//
//  PitcherSideScrollView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

//TODO -- slide left delete of pitchers
#import "PitcherSideScrollView.h"

@implementation PitcherSideScrollView

@synthesize curr_team = _curr_team;
@synthesize normalColour = _normalColour;
@synthesize tappedIndex = _tappedIndex;
@synthesize pitcherViews = _pitcherViews;

-(id) init
{
    self = [ super init ];
    [ self broadInit ];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    [ self broadInit ];
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [ super initWithCoder:aDecoder ];
    [ self broadInit ];
    
    return self;
}

-(void) broadInit
{
    _normalColour = self.backgroundColor;
    _pitcherViews = [ [NSMutableArray alloc] init ];
}

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
    [ _pitcherViews removeAllObjects ];
    
    [ self setContentSize:CGSizeMake(self.frame.size.width, PLAYERVIEW_HEIGHT * pitchers.count) ];
    
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, PLAYERVIEW_HEIGHT);
    
    PitcherSideView *view = nil;
    
    for( int i = 0; i < pitchers.count ; i++ )
    {
        frame.origin.y = PLAYERVIEW_HEIGHT * i;
        view = [ [PitcherSideView alloc] initWithFrameAndPlayer:frame with:[ pitchers objectAtIndex:i ] ];
        
        //by default first pitcher is selected
        if( i == 0 )
            view.backgroundColor = [ UIColor SELECTED_COLOUR ];
        
        [ self addSubview:view ];
        [ _pitcherViews addObject:view ];
    }
    
    _tappedIndex = 0;
}

-(Pitcher*) findPitcherFromTouch:(CGPoint)tap
{
    int index = floor(tap.y / PLAYERVIEW_HEIGHT);
    
    if( index < 0 ) index = 0;
    
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    NSArray *pitchers = [ database getTeamArray:_curr_team ];
    
    if( index < pitchers.count )
    {
        //Colouring of background for currently selected pitcher
        //old selection
        [ [ _pitcherViews objectAtIndex:_tappedIndex ] setBackgroundColor:_normalColour ];
        
        //newly selected
        _tappedIndex = index;
        [ [ _pitcherViews objectAtIndex:_tappedIndex ] setBackgroundColor:[UIColor SELECTED_COLOUR] ];
        //----------------------------------------------------//
        
        Pitcher *new_pitcher = [ pitchers objectAtIndex:index ];
        return new_pitcher;
    }
    else
    {
        return nil;
    }
}

-(void) highlightPitcher:(int)pitcher_id
{
    for( int i = 0; i < _pitcherViews.count; i++ )
    {
        if( ((PitcherSideView*)[ _pitcherViews objectAtIndex:i ]).pitcher.pitcher_id == pitcher_id )
        {
            //Colouring of background for currently selected pitcher
            //old selection
            [ [ _pitcherViews objectAtIndex:_tappedIndex ] setBackgroundColor:_normalColour ];
            
            //newly selected
            _tappedIndex = i;
            [ [ _pitcherViews objectAtIndex:_tappedIndex ] setBackgroundColor:[UIColor SELECTED_COLOUR] ];
            //----------------------------------------------------//
            
            break;
        }
    }
}

-(void) setBackgroundColor:(UIColor *)backgroundColor
{
    [ super setBackgroundColor:backgroundColor ];
    _normalColour = backgroundColor;
}

@end
