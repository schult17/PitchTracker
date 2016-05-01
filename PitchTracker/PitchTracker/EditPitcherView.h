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
#import "CustomTextField.h"
#import "SelectableLabel.h"

#define EDGE_INSET 80
#define COL_PAD 50
#define ROW_PAD 50
#define INPUT_HEIGHT 50

@interface EditPitcherView : UIView

@property CustomTextField *firstInput;
@property CustomTextField *lastInput;

@property CustomTextField *ageInput;
@property CustomTextField *heightFInput;
@property CustomTextField *heightIInput;
@property CustomTextField *weightInput;

@property CustomTextField *jerseryInput;
@property SelectableLabel *leftLabel;
@property SelectableLabel *rightLabel;

@property UILabel *addButton;

@property NSMutableArray* pitchLabels;

-(id) init;
-(id) initWithFrame:(CGRect)frame;
-(void) createFields;
-(void) presentFieldsNew;
-(void) presentFieldsEdit:(Pitcher*) pitcher;
-(void) aboutToShow:(TeamNames) curr_team;
-(void) layoutFields;
-(void) setFrame:(CGRect)frame;
-(void) clearFields;
-(bool) checkTouchInSelectableLabels:(CGPoint) tap; //return refresh update
-(Pitcher*) getPitcherWithInfo:(TeamNames) team;

@end
