//
//  NewPitcherView.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "EditPitcherView.h"


@implementation EditPitcherView

@synthesize firstInput = _firstInput;
@synthesize lastInput = _lastInput;

@synthesize ageInput = _ageInput;
@synthesize heightFInput = _heightFInput;
@synthesize heightIInput = _heightIInput;
@synthesize weightInput = _weightInput;

@synthesize jerseryInput = _jerseryInput;
@synthesize leftLabel = _leftLabel;
@synthesize rightLabel = _rightLabel;

@synthesize pitchLabels = _pitchLabels;

@synthesize addButton = _addButton;


-(id) init
{
    self = [ super init ];
    [ self createFields ];
    return self;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [ super initWithFrame:frame ];
    [ self createFields ];
    return self;
}

-(void) clearFields
{
    [ _firstInput setText:@"" ];
    [ _lastInput setText:@"" ];
    
    [ _ageInput setText:@"" ];
    [ _heightFInput setText:@"" ];
    [ _heightIInput setText:@"" ];
    [ _weightInput setText:@"" ];
    
    [ _jerseryInput setText:@"" ];
    
    if( _leftLabel.selected )
        [ _leftLabel toggleSelected ];
    
    if( !_rightLabel.selected )
        [ _rightLabel toggleSelected ];
}

-(void) createFields
{
    _firstInput = [ [CustomTextField alloc] initWithString:@"First Name" ];
    _lastInput = [ [CustomTextField alloc] initWithString:@"Last Name" ];
    _ageInput = [ [CustomTextField alloc] initWithString:@"Age" ];
    _heightFInput = [ [CustomTextField alloc] initWithString:@"Feet" ];
    _heightIInput = [ [CustomTextField alloc] initWithString:@"Inches" ];
    _weightInput = [ [CustomTextField alloc] initWithString:@"Weight" ];
    _jerseryInput = [ [CustomTextField alloc] initWithString:@"Jersey" ];
    
    _leftLabel = [ [SelectableLabel alloc] initWithStr:@"Left" ];
    _rightLabel = [ [SelectableLabel alloc] initWithStr:@"Right" ];
    [ _rightLabel toggleSelected ];
    
    _ageInput.keyboardType = UIKeyboardTypeDecimalPad;
    _heightFInput.keyboardType = UIKeyboardTypeDecimalPad;
    _heightIInput.keyboardType = UIKeyboardTypeDecimalPad;
    _weightInput.keyboardType = UIKeyboardTypeDecimalPad;
    _jerseryInput.keyboardType = UIKeyboardTypeDecimalPad;
    
    _pitchLabels = [ [NSMutableArray alloc] init ];
    
    SelectableLabel *pitch = nil;
    NSString *text;
    for( int i = 0; i < COUNTPITCHES; i++ )
    {
        switch( (PitchType)i )
        {
            case FASTBALL_4:
                text = @"Fastball(4)";
                break;
            case FASTBALL_2:
                text = @"Fastball(2)";
                break;
            case CUTTER:
                text = @"Cutter";
                break;
            case CURVE_1:
                text = @"Curve";
                break;
            case CURVE_2:
                text = @"Curve(2)";
                break;
            case SLIDER:
                text = @"Slider";
                break;
            case CHANGE:
                text = @"Changeup";
                break;
            case SPLITTER:
                text = @"Splitter";
                break;
            default:
                text = @"Unknown";
                break;
        }
        
        pitch = [ [SelectableLabel alloc] initWithStr:text ];
        [ _pitchLabels addObject:pitch ];
    }
    
    _addButton = [ [UILabel alloc] init ];
    _addButton.text = @"Add Player";
    _addButton.textColor = [ UIColor lightTextColor ];
    _addButton.textAlignment = NSTextAlignmentCenter;
    UIFont *font = _addButton.font;
    font = [ font fontWithSize:25 ];
    _addButton.font = font;
    
    [ self addSubview:_firstInput ];
    [ self addSubview:_lastInput ];
    
    [ self addSubview:_ageInput ];
    [ self addSubview:_heightFInput ];
    [ self addSubview:_heightIInput ];
    [ self addSubview:_weightInput ];
    
    [ self addSubview:_jerseryInput ];
    [ self addSubview:_leftLabel ];
    [ self addSubview:_rightLabel ];
    
    for( int i = 0; i < COUNTPITCHES; i++ )
        [ self addSubview:[ _pitchLabels objectAtIndex:i ] ];
    
    [ self addSubview:_addButton ];
}

-(void) layoutFields
{
    CGFloat width = self.frame.size.width;
    
    //Row 0
    width -= 2*EDGE_INSET + COL_PAD;
    width = width/2;
    
    CGRect f = CGRectMake(EDGE_INSET, EDGE_INSET, width, INPUT_HEIGHT);
    [ _firstInput setFrame:f ];
    
    f.origin.x += width + COL_PAD;
    [ _lastInput setFrame:f ];
    
    //Row 1
    width = self.frame.size.width;
    width -= 2*EDGE_INSET + 3*COL_PAD;
    width = width/4;
    
    f.origin.x = EDGE_INSET;
    f.origin.y += ROW_PAD + INPUT_HEIGHT;
    f.size.width = width;
    [ _ageInput setFrame:f ];
    
    f.origin.x += width + COL_PAD;
    [ _heightFInput setFrame:f];
    
    f.origin.x += width + COL_PAD;
    [ _heightIInput setFrame:f ];
    
    f.origin.x += width + COL_PAD;
    [ _weightInput setFrame:f ];
    
    //Row 2
    width = self.frame.size.width;
    width -= 2*EDGE_INSET + 2*COL_PAD;
    width = width/3;
    
    f.origin.x = EDGE_INSET;
    f.origin.y += ROW_PAD + INPUT_HEIGHT;
    f.size.width = width;
    [ _jerseryInput setFrame:f ];
    
    f.origin.x += width + COL_PAD;
    [ _leftLabel setFrame:f];
    
    f.origin.x += width + COL_PAD;
    [ _rightLabel setFrame:f ];
    
    //Row 3
    width = self.frame.size.width;
    width -= 2*EDGE_INSET + 3*COL_PAD;
    width = width/4;
    
    f.origin.y += ROW_PAD + INPUT_HEIGHT;
    f.size.width = width;
    
    for( int i = 0; i < 4; i++ )
    {
        f.origin.x = i*( width + COL_PAD ) + EDGE_INSET;
        [ [_pitchLabels objectAtIndex:i] setFrame:f ];
    }
        
    
    //Row 4
    f.origin.y += ROW_PAD + INPUT_HEIGHT;
    f.size.width = width;
    
    for( int i = 0; i < 4; i++ )
    {
        f.origin.x = i*( width + COL_PAD ) + EDGE_INSET;
        [ [_pitchLabels objectAtIndex:(i + 4)] setFrame:f ];
    }
    
    //Row 5
    width = self.frame.size.width;
    width -= 2*EDGE_INSET + 3*COL_PAD;
    width = width/3;
    
    f.origin.x = EDGE_INSET + width + COL_PAD;
    f.origin.y += 2*ROW_PAD + INPUT_HEIGHT;
    f.size.width = width;
    
    [ _addButton setFrame:f ];
}

-(void) setFrame:(CGRect)frame
{
    [ super setFrame:frame ];
    [ self layoutFields ];
}

-(void) presentFieldsNew
{
    
}

-(void) presentFieldsEdit:(Pitcher*) pitcher
{
    
}

-(void) aboutToShow:(TeamNames) curr_team
{
    _firstInput.hidden = NO;
    _lastInput.hidden = NO;
}

-(void) addPitcherToDatabase:(Pitcher*) new_arm
{
    //TODO - confirm they want to add
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    [ database addPitcher:new_arm ];
}

-(void) editPitcherInDatabase:(Pitcher*) pitcher
{
    //TODO - confirm save
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    [ database editPitcher:pitcher ];
}

-(bool) checkTouchInSelectableLabels:(CGPoint) tap
{
    bool ret = false;
    if( CGRectContainsPoint(_leftLabel.frame, tap) )
    {
        if( !_leftLabel.selected )
        {
            [ _leftLabel toggleSelected ];
            [ _rightLabel toggleSelected ];
        }
    }
    else if( CGRectContainsPoint(_rightLabel.frame, tap) )
    {
        if( !_rightLabel.selected )
        {
            [ _leftLabel toggleSelected ];
            [ _rightLabel toggleSelected ];
        }
    }
    else if( CGRectContainsPoint(_addButton.frame, tap) )
    {
        return true;
    }
    else
    {
        SelectableLabel *label;
        for( int i = 0; i < COUNTPITCHES; i++ )
        {
            label = [ _pitchLabels objectAtIndex:i ];
            if( CGRectContainsPoint( label.frame , tap) )
            {
                [ label toggleSelected ];
                break;
            }
        }
    }
    
    return ret;
}

@end
