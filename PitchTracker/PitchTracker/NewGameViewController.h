//
//  NewGameViewController.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface NewGameViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *team1Button;
@property (strong, nonatomic) IBOutlet UIButton *team2Button;
@property (strong, nonatomic) IBOutlet UIButton *startGameButton;
@property (strong, nonatomic) IBOutlet UIPickerView *teamPicker;

@property TeamNames team1;
@property TeamNames team2;

@property int button_num;

@end
