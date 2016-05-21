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
/*
-(id) init
{
    self = [ super init ];
    _pitcher = [ [Pitcher alloc] init ];
    [ self setLabels ];
    NSLog( @"Here - bad" );
    
    return self;
}
*/

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    _pitcher = [ [Pitcher alloc] init ];
    [ self setLabels ];
    [ self setUpScrollingOptions ];
    
    return self;
}

//only init that seems to be needed
-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher
{
    self = [ super initWithFrame:frame ];
    _pitcher = pitcher;
    [ self setLabels ];
    [ self setUpScrollingOptions ];
    
    return self;
}

//-----local-----//
-(void) setUpScrollingOptions
{
    CGSize size = self.frame.size;
    size.width += DEL_BUTTON_DIM;  //for delete button
    
    [ self setScrollEnabled:YES ];
    [ self setShowsHorizontalScrollIndicator:NO ];
    [ self setShowsVerticalScrollIndicator:NO ];
    [ self setBounces:NO ];
    
    //must maintain order below
    [ self setContentSize:size ];
    [ self addDeleteSquare ];
}

-(void) addDeleteSquare
{
    UIView *del = [ [UIView alloc] init ];
    [ del setFrame:CGRectMake(self.contentSize.width - DEL_BUTTON_DIM, 0, DEL_BUTTON_DIM, self.contentSize.height) ];
    [ del setBackgroundColor:[UIColor redColor] ];
    
    UILabel *X = [ [UILabel alloc] initWithFrame:CGRectMake(0, 0, del.frame.size.width, del.frame.size.width) ];
    X.text = @"Delete";
    X.textColor = [ UIColor whiteColor ];
    X.textAlignment = NSTextAlignmentCenter;
    
    UIFont *f = X.font;
    f = [ f fontWithSize:DEL_BUTTON_TEXT_SIZE ];
    X.font = f;
    
    [ del addSubview:X ];
    
    [ self addSubview:del ];
}
//---------------//

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
    
    _team_label = [ [UILabel alloc] initWithFrame:CGRectMake(TEXT_INSET, seg_height, self.frame.size.width, seg_height) ];
    _team_label.text = _pitcher.info.getTeamDisplayString;
    _team_label.textColor = [UIColor lightTextColor];
    
    _name_label = [ [UILabel alloc] initWithFrame:CGRectMake(TEXT_INSET, 2*seg_height, self.frame.size.width, seg_height)];
    _name_label.text = _pitcher.info.getShortDisplayString;
    _name_label.textColor = [UIColor lightTextColor];
    
    [ self addSubview:_team_label ];
    [ self addSubview:_name_label ];
}

//is touch inside delete button
-(bool) touchInsideDelete:(CGPoint) tap
{
    CGRect del_frame = CGRectMake( self.contentSize.width - DEL_BUTTON_DIM,
                                  0,
                                  DEL_BUTTON_DIM,
                                  self.contentSize.height );
    
    if( CGRectContainsPoint(del_frame, tap) )
        return true;
    else
        return false;
}

@end
