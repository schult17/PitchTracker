//
//  NewPitcherView.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-30.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "Pitcher.h"
#import "LocalPitcherDatabase.h"
#import "CustomTextFields.h"

@interface EditPitcherView : UIView

@property CustomTextFields *firstInput;
@property CustomTextFields *lastInput;

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(void) createFields;
-(void) presentFieldsNew;
-(void) presentFieldsEdit:(Pitcher*) pitcher;
-(void) aboutToShow:(TeamNames) curr_team;
-(void) addPitcherToDatabase:(Pitcher*) new_arm;
-(void) editPitcherInDatabase:(Pitcher*) pitcher;


@end
