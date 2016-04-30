//
//  ViewController.h
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalPitcherDatabase.h"
#import "Pitcher.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *gameButton;

@property (strong, nonatomic) IBOutlet UIButton *manageButton;

@property (strong, nonatomic) IBOutlet UIButton *statsButton;

@end

