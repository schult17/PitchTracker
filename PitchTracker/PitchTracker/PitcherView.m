//
//  PitcherView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-29.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "PitcherView.h"

@implementation PitcherView

@synthesize arm_view = _arm_view;
@synthesize info_view = _info_view;
@synthesize stats_view = _stats_view;
@synthesize pitcher = _pitcher;
@synthesize editButton = _editButton;
@synthesize advancedStatsButton = _advancedStatsButton;

-(id) init
{
    self = [ super init ];
    [ self setPitcherViews:nil ];
    [ self setBackground ];
    
    return self;
}

//This view is instantiated in the storyboard, so this init is called
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [ super initWithCoder:aDecoder ];
    [ self setPitcherViews:nil ];
    [ self setBackground ];
    
    return self;
}

-(id) initWithPlayer:(Pitcher*)pitcher
{
    self = [ super init ];
    [ self setPitcherViews:pitcher ];
    [ self setBackground ];
    
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    [ self setPitcherViews:nil ];
    [ self setBackground ];
    
    return self;
}

-(id) initWithFrameAndPlayer:(CGRect)frame with: (Pitcher*)pitcher
{
    self = [ super initWithFrame:frame ];
    [ self setPitcherViews:pitcher ];
    [ self setBackground ];
    
    return self;
}

-(void) changePitcher:(Pitcher*)pitcher
{
    _pitcher = pitcher;
    
    if( pitcher != nil )
    {
        [ _info_view changePitcherInfo:pitcher.info ];
        [ _stats_view changePitcherStats:pitcher.stats ];
    }
    else
    {
        [ _info_view changePitcherInfo:nil];
        [ _stats_view changePitcherStats:nil];
    }
}

-(void) layoutView
{
    CGRect frame_info, frame_stats, frame_edit;
    frame_info = frame_stats = self.frame;
    frame_info.origin.x = frame_stats.origin.x = 0;
    frame_info.origin.y = 0;
    frame_info.size.height = self.frame.size.height *  0.5;
    frame_stats.size.height = self.frame.size.height *  0.5;
    frame_stats.origin.y = frame_info.size.height;
    
    frame_edit.origin.x = self.frame.size.width/2;
    frame_edit.origin.y = 0;
    frame_edit.size.width = self.frame.size.width/4;
    frame_edit.size.height = 50;
    
    [ _info_view setFrame:frame_info ];
    [ _stats_view setFrame:frame_stats ];
    [ _arm_view setFrame:frame_info ];
    [ _editButton setFrame:frame_edit ];
    
    [ _advancedStatsButton setCenter:_editButton.center ];
    CGRect frame_advanced = _advancedStatsButton.frame;
    frame_advanced.size.width = 300;
    frame_advanced.size.height = 30;
    frame_advanced.origin.y = self.frame.size.height - 60;
    [ _advancedStatsButton setFrame:frame_advanced ];
}


-(void) setPitcherViews:(Pitcher *)pitcher
{
    _pitcher = pitcher;
    
    _editButton = [ [UILabel alloc] init ];
    _editButton.text = @"Edit Player";
    _editButton.textColor = [ UIColor whiteColor ];
    UIFont *f = _editButton.font;
    f = [f fontWithSize:35];
    _editButton.font = f;
    
    _advancedStatsButton = [ [UIButton alloc] init ];
    [ _advancedStatsButton setTitle:@"Advanced Stats" forState:UIControlStateNormal ];
    [ _advancedStatsButton setTintColor:[UIColor whiteColor] ];
    _advancedStatsButton.titleLabel.font = f;
    
    if( pitcher == nil )
    {
        _info_view = [ [PitcherInfoView alloc] init ];
        _stats_view = [ [PitcherStatsView alloc] init ];
    }
    else
    {
        _info_view = [ [PitcherInfoView alloc] initWithPlayer:pitcher.info ];
        _stats_view = [ [PitcherStatsView alloc] initWithPitchStats:pitcher.stats ];
    }
    
    _arm_view = [ [EditPitcherView alloc] init ];
    _arm_view.hidden = YES;
    
    [ self addSubview:_info_view ];
    [ self addSubview:_arm_view ];
    [ self addSubview:_stats_view ];
    [ self addSubview:_editButton ];
    [ self addSubview:_advancedStatsButton ];
}

-(void) setBackground
{
    self.backgroundColor = [ UIColor blackColor ];
}

-(void) switchToNewPitcher
{
    _arm_view.addButton.text = @"Add Pitcher";
    _info_view.hidden = YES;
    _arm_view.hidden = NO;
    _stats_view.hidden = YES;
    
    _editButton.hidden = YES;
}

-(void) switchToEditPitcher;
{
    [ _arm_view presentFieldsEdit:_pitcher ];
    
    _arm_view.addButton.text = @"Edit Pitcher";
    _info_view.hidden = YES;
    _arm_view.hidden = NO;
    _stats_view.hidden = YES;
    
    _editButton.hidden = YES;
}

-(void) cancelNewEditPitcherView
{
    _info_view.hidden = NO;
    _arm_view.hidden = YES;
    _stats_view.hidden = NO;
    
    _editButton.hidden = NO;
}

-(bool) clickInsideEdit:(CGPoint)tap
{
    if( _editButton.isHidden )
        return false;
    else
        return CGRectContainsPoint(_editButton.frame, tap);
}

@end
