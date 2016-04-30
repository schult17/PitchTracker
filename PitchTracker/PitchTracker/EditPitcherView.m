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

-(void) createFields
{
    CGRect f = CGRectMake(25, 25, 120, 20);
    CGRect f2 = f;
    f.origin.x += 150;
    
    _firstInput = [ [CustomTextFields alloc] initWithFrameAndString:f with:@"First Name" ];
    _lastInput = [ [CustomTextFields alloc] initWithFrameAndString:f2 with:@"Last Name" ];
    
    _firstInput.delegate = self;
    _lastInput.delegate = self;
    
    
    [ self addSubview:_firstInput ];
    [ self addSubview:_lastInput ];
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


@end
